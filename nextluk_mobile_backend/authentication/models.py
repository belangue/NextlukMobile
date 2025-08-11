from mongoengine import Document, StringField, EmailField, BooleanField, DateTimeField, IntField, DecimalField, ListField, DictField, ReferenceField, ValidationError
from datetime import datetime
import re
from werkzeug.security import generate_password_hash, check_password_hash

class User(Document):
    CLIENT = 'client'
    HAIRDRESSER = 'hairdresser'
    SALON_MANAGER = 'salon_manager'
    ADMIN = 'admin'
    
    USER_ROLES = [
        (CLIENT, 'Client'),
        (HAIRDRESSER, 'Hairdresser'),
        (SALON_MANAGER, 'Salon Manager'),
        (ADMIN, 'Admin'),
    ]
    
    # Basic user fields
    username = StringField(max_length=150, required=True, unique=True)
    email = EmailField(required=True, unique=True)
    password = StringField(required=True, max_length=1028)
    first_name = StringField(max_length=30, default='')
    last_name = StringField(max_length=150, default='')
    
    # Custom fields
    phone_number = StringField(max_length=17, default='')
    role = StringField(max_length=20, choices=[choice[0] for choice in USER_ROLES], default=CLIENT)
    profile_picture = StringField(default='')  # Store file path or URL
    is_verified = BooleanField(default=False)
    is_active = BooleanField(default=True)
    is_staff = BooleanField(default=False)
    is_superuser = BooleanField(default=False)
    
    # Timestamps
    created_at = DateTimeField(default=datetime.utcnow)
    updated_at = DateTimeField(default=datetime.utcnow)
    last_login = DateTimeField()
    date_joined = DateTimeField(default=datetime.utcnow)
    
    # Role-specific fields
    salon_id = StringField(max_length=100, default='')  # For hairdressers and salon managers
    specialties = ListField(StringField(), default=list)  # For hairdressers
    experience_years = IntField(default=0)  # For hairdressers
    bio = StringField(default='')
    
    meta = {
        'collection': 'users',
        'indexes': [
            'email',
            'username',
            'role',
            'salon_id',
            'created_at'
        ]
    }
    
    def clean(self):
        """Validate phone number format"""
        if self.phone_number:
            phone_regex = re.compile(r'^\+?1?\d{9,15}$')
            if not phone_regex.match(self.phone_number):
                raise ValidationError("Phone number must be entered in the format: '+999999999'. Up to 15 digits allowed.")
    
    def set_password(self, raw_password):
        """Hash and set password"""
        self.password = generate_password_hash(raw_password)
    
    def check_password(self, raw_password):
        """Check password against hash"""
        return check_password_hash(self.password, raw_password)
    
    def get_role_display(self):
        """Get human-readable role name"""
        role_dict = dict(self.USER_ROLES)
        return role_dict.get(self.role, self.role)
    
    def save(self, *args, **kwargs):
        """Override save to update timestamp and validate"""
        self.updated_at = datetime.utcnow()
        return super().save(*args, **kwargs)
    
    def __str__(self):
        return f"{self.email} - {self.get_role_display()}"
    
    def __repr__(self):
        return f"<User: {self.username} ({self.email})>"


class Salon(Document):
    name = StringField(max_length=200, required=True)
    description = StringField(default='')
    address = StringField(required=True)
    phone_number = StringField(max_length=17, required=True)
    email = EmailField(required=True)
    manager = ReferenceField(User, required=True, reverse_delete_rule=2)  # CASCADE delete
    services = ListField(StringField(), default=list)
    operating_hours = DictField(default=dict)
    rating = DecimalField(min_value=0, max_value=5, precision=2, default=0.0)
    created_at = DateTimeField(default=datetime.utcnow)
    updated_at = DateTimeField(default=datetime.utcnow)
    
    meta = {
        'collection': 'salons',
        'indexes': [
            'name',
            'manager',
            'rating',
            'created_at'
        ]
    }
    
    def clean(self):
        """Validate that manager has appropriate role"""
        if self.manager and self.manager.role not in [User.SALON_MANAGER, User.ADMIN]:
            raise ValidationError("Manager must have 'salon_manager' or 'admin' role")
    
    def save(self, *args, **kwargs):
        """Override save to update timestamp"""
        self.updated_at = datetime.utcnow()
        return super().save(*args, **kwargs)
    
    def __str__(self):
        return self.name
    
    def __repr__(self):
        return f"<Salon: {self.name}>"