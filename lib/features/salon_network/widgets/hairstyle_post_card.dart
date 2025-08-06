// File: lib/features/salon_network/widgets/hairstyle_post_card.dart
import 'package:flutter/material.dart';

// AppTheme class to replace the missing import
class AppTheme {
  static const Color primaryColor = Color(0xFF6B73FF);
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6B73FF), Color(0xFF9C27B0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class HairstylePostCard extends StatefulWidget {
  final HairstylePost post;
  final VoidCallback onLike;
  final VoidCallback onSave;
  final VoidCallback onComment;
  final VoidCallback onShare;
  final VoidCallback onTryOn;
  final VoidCallback onContactHairdresser;

  const HairstylePostCard({
    super.key,
    required this.post,
    required this.onLike,
    required this.onSave,
    required this.onComment,
    required this.onShare,
    required this.onTryOn,
    required this.onContactHairdresser,
  });

  @override
  State<HairstylePostCard> createState() => _HairstylePostCardState();
}

class _HairstylePostCardState extends State<HairstylePostCard> {
  final PageController _imageController = PageController();
  int _currentImageIndex = 0;
  bool _isVideoPlaying = false;

  @override
  void dispose() {
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildMediaContent(),
          _buildContent(),
          _buildActionButtons(),
          _buildEngagementStats(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage: NetworkImage(widget.post.hairdresserImage),
            backgroundColor: Colors.grey[200],
            onBackgroundImageError: (exception, stackTrace) {
              // Handle image loading error
            },
            child: widget.post.hairdresserImage.isEmpty
                ? Icon(Icons.person, color: Colors.grey[600])
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.post.hairdresserName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.verified,
                      size: 16,
                      color: AppTheme.primaryColor,
                    ),
                  ],
                ),
                Text(
                  widget.post.salonName,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              widget.post.category,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaContent() {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          if (widget.post.videoUrl != null && widget.post.videoUrl!.isNotEmpty)
            _buildVideoPlaceholder()
          else
            _buildImageCarousel(),
          if (widget.post.images.length > 1) _buildImageIndicator(),
          _buildTryOnButton(),
        ],
      ),
    );
  }

  Widget _buildVideoPlaceholder() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isVideoPlaying = !_isVideoPlaying;
        });
      },
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.black87,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.grey[300],
                child: Icon(
                  Icons.videocam,
                  size: 50,
                  color: Colors.grey[600],
                ),
              ),
            ),
            if (!_isVideoPlaying)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'VIDEO',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return PageView.builder(
      controller: _imageController,
      onPageChanged: (index) => setState(() => _currentImageIndex = index),
      itemCount: widget.post.images.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Image.network(
            widget.post.images[index],
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: const Center(child: CircularProgressIndicator()),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: Icon(
                  Icons.image_not_supported,
                  color: Colors.grey[600],
                  size: 50,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildImageIndicator() {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          widget.post.images.length,
          (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _currentImageIndex == index
                  ? Colors.white
                  : Colors.white.withOpacity(0.4),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTryOnButton() {
    return Positioned(
      top: 16,
      right: 16,
      child: GestureDetector(
        onTap: widget.onTryOn,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.face_retouching_natural,
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: 4),
              Text(
                'Try On',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.post.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.post.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.post.tags
                .map((tag) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '#$tag',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                widget.post.duration ?? 'Duration not specified',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.attach_money,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                '\$${widget.post.price ?? 0}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildActionButton(
            icon: widget.post.isLiked ? Icons.favorite : Icons.favorite_border,
            color: widget.post.isLiked ? Colors.red : Colors.grey[600]!,
            onTap: widget.onLike,
          ),
          const SizedBox(width: 16),
          _buildActionButton(
            icon: Icons.chat_bubble_outline,
            color: Colors.grey[600]!,
            onTap: widget.onComment,
          ),
          const SizedBox(width: 16),
          _buildActionButton(
            icon: Icons.share_outlined,
            color: Colors.grey[600]!,
            onTap: widget.onShare,
          ),
          const Spacer(),
          _buildActionButton(
            icon: widget.post.isSaved ? Icons.bookmark : Icons.bookmark_border,
            color:
                widget.post.isSaved ? AppTheme.primaryColor : Colors.grey[600]!,
            onTap: widget.onSave,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(
          icon,
          color: color,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildEngagementStats() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                '${widget.post.likesCount ?? 0} likes',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '${widget.post.commentsCount ?? 0} comments',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.onContactHairdresser,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.message_outlined,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Contact Hairdresser',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// You'll also need this HairstylePost model file
// File: lib/features/salon_network/models/hairstyle_post_model.dart
class HairstylePost {
  final String id;
  final String title;
  final String description;
  final List<String> images;
  final String? videoUrl;
  final String hairdresserName;
  final String hairdresserImage;
  final String salonName;
  final String category;
  final List<String> tags;
  final String? duration;
  final double? price;
  final bool isLiked;
  final bool isSaved;
  final int? likesCount;
  final int? commentsCount;

  HairstylePost({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    this.videoUrl,
    required this.hairdresserName,
    required this.hairdresserImage,
    required this.salonName,
    required this.category,
    required this.tags,
    this.duration,
    this.price,
    this.isLiked = false,
    this.isSaved = false,
    this.likesCount,
    this.commentsCount,
  });

  HairstylePost copyWith({
    String? id,
    String? title,
    String? description,
    List<String>? images,
    String? videoUrl,
    String? hairdresserName,
    String? hairdresserImage,
    String? salonName,
    String? category,
    List<String>? tags,
    String? duration,
    double? price,
    bool? isLiked,
    bool? isSaved,
    int? likesCount,
    int? commentsCount,
  }) {
    return HairstylePost(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      videoUrl: videoUrl ?? this.videoUrl,
      hairdresserName: hairdresserName ?? this.hairdresserName,
      hairdresserImage: hairdresserImage ?? this.hairdresserImage,
      salonName: salonName ?? this.salonName,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      duration: duration ?? this.duration,
      price: price ?? this.price,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
    );
  }
}
