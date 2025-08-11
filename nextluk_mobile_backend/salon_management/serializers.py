from rest_framework_mongoengine import serializers
from .models import Service, Booking
from authentication.serializers import UserProfileSerializer, SalonSerializer

class ServiceSerializer(serializers.DocumentSerializer):
    class Meta:
        model = Service
        fields = '__all__'

class BookingSerializer(serializers.DocumentSerializer):
    client = UserProfileSerializer(read_only=True)
    hairdresser = UserProfileSerializer(read_only=True)
    salon = SalonSerializer(read_only=True)
    service = ServiceSerializer(read_only=True)
    
    class Meta:
        model = Booking
        fields = '__all__'

class CreateBookingSerializer(serializers.DocumentSerializer):
    class Meta:
        model = Booking
        fields = ['hairdresser', 'salon', 'service', 'appointment_date', 'notes']
    
    def create(self, validated_data):
        validated_data['client'] = self.context['request'].user
        service = validated_data['service']
        validated_data['total_price'] = service.price
        return super().create(validated_data)