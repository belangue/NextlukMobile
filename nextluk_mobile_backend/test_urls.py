import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'nextluk.settings')
django.setup()

from django.urls import resolve
from django.urls.exceptions import Resolver404

try:
    match = resolve('/api/auth/login/')
    print(f"URL resolved to: {match.func.__name__}")
    print(f"View: {match.func}")
    print(f"Args: {match.args}")
    print(f"Kwargs: {match.kwargs}")
except Resolver404 as e:
    print(f"URL not found: {e}")