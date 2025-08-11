from rest_framework import permissions

class IsOwnerOrReadOnly(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True
        return obj.owner == request.user

class IsClientRole(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user.role == 'client'

class IsHairdresserRole(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user.role == 'hairdresser'

class IsSalonManagerRole(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user.role == 'salon_manager'

class IsAdminRole(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user.role == 'admin'