import cv2
import numpy as np
from sklearn.cluster import KMeans
from typing import Dict, List, Tuple

class HairAnalysisService:
    def __init__(self):
        self.hair_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
    
    def analyze_hair(self, image_path: str, face_landmarks: Dict = None) -> Dict:
        """Analyze hair type, texture, and color from image"""
        try:
            image = cv2.imread(image_path)
            if image is None:
                raise ValueError("Could not load image")
            
            # Detect hair region
            hair_region = self._detect_hair_region(image, face_landmarks)
            
            if hair_region is None:
                return {"error": "Could not detect hair region"}
            
            # Analyze hair properties
            hair_type = self._classify_hair_type(hair_region)
            hair_texture = self._analyze_hair_texture(hair_region)
            hair_color = self._analyze_hair_color(hair_region)
            hair_length = self._estimate_hair_length(image, face_landmarks)
            
            return {
                "hair_type": hair_type,
                "hair_texture": hair_texture,
                "hair_color": hair_color,
                "hair_length": hair_length
            }
            
        except Exception as e:
            return {"error": str(e)}
    
    def _detect_hair_region(self, image: np.ndarray, face_landmarks: Dict = None) -> np.ndarray:
        """Detect hair region in the image"""
        if face_landmarks:
            # Use face landmarks to determine hair region
            return self._extract_hair_from_landmarks(image, face_landmarks)
        else:
            # Fallback: use face detection and estimate hair region
            gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
            faces = self.hair_cascade.detectMultiScale(gray, 1.1, 4)
            
            if len(faces) > 0:
                x, y, w, h = faces[0]
                # Estimate hair region above the face
                hair_y = max(0, y - h//2)
                hair_region = image[hair_y:y+h//4, x:x+w]
                return hair_region
            
            return None
    
    def _extract_hair_from_landmarks(self, image: np.ndarray, landmarks: Dict) -> np.ndarray:
        """Extract hair region using facial landmarks"""
        # Get forehead points to estimate hair region
        forehead_top = landmarks.get('forehead_top', {})
        forehead_left = landmarks.get('forehead_left', {})
        forehead_right = landmarks.get('forehead_right', {})
        
        if not all([forehead_top, forehead_left, forehead_right]):
            return None
        
        # Define hair region based on forehead landmarks
        y1 = max(0, forehead_top['y'] - 100)
        y2 = forehead_top['y'] + 20
        x1 = forehead_left['x']
        x2 = forehead_right['x']
        
        return image[y1:y2, x1:x2]
    
    def _classify_hair_type(self, hair_region: np.ndarray) -> str:
        """Classify hair type based on curl pattern"""
        # Convert to grayscale
        gray = cv2.cvtColor(hair_region, cv2.COLOR_BGR2GRAY)
        
        # Apply Gaussian blur
        blurred = cv2.GaussianBlur(gray, (5, 5), 0)
        
        # Detect edges to analyze hair pattern
        edges = cv2.Canny(blurred, 50, 150)
        
        # Analyze edge patterns to determine curl
        contours, _ = cv2.findContours(edges, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
        
        if not contours:
            return "straight"
        
        # Calculate curvature metrics
        total_curvature = 0
        for contour in contours[:10]:  # Analyze top 10 contours
            if len(contour) > 10:
                # Approximate contour to polygon
                epsilon = 0.02 * cv2.arcLength(contour, True)
                approx = cv2.approxPolyDP(contour, epsilon, True)
                
                # Calculate curvature based on polygon approximation
                curvature = len(contour) / max(len(approx), 1)
                total_curvature += curvature
        
        avg_curvature = total_curvature / max(len(contours[:10]), 1)
        
        # Classify based on curvature
        if avg_curvature < 3:
            return "straight"
        elif avg_curvature < 6:
            return "wavy"
        elif avg_curvature < 10:
            return "curly"
        else:
            return "coily"
    
    def _analyze_hair_texture(self, hair_region: np.ndarray) -> str:
        """Analyze hair texture (fine, medium, coarse)"""
        # Convert to grayscale
        gray = cv2.cvtColor(hair_region, cv2.COLOR_BGR2GRAY)
        
        # Calculate texture using Local Binary Pattern concept
        # Simplified approach: analyze variance in pixel intensities
        variance = np.var(gray)
        
        if variance < 100:
            return "fine"
        elif variance < 300:
            return "medium"
        else:
            return "coarse"
    
    def _analyze_hair_color(self, hair_region: np.ndarray) -> str:
        """Analyze dominant hair color"""
        # Reshape image for K-means clustering
        pixels = hair_region.reshape((-1, 3))
        
        # Use K-means to find dominant colors
        kmeans = KMeans(n_clusters=3, random_state=42, n_init=10)
        kmeans.fit(pixels)
        
        # Get the most dominant color (largest cluster)
        labels = kmeans.labels_
        unique, counts = np.unique(labels, return_counts=True)
        dominant_cluster = unique[np.argmax(counts)]
        dominant_color = kmeans.cluster_centers_[dominant_cluster]
        
        # Convert BGR to RGB
        r, g, b = int(dominant_color[2]), int(dominant_color[1]), int(dominant_color[0])
        
        # Classify color
        return self._classify_hair_color_name(r, g, b)
    
    def _classify_hair_color_name(self, r: int, g: int, b: int) -> str:
        """Classify RGB color to hair color name"""
        # Simple hair color classification
        brightness = (r + g + b) / 3
        
        if brightness < 50:
            return "black"
        elif brightness < 100:
            if r > g and r > b:
                return "dark_brown"
            else:
                return "black"
        elif brightness < 150:
            if r > g + 20:
                return "brown"
            else:
                return "dark_brown"
        elif brightness < 200:
            if r > g + 30:
                return "light_brown"
            elif g > r + 10:
                return "blonde"
            else:
                return "brown"
        else:
            if r > 200 and g > 180:
                return "blonde"
            elif r > 180:
                return "red"
            else:
                return "grey"
    
    def _estimate_hair_length(self, image: np.ndarray, face_landmarks: Dict = None) -> str:
        """Estimate hair length relative to face"""
        if not face_landmarks:
            return "unknown"
        
        forehead_top = face_landmarks.get('forehead_top', {})
        chin = face_landmarks.get('chin', {})
        
        if not forehead_top or not chin:
            return "unknown"
        
        face_height = abs(chin['y'] - forehead_top['y'])
        
        # Simple estimation based on visible hair in relation to face height
        # This is a simplified approach - in practice, you'd need more sophisticated analysis
        hair_visible_height = max(0, forehead_top['y'])
        hair_to_face_ratio = hair_visible_height / max(face_height, 1)
        
        if hair_to_face_ratio < 0.3:
            return "short"
        elif hair_to_face_ratio < 0.8:
            return "medium"
        else:
            return "long"