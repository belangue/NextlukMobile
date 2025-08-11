from mongoengine import Document, EmbeddedDocument, fields
from datetime import datetime
from authentication.models import User, Salon

class Service(Document):
    name = fields.StringField(max_length=100, required=True)
    description = fields.StringField()
    price = fields.DecimalField(min_value=0, precision=2)
    duration_minutes = fields.IntField(min_value=0)
    salon = fields.ReferenceField(Salon, required=True)
    created_at = fields.DateTimeField(default=datetime.utcnow)
    
    meta = {
        'collection': 'services',
        'indexes': ['salon', 'created_at']
    }
    
    def __str__(self):
        return f"{self.name} - {self.salon.name}"

class Booking(Document):
    PENDING = 'pending'
    CONFIRMED = 'confirmed'
    COMPLETED = 'completed'
    CANCELLED = 'cancelled'
    
    STATUS_CHOICES = [
        (PENDING, 'Pending'),
        (CONFIRMED, 'Confirmed'),
        (COMPLETED, 'Completed'),
        (CANCELLED, 'Cancelled'),
    ]
    
    client = fields.ReferenceField(User, required=True)
    hairdresser = fields.ReferenceField(User, required=True)
    salon = fields.ReferenceField(Salon, required=True)
    service = fields.ReferenceField(Service, required=True)
    appointment_date = fields.DateTimeField(required=True)
    status = fields.StringField(
        max_length=20, 
        choices=[choice[0] for choice in STATUS_CHOICES], 
        default=PENDING
    )
    notes = fields.StringField()
    total_price = fields.DecimalField(min_value=0, precision=2)
    created_at = fields.DateTimeField(default=datetime.utcnow)
    updated_at = fields.DateTimeField(default=datetime.utcnow)
    
    meta = {
        'collection': 'bookings',
        'indexes': [
            'client', 'hairdresser', 'salon', 'appointment_date', 
            'status', 'created_at'
        ]
    }
    
    def save(self, *args, **kwargs):
        self.updated_at = datetime.utcnow()
        return super().save(*args, **kwargs)
    
    def __str__(self):
        return f"{self.client.username} - {self.service.name} - {self.appointment_date}"