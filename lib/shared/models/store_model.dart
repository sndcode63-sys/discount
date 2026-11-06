class StoreModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String phone;
  final String email;
  final String fullAddress;
  final double distanceKm;
  final double rating;
  final int reviewCount;
  final double defaultCashbackPercentage;
  final String qrCodeData;
  final double latitude;
  final double longitude;
  final bool isOpen;
  final String imageUrl;

  StoreModel({
    required this.id,
    required this.name,
    this.description = '',
    this.category = '',
    this.phone = '',
    this.email = '',
    this.fullAddress = '',
    this.distanceKm = 0.0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.defaultCashbackPercentage = 0.0,
    this.qrCodeData = '',
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.isOpen = true,
    this.imageUrl = '',
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    String addressStr = '';
    if (json['address'] is Map) {
      final addr = json['address'] as Map<String, dynamic>;
      final street = addr['street'] ?? '';
      final city = addr['city'] ?? '';
      final state = addr['state'] ?? '';
      addressStr = [street, city, state].where((s) => s.toString().isNotEmpty).join(', ');
    } else if (json['address'] != null) {
      addressStr = json['address'].toString();
    }

    double lat = 0.0;
    double lng = 0.0;
    if (json['location'] is Map && json['location']['coordinates'] is List) {
      final coords = json['location']['coordinates'] as List;
      if (coords.length >= 2) {
        lng = (coords[0] as num).toDouble();
        lat = (coords[1] as num).toDouble();
      }
    } else if (json['coordinates'] is List) {
      final coords = json['coordinates'] as List;
      if (coords.length >= 2) {
        lng = (coords[0] as num).toDouble();
        lat = (coords[1] as num).toDouble();
      }
    } else if (json['latitude'] != null && json['longitude'] != null) {
      lat = (json['latitude'] as num).toDouble();
      lng = (json['longitude'] as num).toDouble();
    }

    return StoreModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      fullAddress: addressStr,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ??
          (json['distance'] as num?)?.toDouble() ??
          0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      defaultCashbackPercentage:
          (json['defaultCashbackPercentage'] as num?)?.toDouble() ?? 0.0,
      qrCodeData: json['qrCodeData']?.toString() ?? '',
      latitude: lat,
      longitude: lng,
      isOpen: json['isOpen'] == true,
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
    );
  }
}
