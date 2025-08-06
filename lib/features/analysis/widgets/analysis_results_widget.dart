import 'dart:io';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AnalysisResultsWidget extends StatelessWidget {
  final Map<String, dynamic> results;
  final File originalImage;

  const AnalysisResultsWidget({
    super.key,
    required this.results,
    required this.originalImage,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Face Shape Results
          _buildResultCard(
            '👤 Face Shape Analysis',
            _buildFaceShapeContent(),
            Colors.pink[300]!,
          ),

          const SizedBox(height: 20),

          // Hair Type Results
          _buildResultCard(
            '💇‍♀️ Hair Type Analysis',
            _buildHairTypeContent(),
            Colors.purple[300]!,
          ),

          const SizedBox(height: 20),

          // Hair Health Results
          _buildResultCard(
            '🌿 Hair Health Assessment',
            _buildHairHealthContent(),
            Colors.green[300]!,
          ),

          const SizedBox(height: 20),

          // Head Measurements
          _buildResultCard(
            '📏 Head Measurements',
            _buildMeasurementsContent(),
            Colors.orange[300]!,
          ),

          const SizedBox(height: 20),

          // Recommended Hairstyles
          _buildResultCard(
            '✨ Perfect Hairstyles for You',
            _buildHairstylesContent(),
            Colors.teal[300]!,
          ),

          const SizedBox(height: 20),

          // Product Recommendations
          _buildResultCard(
            '🧴 Recommended Products',
            _buildProductsContent(),
            Colors.indigo[300]!,
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(String title, Widget content, Color accentColor) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.auto_awesome,
                    color: accentColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: content,
          ),
        ],
      ),
    );
  }

  Widget _buildFaceShapeContent() {
    final faceShape = results['faceShape'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Face Shape',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    faceShape['shape'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${((faceShape['confidence'] ?? 0.0) * 100).toInt()}% confident',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[700],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Characteristics:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        ...((faceShape['characteristics'] as List<String>? ?? [])
            .map((characteristic) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppTheme.successColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          characteristic,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))),
      ],
    );
  }

  Widget _buildHairTypeContent() {
    final hairType = results['hairType'] as Map<String, dynamic>;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hair Type',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    hairType['type'] ?? 'Unknown',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.texture,
                color: Colors.purple[400],
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          hairType['description'] ?? '',
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildHairAttribute(
                'Porosity',
                hairType['porosity'] ?? 'Unknown',
                Icons.water_drop,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHairAttribute(
                'Density',
                hairType['density'] ?? 'Unknown',
                Icons.grass,
                Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildHairAttribute(
                'Texture',
                hairType['texture'] ?? 'Unknown',
                Icons.waves,
                Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHairAttribute(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHairHealthContent() {
    final hairHealth = results['hairHealth'] as Map<String, dynamic>;
    final score = hairHealth['overallScore'] as int? ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Score
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: _getHealthGradient(score),
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$score',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Health Score',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Health Details
        _buildHealthDetail(
            'Scalp Health', hairHealth['scalpHealth'] ?? 'Unknown'),
        _buildHealthDetail(
            'Moisture Level', hairHealth['moisture'] ?? 'Unknown'),
        _buildHealthDetail(
            'Damage Assessment', hairHealth['damage'] ?? 'Unknown'),
        _buildHealthDetail('Growth Pattern', hairHealth['growth'] ?? 'Unknown'),

        if ((hairHealth['issues'] as List<dynamic>? ?? []).isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Areas for Improvement:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.orange[700],
            ),
          ),
          const SizedBox(height: 8),
          ...((hairHealth['issues'] as List<dynamic>? ?? [])
              .map((issue) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber,
                          size: 16,
                          color: Colors.orange[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          issue.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange[700],
                          ),
                        ),
                      ],
                    ),
                  ))),
        ],
      ],
    );
  }

  Widget _buildHealthDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.cardColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getHealthGradient(int score) {
    if (score >= 80) {
      return [Colors.green[400]!, Colors.green[600]!];
    } else if (score >= 60) {
      return [Colors.orange[400]!, Colors.orange[600]!];
    } else {
      return [Colors.red[400]!, Colors.red[600]!];
    }
  }

  Widget _buildMeasurementsContent() {
    final measurements = results['headMeasurements'] as Map<String, dynamic>;
    final wicks = measurements['wicksNeeded'] as Map<String, dynamic>? ?? {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic Measurements
        Row(
          children: [
            Expanded(
              child: _buildMeasurementItem(
                'Circumference',
                measurements['circumference'] ?? 'N/A',
                Icons.circle_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMeasurementItem(
                'Width',
                measurements['width'] ?? 'N/A',
                Icons.straighten,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _buildMeasurementItem(
                'Length',
                measurements['length'] ?? 'N/A',
                Icons.height,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildMeasurementItem(
                'Forehead Height',
                measurements['foreheadHeight'] ?? 'N/A',
                Icons.face,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Wicks Needed
        Text(
          'Hair Extensions/Wicks Needed:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),

        const SizedBox(height: 12),

        ...wicks.entries.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      entry.key.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    entry.value.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildMeasurementItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildHairstylesContent() {
    final hairstyles = results['suitableHairstyles'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top ${hairstyles.length} recommended styles for you:',
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        ...hairstyles.asMap().entries.map((entry) {
          final index = entry.key;
          final style = entry.value as Map<String, dynamic>;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryColor.withOpacity(0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                // Rank Badge
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getRankColor(index),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Style Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              style['name'] ?? 'Unknown Style',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textPrimary,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${style['suitability'] ?? 0}% match',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        style['description'] ?? '',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildStyleTag('Difficulty',
                              style['difficulty'] ?? 'N/A', Icons.psychology),
                          const SizedBox(width: 8),
                          _buildStyleTag('Maintenance',
                              style['maintenance'] ?? 'N/A', Icons.schedule),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStyleTag(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            '$label: $value',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int index) {
    switch (index) {
      case 0:
        return Colors.amber[600]!; // Gold for #1
      case 1:
        return Colors.grey[400]!; // Silver for #2
      case 2:
        return Colors.orange[400]!; // Bronze for #3
      default:
        return AppTheme.primaryColor;
    }
  }

  Widget _buildProductsContent() {
    final recommendations = results['recommendations'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personalized product recommendations for your hair:',
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        ...recommendations.map((rec) {
          final recommendation = rec as Map<String, dynamic>;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.accentColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color:
                            _getCategoryColor(recommendation['category'] ?? '')
                                .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getCategoryIcon(recommendation['category'] ?? ''),
                        color:
                            _getCategoryColor(recommendation['category'] ?? ''),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recommendation['category'] ?? 'Product',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            recommendation['product'] ?? 'Unknown Product',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  recommendation['reason'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Usage: ${recommendation['usage'] ?? 'As needed'}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'shampoo':
        return Icons.local_car_wash;
      case 'conditioner':
        return Icons.water_drop;
      case 'styling':
        return Icons.brush;
      case 'treatment':
        return Icons.healing;
      default:
        return Icons.shopping_bag;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'shampoo':
        return Colors.blue;
      case 'conditioner':
        return Colors.teal;
      case 'styling':
        return Colors.purple;
      case 'treatment':
        return Colors.green;
      default:
        return AppTheme.primaryColor;
    }
  }
}
