// import 'dart:io';
// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:image/image.dart' as img;

// class CameraService {
//   static final ImagePicker _picker = ImagePicker();

//   /// Take a picture using camera
//   static Future<File?> takePicture() async {
//     try {
//       final XFile? photo = await _picker.pickImage(
//         source: ImageSource.camera,
//         maxWidth: 1080,
//         maxHeight: 1080,
//         imageQuality: 85,
//         preferredCameraDevice: CameraDevice.front, // Front camera for selfies
//       );

//       if (photo != null) {
//         return File(photo.path);
//       }
//       return null;
//     } catch (e) {
//       debugPrint('Error taking picture: $e');
//       return null;
//     }
//   }

//   /// Pick image from gallery
//   static Future<File?> pickFromGallery() async {
//     try {
//       final XFile? image = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 1080,
//         maxHeight: 1080,
//         imageQuality: 85,
//       );

//       if (image != null) {
//         return File(image.path);
//       }
//       return null;
//     } catch (e) {
//       debugPrint('Error picking from gallery: $e');
//       return null;
//     }
//   }

//   /// Process and optimize image for hair analysis
//   static Future<File?> processImageForAnalysis(File imageFile) async {
//     try {
//       // Read image bytes
//       final Uint8List imageBytes = await imageFile.readAsBytes();

//       // Decode image
//       img.Image? image = img.decodeImage(imageBytes);
//       if (image == null) return null;

//       // Resize image if too large (optimal size for analysis)
//       if (image.width > 1080 || image.height > 1080) {
//         image = img.copyResize(
//           image,
//           width: image.width > image.height ? 1080 : null,
//           height: image.height > image.width ? 1080 : null,
//         );
//       }

//       // Enhance image quality for better face detection
//       image = img.adjustColor(
//         image,
//         brightness: 1.05,
//         contrast: 1.1,
//         saturation: 1.02,
//       );

//       // Save processed image
//       final String processedPath = imageFile.path.replaceAll('.', '_processed.');
//       final File processedFile = File(processedPath);
//       await processedFile.writeAsBytes(img.encodeJpg(image, quality: 90));

//       return processedFile;
//     } catch (e) {
//       debugPrint('Error processing image: $e');
//       return imageFile; // Return original if processing fails
//     }
//   }

//   /// Validate if image is suitable for hair analysis
//   static Future<bool> validateImageForHairAnalysis(File imageFile) async {
//     try {
//       final Uint8List imageBytes = await imageFile.readAsBytes();
//       final img.Image? image = img.decodeImage(imageBytes);

//       if (image == null) return false;

//       // Check minimum resolution
//       if (image.width < 300 || image.height < 300) {
//         return false;
//       }

//       // Check if image is too dark or too bright
//       int totalBrightness = 0;
// int pixelCount = 0;

// for (int y = 0; y < image.height; y += 10) {
//   for (int x = 0; x < image.width; x += 10) {
//     final pixel = image.getPixel(x, y);

//     // Correct way to extract RGB values from pixel
//     final r = pixel.r;
//     final g = pixel.g;
//     final b = pixel.b;

//     // Calculate brightness (luminance)
//     totalBrightness += ((r + g + b) / 3).round();
//     pixelCount++;
//   }
// }
//       final averageBrightness = totalBrightness / pixelCount;

//       // Image should not be too dark (< 30) or too bright (> 220)
//       return averageBrightness >= 30 && averageBrightness <= 220;

//     } catch (e) {
//       debugPrint('Error validating image: $e');
//       return true; // Assume valid if validation fails
//     }
//   }

//   /// Get image metadata
//   static Future<Map<String, dynamic>> getImageMetadata(File imageFile) async {
//     try {
//       final Uint8List imageBytes = await imageFile.readAsBytes();
//       final img.Image? image = img.decodeImage(imageBytes);

//       if (image == null) {
//         return {
//           'error': 'Could not decode image',
//         };
//       }

//       return {
//         'width': image.width,
//         'height': image.height,
//         'format': imageFile.path.split('.').last.toUpperCase(),
//         'fileSize': await imageFile.length(),
//         'aspectRatio': (image.width / image.height).toStringAsFixed(2),
//       };
//     } catch (e) {
//       return {
//         'error': 'Could not read image metadata: $e',
//       };
//     }
//   }
// }

// lib/shared/services/camera_service.dart
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:camera/camera.dart';

class CameraService {
  static CameraController? _controller;
  static List<CameraDescription>? _cameras;

  // This getter works on ALL platforms
  static CameraController? get controller => _controller;
  static List<CameraDescription>? get cameras => _cameras;

  // Platform-aware initialization
  static Future<bool> initialize() async {
    try {
      // Check if we're on a mobile platform
      if (kIsWeb ||
          Platform.isWindows ||
          Platform.isLinux ||
          Platform.isMacOS) {
        // Desktop/Web: Don't initialize real camera
        if (kDebugMode) {
          print(
              'Camera not available on ${Platform.operatingSystem}/Web - using mock');
        }
        return false; // This tells the UI to show alternative content
      }

      // Mobile platforms (Android/iOS): Initialize real camera
      _cameras = await availableCameras();

      if (_cameras == null || _cameras!.isEmpty) {
        if (kDebugMode) {
          print('No cameras available on this device');
        }
        return false;
      }

      _controller = CameraController(
        _cameras!.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _controller!.initialize();

      if (kDebugMode) {
        print('Camera initialized successfully on ${Platform.operatingSystem}');
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing camera: $e');
      }
      return false;
    }
  }

  static Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
  }

  static bool get isInitialized {
    return _controller != null && _controller!.value.isInitialized;
  }

  static bool get isMobilePlatform {
    return !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  }

  static Future<void> switchCamera() async {
    if (!isMobilePlatform || _cameras == null || _cameras!.length < 2) return;

    final currentCamera = _controller?.description;
    CameraDescription newCamera;

    if (currentCamera?.lensDirection == CameraLensDirection.back) {
      newCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );
    } else {
      newCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );
    }

    await _controller?.dispose();

    _controller = CameraController(
      newCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
  }

  static Future<XFile?> takePicture() async {
    if (!isInitialized) return null;

    try {
      return await _controller!.takePicture();
    } catch (e) {
      if (kDebugMode) {
        print('Error taking picture: $e');
      }
      return null;
    }
  }
}
