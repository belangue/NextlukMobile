class Hairdresser {
  final String id;
  final String name;
  final String bio;
  final String profileImageUrl;
  final List<String> specialties;
  final double rating;
  final int reviewCount;
  final String salonId;
  final String salonName;
  final int yearsExperience;
  final bool isAvailable;
  final List<String> certifications;
  final double priceRange;

  Hairdresser({
    required this.id,
    required this.name,
    required this.bio,
    required this.profileImageUrl,
    required this.specialties,
    required this.rating,
    required this.reviewCount,
    required this.salonId,
    required this.salonName,
    required this.yearsExperience,
    required this.isAvailable,
    required this.certifications,
    required this.priceRange,
  });

  factory Hairdresser.fromJson(Map<String, dynamic> json) {
    return Hairdresser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bio: json['bio'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      specialties: List<String>.from(json['specialties'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      salonId: json['salonId'] ?? '',
      salonName: json['salonName'] ?? '',
      yearsExperience: json['yearsExperience'] ?? 0,
      isAvailable: json['isAvailable'] ?? false,
      certifications: List<String>.from(json['certifications'] ?? []),
      priceRange: (json['priceRange'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bio': bio,
      'profileImageUrl': profileImageUrl,
      'specialties': specialties,
      'rating': rating,
      'reviewCount': reviewCount,
      'salonId': salonId,
      'salonName': salonName,
      'yearsExperience': yearsExperience,
      'isAvailable': isAvailable,
      'certifications': certifications,
      'priceRange': priceRange,
    };
  }

  // Add copyWith method for easier updates
  Hairdresser copyWith({
    String? id,
    String? name,
    String? bio,
    String? profileImageUrl,
    List<String>? specialties,
    double? rating,
    int? reviewCount,
    String? salonId,
    String? salonName,
    int? yearsExperience,
    bool? isAvailable,
    List<String>? certifications,
    double? priceRange,
  }) {
    return Hairdresser(
      id: id ?? this.id,
      name: name ?? this.name,
      bio: bio ?? this.bio,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      specialties: specialties ?? this.specialties,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      salonId: salonId ?? this.salonId,
      salonName: salonName ?? this.salonName,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      isAvailable: isAvailable ?? this.isAvailable,
      certifications: certifications ?? this.certifications,
      priceRange: priceRange ?? this.priceRange,
    );
  }
}
