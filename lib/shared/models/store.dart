export 'store_model.dart';
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
    this.rating = 0.0,
    required this.phone,
    this.isOpen = true,
    required this.category,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.cashbackPercentage = 0.0,
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

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store.fromModel(StoreModel.fromJson(json));
  }
}
