export 'product_model.dart';
import 'product_model.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double originalPrice;
  final String imageUrl;
  final String category;
  final String store;
  final int discount;
  final String unit;
  final double rating;
  final int reviewCount;
  final bool isBestSeller;
  final bool isNew;
  final bool inStock;

  int get discountPercentage => discount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.category,
    required this.store,
    required this.discount,
    required this.unit,
    this.rating = 4.0,
    this.reviewCount = 0,
    this.isBestSeller = false,
    this.isNew = false,
    this.inStock = true,
  });

  ProductModel toProductModel() {
    return ProductModel(
      id: id,
      name: name,
      description: description,
      category: category,
      mrp: originalPrice,
      price: price,
      unit: unit,
      imageUrl: imageUrl,
      rating: rating,
      reviewCount: reviewCount,
      storeName: store,
    );
  }

  factory Product.fromModel(ProductModel model) {
    return Product(
      id: model.id,
      name: model.name,
      description: model.description,
      price: model.price,
      originalPrice: model.mrp,
      imageUrl: model.imageUrl,
      category: model.category,
      store: model.storeName,
      discount: model.discountPercent.toInt(),
      unit: model.unit,
      rating: model.rating,
      reviewCount: model.reviewCount,
      isBestSeller: model.rating >= 4.5,
      isNew: model.reviewCount < 100,
      inStock: model.inStock,
    );
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product.fromModel(ProductModel.fromJson(json));
  }
}
