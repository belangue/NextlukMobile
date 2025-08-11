from rest_framework import serializers
from django.contrib.auth import authenticate
from .models import User, Salon

class UserRegistrationSerializer(serializers.Serializer):
    email = serializers.EmailField()
    username = serializers.CharField(max_length=150)
    password = serializers.CharField(write_only=True)
    password_confirm = serializers.CharField(write_only=True)
    role = serializers.CharField(max_length=50)
    phone_number = serializers.CharField(max_length=15, required=False)
    first_name = serializers.CharField(max_length=30, required=False)
    last_name = serializers.CharField(max_length=30, required=False)
    bio = serializers.CharField(required=False)
    specialties = serializers.CharField(required=False)
    experience_years = serializers.IntegerField(required=False)
    salon_id = serializers.CharField(required=False)
    
    def validate(self, attrs):
        if attrs['password'] != attrs['password_confirm']:
            raise serializers.ValidationError("Passwords don't match.")
        return attrs
    
    def create(self, validated_data):
        validated_data.pop('password_confirm')
        password = validated_data.pop('password')
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        return user

class UserLoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField()
    
    def validate(self, attrs):
        email = attrs.get('email')
        password = attrs.get('password')
        
        if email and password:
            user = authenticate(request=self.context.get('request'),
                              username=email, password=password)
            if not user:
                raise serializers.ValidationError('Invalid login credentials.')
            if not user.is_active:
                raise serializers.ValidationError('User account is disabled.')
            attrs['user'] = user
            return attrs
        else:
            raise serializers.ValidationError('Must include email and password.')

class UserProfileSerializer(serializers.Serializer):
    id = serializers.CharField(read_only=True)
    email = serializers.EmailField(read_only=True)
    username = serializers.CharField(max_length=150)
    first_name = serializers.CharField(max_length=30, required=False)
    last_name = serializers.CharField(max_length=30, required=False)
    phone_number = serializers.CharField(max_length=15, required=False)
    role = serializers.CharField(read_only=True)
    profile_picture = serializers.CharField(required=False)
    bio = serializers.CharField(required=False)
    specialties = serializers.CharField(required=False)
    experience_years = serializers.IntegerField(required=False)
    salon_id = serializers.CharField(required=False)
    is_verified = serializers.BooleanField(read_only=True)
    
    def update(self, instance, validated_data):
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()
        return instance

class SalonSerializer(serializers.Serializer):
    id = serializers.CharField(read_only=True)
    name = serializers.CharField(max_length=200)
    address = serializers.CharField()
    phone_number = serializers.CharField(max_length=15)
    email = serializers.EmailField(required=False)
    description = serializers.CharField(required=False)
    manager = UserProfileSerializer(read_only=True)
    
    def create(self, validated_data):
        return Salon.objects.create(**validated_data)
    
    def update(self, instance, validated_data):
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()
        return instance