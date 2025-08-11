from rest_framework_mongoengine import serializers
from .models import HairstyleAnalysis

class HairstyleAnalysisSerializer(serializers.DocumentSerializer):
    class Meta:
        model = HairstyleAnalysis
        fields = '__all__'
        read_only_fields = ['user']