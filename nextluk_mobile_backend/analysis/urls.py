from django.urls import path
from . import views

urlpatterns = [
    path('hairstyle-analysis/', views.HairstyleAnalysisListCreateView.as_view(), name='hairstyle-analysis'),
]
