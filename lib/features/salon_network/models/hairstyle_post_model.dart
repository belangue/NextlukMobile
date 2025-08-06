class HairstylePost {
  final String id;
  final String hairdresserId;
  final String hairdresserName;
  final String hairdresserImage;
  final String salonName;
  final String title;
  final String description;
  final List<String> images;
  final String? videoUrl;
  final String? videoThumbnail;
  final List<String> tags;
  final String category;
  final String difficulty;
  final String duration;
  final Map<String, dynamic> pricing;
  final List<String> hairTypes;
  final List<String> faceShapes;
  final DateTime createdAt;
  final int likes;
  final int comments;
  final int saves;
  final bool isLiked;
  final bool isSaved;
  final List<Comment> postComments;
  final String status; // 'active', 'archived', 'featured'

  HairstylePost({
    required this.id,
    required this.hairdresserId,
    required this.hairdresserName,
    required this.hairdresserImage,
    required this.salonName,
    required this.title,
    required this.description,
    required this.images,
    this.videoUrl,
    this.videoThumbnail,
    required this.tags,
    required this.category,
    required this.difficulty,
    required this.duration,
    required this.pricing,
    required this.hairTypes,
    required this.faceShapes,
    required this.createdAt,
    required this.likes,
    required this.comments,
    required this.saves,
    required this.isLiked,
    required this.isSaved,
    required this.postComments,
    required this.status,
  });

  factory HairstylePost.fromJson(Map<String, dynamic> json) {
    return HairstylePost(
      id: json['id'] ?? '',
      hairdresserId: json['hairdresserId'] ?? '',
      hairdresserName: json['hairdresserName'] ?? '',
      hairdresserImage: json['hairdresserImage'] ?? '',
      salonName: json['salonName'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      videoUrl: json['videoUrl'],
      videoThumbnail: json['videoThumbnail'],
      tags: List<String>.from(json['tags'] ?? []),
      category: json['category'] ?? '',
      difficulty: json['difficulty'] ?? '',
      duration: json['duration'] ?? '',
      pricing: Map<String, dynamic>.from(json['pricing'] ?? {}),
      hairTypes: List<String>.from(json['hairTypes'] ?? []),
      faceShapes: List<String>.from(json['faceShapes'] ?? []),
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      saves: json['saves'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isSaved: json['isSaved'] ?? false,
      postComments: (json['postComments'] as List<dynamic>? ?? [])
          .map((c) => Comment.fromJson(c))
          .toList(),
      status: json['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hairdresserId': hairdresserId,
      'hairdresserName': hairdresserName,
      'hairdresserImage': hairdresserImage,
      'salonName': salonName,
      'title': title,
      'description': description,
      'images': images,
      'videoUrl': videoUrl,
      'videoThumbnail': videoThumbnail,
      'tags': tags,
      'category': category,
      'difficulty': difficulty,
      'duration': duration,
      'pricing': pricing,
      'hairTypes': hairTypes,
      'faceShapes': faceShapes,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'comments': comments,
      'saves': saves,
      'isLiked': isLiked,
      'isSaved': isSaved,
      'postComments': postComments.map((c) => c.toJson()).toList(),
      'status': status,
    };
  }

  // Add copyWith method for easier updates
  HairstylePost copyWith({
    String? id,
    String? hairdresserId,
    String? hairdresserName,
    String? hairdresserImage,
    String? salonName,
    String? title,
    String? description,
    List<String>? images,
    String? videoUrl,
    String? videoThumbnail,
    List<String>? tags,
    String? category,
    String? difficulty,
    String? duration,
    Map<String, dynamic>? pricing,
    List<String>? hairTypes,
    List<String>? faceShapes,
    DateTime? createdAt,
    int? likes,
    int? comments,
    int? saves,
    bool? isLiked,
    bool? isSaved,
    List<Comment>? postComments,
    String? status,
  }) {
    return HairstylePost(
      id: id ?? this.id,
      hairdresserId: hairdresserId ?? this.hairdresserId,
      hairdresserName: hairdresserName ?? this.hairdresserName,
      hairdresserImage: hairdresserImage ?? this.hairdresserImage,
      salonName: salonName ?? this.salonName,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      videoUrl: videoUrl ?? this.videoUrl,
      videoThumbnail: videoThumbnail ?? this.videoThumbnail,
      tags: tags ?? this.tags,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      duration: duration ?? this.duration,
      pricing: pricing ?? this.pricing,
      hairTypes: hairTypes ?? this.hairTypes,
      faceShapes: faceShapes ?? this.faceShapes,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      saves: saves ?? this.saves,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
      postComments: postComments ?? this.postComments,
      status: status ?? this.status,
    );
  }
}

class Comment {
  final String id;
  final String userId;
  final String userName;
  final String userImage;
  final String content;
  final DateTime createdAt;
  final int likes;
  final bool isLiked;
  final List<Comment> replies;

  Comment({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userImage,
    required this.content,
    required this.createdAt,
    required this.likes,
    required this.isLiked,
    required this.replies,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userImage: json['userImage'] ?? '',
      content: json['content'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      likes: json['likes'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      replies: (json['replies'] as List<dynamic>? ?? [])
          .map((r) => Comment.fromJson(r))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'likes': likes,
      'isLiked': isLiked,
      'replies': replies.map((r) => r.toJson()).toList(),
    };
  }

  Comment copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userImage,
    String? content,
    DateTime? createdAt,
    int? likes,
    bool? isLiked,
    List<Comment>? replies,
  }) {
    return Comment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userImage: userImage ?? this.userImage,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      replies: replies ?? this.replies,
    );
  }
}
