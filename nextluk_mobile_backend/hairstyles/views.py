from django.utils.decorators import method_decorator
from django.views.decorators.csrf import csrf_exempt
from django.views import View
from django.http import JsonResponse, HttpResponseNotAllowed
from datetime import datetime
import json
from .models import Hairstyles  # Fixed: your model is called Hairstyles (plural)
from authentication.decorators import auth_required, require_roles
from mongoengine import Q

def _json(request):
    """Helper to parse JSON from request"""
    if request.content_type and "application/json" in request.content_type:
        try:
            return json.loads(request.body.decode() or "{}")
        except Exception:
            return {}
    return request.POST

def _parse_tags(tags_str):
    """Helper to parse tags"""
    if not tags_str:
        return []
    if isinstance(tags_str, list):
        return tags_str
    return [tag.strip() for tag in tags_str.split(',') if tag.strip()]

def _save_image(image):
    """Helper to save image - returns just the filename"""
    if not image:
        return ""
    return image.name  # or implement your actual image saving logic here


@method_decorator(csrf_exempt, name="dispatch")
class HairstyleListCreateView(View):
    # GET /api/hairstyles/ -> list (public)
    def get(self, request):
        try:
            # Check if there's a search query
            query = request.GET.get('q', '')
            category = request.GET.get('category', '')
            min_price = request.GET.get('min_price', '')
            max_price = request.GET.get('max_price', '')
            
            # Start with all hairstyles
            hairstyles = Hairstyles.objects
            
            # Apply search filters
            if query:
                hairstyles = hairstyles.filter(
                    Q(title__icontains=query) | 
                    Q(description__icontains=query) | 
                    Q(tags__icontains=query)
                )
            
            if category:
                hairstyles = hairstyles.filter(category__icontains=category)
                
            if min_price:
                try:
                    min_price = float(min_price)
                    hairstyles = hairstyles.filter(price__gte=min_price)
                except ValueError:
                    pass
                    
            if max_price:
                try:
                    max_price = float(max_price)
                    hairstyles = hairstyles.filter(price__lte=max_price)
                except ValueError:
                    pass
            
            items = [h.to_dict(request) for h in hairstyles.order_by("-created_at")]
            return JsonResponse({"results": items})
        except Exception as e:
            print(f"DEBUG: Error getting hairstyles: {str(e)}")
            return JsonResponse({"detail": f"Failed to load hairstyles: {str(e)}"}, status=500)

    # POST /api/hairstyles/ -> create (stylist/admin only)
    @method_decorator(auth_required)
    @method_decorator(require_roles("hairdresser", "salon_manager", "admin"))
    def post(self, request):
        try:
            # Handle both form data and JSON
            if request.content_type and 'multipart/form-data' in request.content_type:
                data = request.POST.dict()
            else:
                data = _json(request)
            
            title = data.get("title", "").strip()
            description = data.get("description", "").strip()
            created_by_id = data.get("created_by_id") or data.get("createdById", "").strip()
            tags = _parse_tags(data.get("tags", ""))
            rating = float(data.get("rating", 0))

            # New fields
            category = data.get("category", "").strip()
            price = float(data.get("price", 0))

            image = request.FILES.get("image")
            image_filename = _save_image(image) if image else data.get("image_filename", "default.jpg")

            if not title or not created_by_id:
                return JsonResponse({"detail": "title and created_by_id are required"}, status=400)

            h = Hairstyles(
                title=title,
                description=description,
                created_by_id=created_by_id,
                tags=tags,
                rating=rating,
                category=category,
                price=price,
                image_filename=image_filename,
            )
            h.save()

            return JsonResponse(h.to_dict(request), status=201)
        except Exception as e:
            print(f"DEBUG: Error creating hairstyle: {str(e)}")
            return JsonResponse({"detail": f"Failed to create hairstyle: {str(e)}"}, status=500)


@method_decorator(csrf_exempt, name="dispatch")
class HairstyleDetailView(View):
    # GET /api/hairstyles/<id>/ -> detail (public)
    def get(self, request, pk):
        try:
            h = Hairstyles.objects(id=pk).first()
            if not h:
                return JsonResponse({"detail": "Not found"}, status=404)
            return JsonResponse(h.to_dict(request))
        except Exception as e:
            print(f"DEBUG: Error getting hairstyle detail: {str(e)}")
            return JsonResponse({"detail": f"Failed to load hairstyle: {str(e)}"}, status=500)

    # PUT/PATCH -> update (stylist/admin)
    @method_decorator(auth_required)
    @method_decorator(require_roles("hairdresser", "salon_manager", "admin"))
    def put(self, request, pk): 
        return self._update(request, pk)

    @method_decorator(auth_required)
    @method_decorator(require_roles("hairdresser", "salon_manager", "admin"))
    def patch(self, request, pk): 
        return self._update(request, pk)

    def _update(self, request, pk):
        try:
            h = Hairstyles.objects(id=pk).first()
            if not h:
                return JsonResponse({"detail": "Not found"}, status=404)

            if request.content_type and 'multipart/form-data' in request.content_type:
                data = request.POST.dict()
            else:
                data = _json(request)
            
            title = data.get("title")
            description = data.get("description")
            created_by_id = data.get("created_by_id") or data.get("createdById")
            tags = data.get("tags")
            rating = data.get("rating")
            category = data.get("category")
            price = data.get("price")
            image = request.FILES.get("image")

            if title is not None: 
                h.title = title
            if description is not None: 
                h.description = description
            if created_by_id is not None: 
                h.created_by_id = created_by_id
            if tags is not None: 
                h.tags = _parse_tags(tags)
            if rating is not None:
                try: 
                    h.rating = float(rating)
                except: 
                    pass
            if category is not None:
                h.category = category
            if price is not None:
                try:
                    h.price = float(price)
                except:
                    pass
            if image:
                h.image_filename = _save_image(image)

            h.updated_at = datetime.utcnow()
            h.save()
            return JsonResponse(h.to_dict(request))
        except Exception as e:
            print(f"DEBUG: Error updating hairstyle: {str(e)}")
            return JsonResponse({"detail": f"Failed to update hairstyle: {str(e)}"}, status=500)

    # DELETE (stylist/admin)
    @method_decorator(auth_required)
    @method_decorator(require_roles("hairdresser", "salon_manager", "admin"))
    def delete(self, request, pk):
        try:
            h = Hairstyles.objects(id=pk).first()
            if not h:
                return JsonResponse({"detail": "Not found"}, status=404)
            h.delete()
            return JsonResponse({"deleted": True, "id": pk}, status=204)
        except Exception as e:
            print(f"DEBUG: Error deleting hairstyle: {str(e)}")
            return JsonResponse({"detail": f"Failed to delete hairstyle: {str(e)}"}, status=500)
