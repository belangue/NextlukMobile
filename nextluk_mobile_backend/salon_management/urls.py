from django.urls import path
from . import views

urlpatterns = [
    path('services/', views.ServiceListCreateView.as_view(), name='service-list-create'),
    path('bookings/', views.BookingListCreateView.as_view(), name='booking-list-create'),
    path('bookings/<str:booking_id>/status/', views.update_booking_status, name='update-booking-status'),
]