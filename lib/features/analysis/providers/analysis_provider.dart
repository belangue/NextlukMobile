// lib/features/analysis/providers/analysis_provider.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import '../../../shared/services/camera_service.dart';

enum AnalysisState {
  initial,
  loading,
  imageSelected,
  analyzing,
  completed,
  error,
}

class AnalysisProvider extends ChangeNotifier {
  AnalysisState _state = AnalysisState.initial;
  File? _selectedImage;
  String? _errorMessage;
  Map<String, dynamic>? _analysisResults;
  Map<String, dynamic>? _imageMetadata;
  bool _isLoading = false;

  // Getters
  AnalysisState get state => _state;
  File? get selectedImage => _selectedImage;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get analysisResults => _analysisResults;
  Map<String, dynamic>? get imageMetadata => _imageMetadata;
  bool get isLoading => _isLoading;

  final ImagePicker _picker = ImagePicker();

  // Take picture using camera
  Future<void> takePicture() async {
    try {
      _setLoading(true);

      // Initialize camera service if not already done
      if (!CameraService.isInitialized) {
        final success = await CameraService.initialize();
        if (!success) {
          throw Exception('Camera not available on this platform');
        }
      }

      // Take picture using camera service
      final XFile? imageFile = await CameraService.takePicture();

      if (imageFile != null) {
        _selectedImage = File(imageFile.path);
        _imageMetadata = await _getImageMetadata(_selectedImage!);
        _state = AnalysisState.imageSelected;
        _errorMessage = null;
      } else {
        throw Exception('Failed to capture image');
      }
    } catch (e) {
      _setError('Failed to take picture: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Pick image from gallery
  Future<void> pickFromGallery() async {
    try {
      _setLoading(true);

      final XFile? imageFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (imageFile != null) {
        _selectedImage = File(imageFile.path);
        _imageMetadata = await _getImageMetadata(_selectedImage!);
        _state = AnalysisState.imageSelected;
        _errorMessage = null;
      }
    } catch (e) {
      _setError('Failed to pick image: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Analyze the selected image
  Future<void> analyzeHair() async {
    if (_selectedImage == null) {
      _setError('No image selected');
      return;
    }

    try {
      _state = AnalysisState.analyzing;
      notifyListeners();

      // Simulate analysis process
      await Future.delayed(const Duration(seconds: 3));

      // Mock analysis results
      _analysisResults = {
        'faceShape': 'Oval',
        'hairType': '4C',
        'hairHealth': 'Good',
        'recommendedStyles': [
          'Protective braids',
          'Twist outs',
          'Bantu knots',
        ],
        'confidenceScore': 0.92,
      };

      _state = AnalysisState.completed;
      _errorMessage = null;
    } catch (e) {
      _setError('Analysis failed: $e');
    }

    notifyListeners();
  }

  // Clear selected image and reset state
  void clearImage() {
    _selectedImage = null;
    _analysisResults = null;
    _imageMetadata = null;
    _errorMessage = null;
    _state = AnalysisState.initial;
    notifyListeners();
  }

  // Retry analysis
  Future<void> retryAnalysis() async {
    if (_selectedImage != null) {
      await analyzeHair();
    } else {
      clearImage();
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) {
      _state = AnalysisState.loading;
    }
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _state = AnalysisState.error;
    _isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> _getImageMetadata(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final stats = await imageFile.stat();

      return {
        'fileSize': stats.size,
        'format': imageFile.path.split('.').last.toUpperCase(),
        'width':
            1080, // Mock values - you can use image package to get real dimensions
        'height': 1920,
      };
    } catch (e) {
      return {
        'fileSize': 0,
        'format': 'Unknown',
        'width': 0,
        'height': 0,
      };
    }
  }

  @override
  void dispose() {
    // Clean up resources
    super.dispose();
  }
}
