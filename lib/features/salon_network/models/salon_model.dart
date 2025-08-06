// class Salon {
//   final String id;
//   final String name;
//   final String address;
//   final double latitude;
//   final double longitude;
//   final String phoneNumber;
//   final List<String> images;
//   final double rating;
//   final int reviewCount;
//   final List<String> services;
//   final Map<String, String> workingHours;
//   final List<Hairdresser> hairdressers;
//   final bool isVerified;
//   final String description;
//   final List<String> amenities;
//   final Map<String, dynamic> pricing;

//   Salon({
//     required this.id,
//     required this.name,
//     required this.address,
//     required this.latitude,
//     required this.longitude,
//     required this.phoneNumber,
//     required this.images,
//     required this.rating,
//     required this.reviewCount,
//     required this.services,
//     required this.workingHours,
//     required this.hairdressers,
//     required this.isVerified,
//     required this.description,
//     required this.amenities,
//     required this.pricing,
//   });

//   factory Salon.fromJson(Map<String, dynamic> json) {
//     return Salon(
//       id: json['id'],
//       name: json['name'],
//       address: json['address'],
//       latitude: json['latitude'].toDouble(),
//       longitude: json['longitude'].toDouble(),
//       phoneNumber: json['phoneNumber'],
//       images: List<String>.from(json['images']),
//       rating: json['rating'].toDouble(),
//       reviewCount: json['reviewCount'],
//       services: List<String>.from(json['services']),
//       workingHours: Map<String, String>.from(json['workingHours']),
//       hairdressers: (json['hairdressers'] as List).map((h) => Hairdresser.fromJson(h)).toList(),
//       isVerified: json['isVerified'],
//       description: json['description'],
//       amenities: List<String>.from(json['amenities']),
//       pricing: json['pricing'],
//     );
//   }
class Salon {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> services;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String phoneNumber;
  final double distance;
  final bool isOpen;
  final Map<String, String> openingHours;

  Salon({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.services,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.phoneNumber,
    required this.distance,
    required this.isOpen,
    required this.openingHours,
  });

  factory Salon.fromJson(Map<String, dynamic> json) {
    return Salon(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      services: List<String>.from(json['services'] ?? []),
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      distance: (json['distance'] ?? 0.0).toDouble(),
      isOpen: json['isOpen'] ?? false,
      openingHours: Map<String, String>.from(json['openingHours'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'services': services,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'phoneNumber': phoneNumber,
      'distance': distance,
      'isOpen': isOpen,
      'openingHours': openingHours,
    };
  }
}

//   double distanceFrom(double userLat, double userLng) {
//     // Haversine formula implementation
//     const double earthRadius = 6371; // km
//     double dLat = _toRadians(latitude - userLat);
//     double dLng = _toRadians(longitude - userLng);
//     double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
//         math.cos(_toRadians(userLat)) * math.cos(_toRadians(latitude)) *
//         math.sin(dLng / 2) * math.sin(dLng / 2);
//     double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//     return earthRadius * c;
//   }

//   double _toRadians(double degree) => degree * (math.pi / 180);
// }
