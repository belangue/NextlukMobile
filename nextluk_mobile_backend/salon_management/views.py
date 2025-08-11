from django.shortcuts import render
from rest_framework_mongoengine import generics
from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from mongoengine import Q
from .models import Service, Booking
from .serializers import ServiceSerializer, BookingSerializer, CreateBookingSerializer
from authentication.permissions import IsClientRole, IsHairdresserRole, IsSalonManagerRole

class ServiceListCreateView(generics.ListCreateAPIView):
    serializer_class = ServiceSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        queryset = Service.objects.all()
        salon_id = self.request.query_params.get('salon_id')
        if salon_id:
            queryset = queryset.filter(salon=salon_id)
        return queryset

class BookingListCreateView(generics.ListCreateAPIView):
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        user = self.request.user
        if user.role == 'client':
            return Booking.objects.filter(client=user)
        elif user.role == 'hairdresser':
            return Booking.objects.filter(hairdresser=user)
        elif user.role == 'salon_manager':
            return Booking.objects.filter(salon__manager=user)
        return Booking.objects.none()
    
    def get_serializer_class(self):
        if self.request.method == 'POST':
            return CreateBookingSerializer
        return BookingSerializer

@api_view(['PUT'])
@permission_classes([IsAuthenticated])
def update_booking_status(request, booking_id):
    try:
        booking = Booking.objects.get(id=booking_id)
        
        # Check permissions
        if (request.user.role == 'hairdresser' and booking.hairdresser == request.user) or \
           (request.user.role == 'salon_manager' and booking.salon.manager == request.user) or \
           (request.user.role == 'client' and booking.client == request.user):
            
            new_status = request.data.get('status')
            if new_status in [choice[0] for choice in Booking.STATUS_CHOICES]:
                booking.status = new_status
                booking.save()
                return Response(BookingSerializer(booking).data)
            else:
                return Response({'error': 'Invalid status'}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({'error': 'Permission denied'}, status=status.HTTP_403_FORBIDDEN)
    
    except Booking.DoesNotExist:
        return Response({'error': 'Booking not found'}, status=status.HTTP_404_NOT_FOUND)