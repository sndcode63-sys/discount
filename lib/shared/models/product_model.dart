class ProductModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String brand;
  final String barcode;
  final double mrp;
  final double price;
  final double effectivePrice;
  final double cashbackPercentage;
  final String unit;
  final String imageUrl;
  final double rating;
  final int reviewCount;
  final bool inStock;
  final String storeName;

  ProductModel({
    required this.id,
    required this.name,
    this.description = '',
    this.category = '',
    this.brand = '',
    this.barcode = '',
    required this.mrp,
    required this.price,
    double? effectivePrice,
    this.cashbackPercentage = 0.0,
    this.unit = '',
    this.imageUrl = '',
    this.rating = 0.0,
    this.reviewCount = 0,
    this.inStock = true,
    this.storeName = '',
  }) : effectivePrice = effectivePrice ?? (price - (price * (cashbackPercentage / 100)));

  double get discountPercent =>
      (mrp > price && mrp > 0) ? (((mrp - price) / mrp) * 100).roundToDouble() : 0.0;

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final mrpVal = (json['mrp'] as num?)?.toDouble() ?? (json['price'] as num?)?.toDouble() ?? 0.0;
    final priceVal = (json['price'] as num?)?.toDouble() ??
        (json['sellingPrice'] as num?)?.toDouble() ??
        mrpVal;
    final cashbackVal = (json['cashbackPercentage'] as num?)?.toDouble() ?? 0.0;

    String sName = '';
    if (json['store'] is Map && json['store']['name'] != null) {
      sName = json['store']['name'].toString();
    } else if (json['storeName'] != null) {
      sName = json['storeName'].toString();
    }

    return ProductModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      brand: json['brand']?.toString() ?? '',
      barcode: json['barcode']?.toString() ?? '',
      mrp: mrpVal,
      price: priceVal,
      cashbackPercentage: cashbackVal,
      unit: json['unit']?.toString() ?? '1 unit',
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      inStock: json['stockStatus'] != 'OUT_OF_STOCK' && json['isActive'] != false,
      storeName: sName,
    );
  }
}
