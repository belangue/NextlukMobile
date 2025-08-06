// File: lib/features/analysis/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/analysis_provider.dart';
import '../widgets/camera_preview_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  } // FIXED: Added missing closing brace

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '✨ Hair Magic ✨',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6B73FF), // Using direct color instead of AppTheme
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline, color: Color(0xFF6B73FF)),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFF8F9FF),
              Color(0xFFE8EAFF),
            ],
          ),
        ),
        child: Consumer<AnalysisProvider>(
          builder: (context, provider, child) {
            return _buildBody(provider);
          },
        ),
      ),
    );
  }

  Widget _buildBody(AnalysisProvider provider) {
    switch (provider.state) {
      case AnalysisState.initial:
      case AnalysisState.loading:
        return _buildWelcomeScreen(provider);
      case AnalysisState.imageSelected:
        return _buildImagePreview(provider);
      case AnalysisState.analyzing:
        return _buildAnalyzingScreen(provider);
      case AnalysisState.completed:
        return _buildResultsScreen(provider);
      case AnalysisState.error:
        return _buildErrorScreen(provider);
    }
  }

  Widget _buildWelcomeScreen(AnalysisProvider provider) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeInAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),

                    // Welcome Header
                    _buildWelcomeHeader(),

                    const SizedBox(height: 40),

                    // Feature Cards
                    Expanded(
                      child: _buildFeatureCards(),
                    ),

                    // Action Buttons
                    _buildActionButtons(provider),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Color(0xFFF8F9FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.face_retouching_natural,
            size: 60,
            color: Color(0xFF6B73FF),
          ),
          const SizedBox(height: 16),
          Text(
            'Discover Your Perfect Look',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(0xFF6B73FF),
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'AI-powered hair analysis for African women. Get personalized recommendations for your unique beauty.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                  height: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCards() {
    final features = [
      {
        'icon': Icons.face_6,
        'title': 'Face Shape Analysis',
        'description': 'Discover your unique face shape',
        'color': Colors.pink[300]!,
      },
      {
        'icon': Icons.psychology,
        'title': 'Hair Type Detection',
        'description': 'Identify your hair texture & porosity',
        'color': Colors.purple[300]!,
      },
      {
        'icon': Icons.health_and_safety,
        'title': 'Hair Health Check',
        'description': 'Get health insights & treatment tips',
        'color': Colors.orange[300]!,
      },
      {
        'icon': Icons.style,
        'title': 'Style Recommendations',
        'description': 'Perfect hairstyles for your features',
        'color': Colors.teal[300]!,
      },
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: features.length,
      itemBuilder: (context, index) {
        final feature = features[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: (feature['color'] as Color).withOpacity(0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (feature['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  feature['icon'] as IconData,
                  size: 30,
                  color: feature['color'] as Color,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                feature['title'] as String,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3142),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                feature['description'] as String,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(AnalysisProvider provider) {
    return Column(
      children: [
        if (provider.isLoading)
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const CircularProgressIndicator(
                  color: Color(0xFF6B73FF),
                  strokeWidth: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Preparing camera...',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: _buildCustomButton(
                  text: '📷 Take Photo',
                  onPressed: () => provider.takePicture(),
                  icon: Icons.camera_alt,
                  gradient: true,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCustomButton(
                  text: '🖼️ Gallery',
                  onPressed: () => provider.pickFromGallery(),
                  outlined: true,
                  icon: Icons.photo_library,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildCustomButton({
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    bool gradient = false,
    bool outlined = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: gradient
            ? const Color(0xFF6B73FF)
            : (outlined ? Colors.transparent : Colors.white),
        foregroundColor: gradient ? Colors.white : const Color(0xFF6B73FF),
        side: outlined ? const BorderSide(color: Color(0xFF6B73FF)) : null,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: outlined ? 0 : 2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(AnalysisProvider provider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Header
            _buildScreenHeader(
              'Perfect! 📸',
              'Your photo looks great. Ready to analyze?',
            ),

            const SizedBox(height: 20),

            // Camera Preview Widget
            const Expanded(
              child: CameraPreviewWidget(),
            ),

            const SizedBox(height: 20),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: _buildCustomButton(
                    text: 'Retake',
                    onPressed: () => provider.clearImage(),
                    outlined: true,
                    icon: Icons.refresh,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: _buildCustomButton(
                    text: '✨ Analyze Hair',
                    onPressed: () => provider.analyzeHair(),
                    gradient: true,
                    icon: Icons.auto_awesome,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzingScreen(AnalysisProvider provider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated AI Icon
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 2),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: 0.8 + (0.2 * value),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6B73FF).withOpacity(0.2),
                          const Color(0xFF9B59B6).withOpacity(0.2),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.psychology,
                      size: 80,
                      color: Color(0xFF6B73FF),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 40),

            Text(
              'AI is analyzing your hair... ✨',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFF6B73FF),
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 20),

            const LinearProgressIndicator(
              color: Color(0xFF6B73FF),
              backgroundColor: Color(0xFFE8EAFF),
            ),

            const SizedBox(height: 20),

            Text(
              'Detecting face shape, analyzing hair type, and finding perfect styles for you...',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsScreen(AnalysisProvider provider) {
    return SafeArea(
      child: Column(
        children: [
          _buildScreenHeader(
            'Analysis Complete! 🎉',
            'Here are your personalized results',
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Analysis results will be displayed here',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: _buildCustomButton(
                    text: 'New Analysis',
                    onPressed: () => provider.clearImage(),
                    outlined: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCustomButton(
                    text: 'Save Results',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Results saved! 💕'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    gradient: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorScreen(AnalysisProvider provider) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            Text(
              'Oops! Something went wrong 😔',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              provider.errorMessage ?? 'Unknown error occurred',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: _buildCustomButton(
                    text: 'Try Again',
                    onPressed: () => provider.retryAnalysis(),
                    outlined: true,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildCustomButton(
                    text: 'New Photo',
                    onPressed: () => provider.clearImage(),
                    gradient: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScreenHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  color: const Color(0xFF6B73FF),
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
