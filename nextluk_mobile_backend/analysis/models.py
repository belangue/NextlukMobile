from mongoengine import Document, ReferenceField, URLField, StringField, ListField, DictField, DateTimeField
from datetime import datetime
# from authentication.models import User  # Make sure this is also a MongoEngine Document

class HairstyleAnalysis(Document):
    # user = ReferenceField(User, required=True, reverse_delete_rule=2)  # CASCADE delete
    image_url = URLField(required=True)
    face_shape = StringField(max_length=50, required=True)
    recommended_styles = ListField(default=list)
    analysis_data = DictField(default=dict)  # Store detailed analysis results
    created_at = DateTimeField(default=datetime.utcnow)
    
    # MongoDB collection name (optional - defaults to lowercase class name)
    meta = {
        'collection': 'analysis',
        'indexes': [
            'user',
            'created_at',
            'face_shape'
        ]
    }
    
    def __str__(self):
        return f"{self.user.username} - {self.face_shape} - {self.created_at}"
    
    def __repr__(self):
        return f"<HairstyleAnalysis: {self.user.username} - {self.face_shape}>"