// lib/features/analysis/widgets/camera_preview_widget.dart
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../../../shared/services/camera_service.dart';

class CameraPreviewWidget extends StatefulWidget {
  const CameraPreviewWidget({super.key});

  @override
  State<CameraPreviewWidget> createState() => _CameraPreviewWidgetState();
}

class _CameraPreviewWidgetState extends State<CameraPreviewWidget> {
  bool _isInitializing = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    setState(() {
      _isInitializing = true;
      _errorMessage = '';
    });

    try {
      final success = await CameraService.initialize();

      if (mounted) {
        setState(() {
          _isInitializing = false;
          if (!success && CameraService.isMobilePlatform) {
            _errorMessage = 'Camera not available on this device';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _errorMessage = 'Error initializing camera: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (_isInitializing) {
      return _buildLoadingState();
    }

    // For desktop/web: Show mock camera interface
    if (!CameraService.isMobilePlatform) {
      return _buildMockCameraInterface();
    }

    // For mobile: Show error state if camera failed
    if (_errorMessage.isNotEmpty || !CameraService.isInitialized) {
      return _buildErrorState();
    }

    // For mobile: Show real camera preview
    return _buildRealCameraPreview();
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Initializing Camera...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMockCameraInterface() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black87,
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          // Mock camera view
          AspectRatio(
            aspectRatio: 9.0 / 16.0,
            child: Container(
              color: Colors.black87,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 80,
                      color: Colors.white54,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Desktop Preview Mode',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Camera will work on mobile devices',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Face detection overlay guides (same as mobile)
          Positioned.fill(
            child: CustomPaint(
              painter: FaceGuidelinePainter(),
            ),
          ),

          // Instructions overlay
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: const Text(
                kIsWeb
                    ? 'Web Preview - Test on mobile for camera'
                    : 'Desktop Preview - Deploy to mobile for camera',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.camera_alt_outlined,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage.isNotEmpty ? _errorMessage : 'Camera not available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _initializeCamera,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRealCameraPreview() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: CameraService.controller!.value.aspectRatio,
            child: CameraPreview(CameraService.controller!),
          ),

          // Face detection overlay guides
          Positioned.fill(
            child: CustomPaint(
              painter: FaceGuidelinePainter(),
            ),
          ),

          // Instructions overlay
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: const Text(
                'Position your face within the oval guide',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Camera switch button (only on mobile)
          Positioned(
            top: 20,
            right: 20,
            child: FloatingActionButton(
              mini: true,
              onPressed: () async {
                await CameraService.switchCamera();
                setState(() {});
              },
              child: const Icon(Icons.flip_camera_ios),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for face guidelines (works on all platforms)
class FaceGuidelinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final Rect ovalRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2.2),
      width: size.width * 0.6,
      height: size.height * 0.7,
    );

    canvas.drawOval(ovalRect, paint);

    const double cornerSize = 20;
    final Paint cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Draw corner indicators
    canvas.drawLine(
      Offset(ovalRect.left, ovalRect.top + cornerSize),
      Offset(ovalRect.left, ovalRect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(ovalRect.left, ovalRect.top),
      Offset(ovalRect.left + cornerSize, ovalRect.top),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(ovalRect.right - cornerSize, ovalRect.top),
      Offset(ovalRect.right, ovalRect.top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(ovalRect.right, ovalRect.top),
      Offset(ovalRect.right, ovalRect.top + cornerSize),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(ovalRect.left, ovalRect.bottom - cornerSize),
      Offset(ovalRect.left, ovalRect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(ovalRect.left, ovalRect.bottom),
      Offset(ovalRect.left + cornerSize, ovalRect.bottom),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(ovalRect.right - cornerSize, ovalRect.bottom),
      Offset(ovalRect.right, ovalRect.bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(ovalRect.right, ovalRect.bottom),
      Offset(ovalRect.right, ovalRect.bottom - cornerSize),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
