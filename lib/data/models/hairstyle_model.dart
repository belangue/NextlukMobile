class HairstyleModel {
  final String id;
  final String title;
  final String? description;
  final String? category;
  final double? price;
  final String imageUrl;
  final String createdBy;
  final List<String> tags;
  final double rating;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  HairstyleModel({
    required this.id,
    required this.title,
    this.description,
    this.category,
    this.price,
    required this.imageUrl,
    required this.createdBy,
    required this.tags,
    required this.rating,
    this.createdAt,
    this.updatedAt,
  });

  factory HairstyleModel.fromJson(Map<String, dynamic> json) {
    return HairstyleModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString(),
      category: json['category']?.toString(),
      price: json['price'] != null ? 
             (json['price'] is String ? double.tryParse(json['price']) : json['price']?.toDouble()) 
             : null,
      imageUrl: json['image_url']?.toString() ?? 
                json['imageUrl']?.toString() ?? 
                json['imageurl']?.toString() ?? '',
      createdBy: json['created_by']?.toString() ?? 
                 json['createdBy']?.toString() ?? 
                 json['createdById']?.toString() ?? 
                 json['created_by_id']?.toString() ?? '',
      tags: (json['tags'] as List<dynamic>?)
          ?.map((tag) => tag.toString())
          .toList() ?? [],
      rating: json['rating'] != null ? 
              (json['rating'] is String ? double.tryParse(json['rating']) ?? 0.0 : json['rating']?.toDouble() ?? 0.0)
              : 0.0,
      createdAt: json['created_at'] != null || json['createdAt'] != null
          ? DateTime.tryParse(json['created_at']?.toString() ?? json['createdAt']?.toString() ?? '')
          : null,
      updatedAt: json['updated_at'] != null || json['updatedAt'] != null
          ? DateTime.tryParse(json['updated_at']?.toString() ?? json['updatedAt']?.toString() ?? '')
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'image_url': imageUrl,
      'created_by': createdBy,
      'tags': tags,
      'rating': rating,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  HairstyleModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    double? price,
    String? imageUrl,
    String? createdBy,
    List<String>? tags,
    double? rating,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HairstyleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      createdBy: createdBy ?? this.createdBy,
      tags: tags ?? this.tags,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'HairstyleModel(id: $id, title: $title, category: $category, price: $price, imageUrl: $imageUrl, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HairstyleModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
