import cv2
import mediapipe as mp
import numpy as np
from typing import Dict, Tuple, Optional
import math

class FaceDetectionService:
    def __init__(self):
        self.mp_face_mesh = mp.solutions.face_mesh
        self.mp_drawing = mp.solutions.drawing_utils
        self.face_mesh = self.mp_face_mesh.FaceMesh(
            static_image_mode=True,
            max_num_faces=1,
            refine_landmarks=True,
            min_detection_confidence=0.5,
            min_tracking_confidence=0.5
        )
    
    def detect_face_shape(self, image_path: str) -> Dict:
        """Detect face shape from image"""
        try:
            image = cv2.imread(image_path)
            if image is None:
                raise ValueError("Could not load image")
            
            image_rgb = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
            results = self.face_mesh.process(image_rgb)
            
            if not results.multi_face_landmarks:
                return {"error": "No face detected"}
            
            landmarks = results.multi_face_landmarks[0]
            h, w = image.shape[:2]
            
            # Extract key facial points
            key_points = self._extract_key_points(landmarks, w, h)
            
            # Calculate face measurements
            measurements = self._calculate_face_measurements(key_points)
            
            # Determine face shape
            face_shape, confidence = self._classify_face_shape(measurements)
            
            return {
                "face_shape": face_shape,
                "confidence": confidence,
                "landmarks": key_points,
                "measurements": measurements
            }
            
        except Exception as e:
            return {"error": str(e)}
    
    def _extract_key_points(self, landmarks, width: int, height: int) -> Dict:
        """Extract key facial landmark points"""
        points = {}
        
        # Key landmark indices for face shape analysis
        key_landmarks = {
            'forehead_top': 10,
            'forehead_left': 21,
            'forehead_right': 251,
            'temple_left': 127,
            'temple_right': 356,
            'cheekbone_left': 116,
            'cheekbone_right': 345,
            'jawline_left': 172,
            'jawline_right': 397,
            'chin': 175,
            'nose_top': 8,
            'nose_bottom': 2
        }
        
        for name, idx in key_landmarks.items():
            landmark = landmarks.landmark[idx]
            points[name] = {
                'x': int(landmark.x * width),
                'y': int(landmark.y * height)
            }
        
        return points
    
    def _calculate_face_measurements(self, points: Dict) -> Dict:
        """Calculate facial measurements for shape classification"""
        measurements = {}
        
        # Face width at different levels
        measurements['forehead_width'] = self._distance(points['forehead_left'], points['forehead_right'])
        measurements['cheekbone_width'] = self._distance(points['cheekbone_left'], points['cheekbone_right'])
        measurements['jawline_width'] = self._distance(points['jawline_left'], points['jawline_right'])
        
        # Face length
        measurements['face_length'] = self._distance(points['forehead_top'], points['chin'])
        
        # Ratios for classification
        measurements['width_to_length_ratio'] = measurements['cheekbone_width'] / measurements['face_length']
        measurements['forehead_to_cheekbone_ratio'] = measurements['forehead_width'] / measurements['cheekbone_width']
        measurements['jawline_to_cheekbone_ratio'] = measurements['jawline_width'] / measurements['cheekbone_width']
        
        return measurements
    
    def _distance(self, p1: Dict, p2: Dict) -> float:
        """Calculate Euclidean distance between two points"""
        return math.sqrt((p1['x'] - p2['x'])**2 + (p1['y'] - p2['y'])**2)
    
    def _classify_face_shape(self, measurements: Dict) -> Tuple[str, float]:
        """Classify face shape based on measurements"""
        ratios = {
            'width_to_length': measurements['width_to_length_ratio'],
            'forehead_to_cheekbone': measurements['forehead_to_cheekbone_ratio'],
            'jawline_to_cheekbone': measurements['jawline_to_cheekbone_ratio']
        }
        
        # Face shape classification rules
        if ratios['width_to_length'] > 0.9:
            if ratios['forehead_to_cheekbone'] > 0.95 and ratios['jawline_to_cheekbone'] > 0.95:
                return "round", 0.85
            elif ratios['forehead_to_cheekbone'] > 0.9 and ratios['jawline_to_cheekbone'] > 0.9:
                return "square", 0.80
        
        if ratios['width_to_length'] < 0.7:
            return "oblong", 0.75
        
        if ratios['forehead_to_cheekbone'] < 0.8:
            return "heart", 0.80
        
        if ratios['jawline_to_cheekbone'] < 0.8:
            return "diamond", 0.75
        
        # Default to oval if no specific shape detected
        return "oval", 0.70