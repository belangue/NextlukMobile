from django.shortcuts import render
# analysis/views.py
from rest_framework_mongoengine import generics
from rest_framework.permissions import IsAuthenticated
from .models import HairstyleAnalysis
from .serializers import HairstyleAnalysisSerializer

class HairstyleAnalysisListCreateView(generics.ListCreateAPIView):
    serializer_class = HairstyleAnalysisSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        return HairstyleAnalysis.objects.filter(user=self.request.user)
    
    def perform_create(self, serializer):
        serializer.save(user=self.request.user)