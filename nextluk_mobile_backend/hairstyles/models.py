from mongoengine import Document, StringField, DateTimeField, ListField, FloatField
from datetime import datetime

class Hairstyles(Document):
    meta = {"collection": "hairstyles"}
    
    title = StringField(required=True, max_length=120)
    description = StringField(default="")
    category = StringField(default="")           # ✅ New field
    price = FloatField(default=0.0)              # ✅ New field
    image_filename = StringField(required=True)
    created_by_id = StringField(required=True)
    tags = ListField(StringField(), default=list)
    rating = FloatField(default=0.0)

    created_at = DateTimeField(default=datetime.utcnow)
    updated_at = DateTimeField(default=datetime.utcnow)

    def save(self, *args, **kwargs):
        self.updated_at = datetime.utcnow()
        return super().save(*args, **kwargs)

    @property
    def image_url(self):
        return f"/media/hairstyles/{self.image_filename}"

    def to_dict(self, request=None):
        """Convert model to dictionary with consistent field names for API"""
        # Build absolute URL for image
        if request:
            image_url = request.build_absolute_uri(f"/media/hairstyles/{self.image_filename}")
        else:
            image_url = f"/media/hairstyles/{self.image_filename}"
        
        return {
            "id": str(self.id),
            "title": self.title,
            "description": self.description,
            "category": self.category,
            "price": self.price,
            "image_url": image_url,                    # ✅ FIXED: Use snake_case for consistency
            "image_filename": self.image_filename,     # Keep original filename
            "created_by": self.created_by_id,          # ✅ FIXED: Use consistent naming
            "tags": self.tags,
            "rating": self.rating,
            "created_at": self.created_at.isoformat(),
            "updated_at": self.updated_at.isoformat(),
        }
