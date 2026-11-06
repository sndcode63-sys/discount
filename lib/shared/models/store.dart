export 'store_model.dart';

// Backwards-compatible Store class
import 'store_model.dart';

class Store {
  final String id;
  final String name;
  final String address;
  final double distance;
  final String imageUrl;
  final double rating;
  final String phone;
  final bool isOpen;
  final String category;
  final double latitude;
  final double longitude;
  final double cashbackPercentage;

  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.imageUrl,
    this.rating = 4.0,
    required this.phone,
    this.isOpen = true,
    required this.category,
    this.latitude = 28.5800,
    this.longitude = 77.3180,
    this.cashbackPercentage = 5.0,
  });

  StoreModel toStoreModel() {
    return StoreModel(
      id: id,
      name: name,
      phone: phone,
      fullAddress: address,
      distanceKm: distance,
      imageUrl: imageUrl,
      rating: rating,
      isOpen: isOpen,
      category: category,
      latitude: latitude,
      longitude: longitude,
      defaultCashbackPercentage: cashbackPercentage,
    );
  }

  factory Store.fromModel(StoreModel model) {
    return Store(
      id: model.id,
      name: model.name,
      address: model.fullAddress,
      distance: model.distanceKm,
      imageUrl: model.imageUrl,
      rating: model.rating,
      phone: model.phone,
      isOpen: model.isOpen,
      category: model.category,
      latitude: model.latitude,
      longitude: model.longitude,
      cashbackPercentage: model.defaultCashbackPercentage,
    );
  }
}
