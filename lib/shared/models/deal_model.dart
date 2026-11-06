class DealModel {
  final String id;
  final String platform;
  final String title;
  final String category;
  final double regularPrice;
  final double dealPrice;
  final double discountPercent;
  final double cashbackPercent;
  final String affiliateUrl;
  final String imageUrl;
  final bool isFestivalOffer;
  final String festivalName;

  DealModel({
    required this.id,
    required this.platform,
    required this.title,
    this.category = '',
    required this.regularPrice,
    required this.dealPrice,
    this.discountPercent = 0.0,
    this.cashbackPercent = 0.0,
    required this.affiliateUrl,
    this.imageUrl = '',
    this.isFestivalOffer = false,
    this.festivalName = '',
  });

  factory DealModel.fromJson(Map<String, dynamic> json) {
    final reg = (json['regularPrice'] as num?)?.toDouble() ??
        (json['originalPrice'] as num?)?.toDouble() ??
        0.0;
    final deal = (json['dealPrice'] as num?)?.toDouble() ?? (json['price'] as num?)?.toDouble() ?? reg;
    final disc = (json['discountPercent'] as num?)?.toDouble() ??
        (reg > deal && reg > 0 ? (((reg - deal) / reg) * 100).roundToDouble() : 0.0);

    return DealModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      platform: json['platform']?.toString() ?? '',
      title: json['title']?.toString() ?? json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      regularPrice: reg,
      dealPrice: deal,
      discountPercent: disc,
      cashbackPercent: (json['cashbackPercent'] as num?)?.toDouble() ?? 0.0,
      affiliateUrl: json['affiliateUrl']?.toString() ?? json['url']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      isFestivalOffer: json['isFestivalOffer'] == true,
      festivalName: json['festivalName']?.toString() ?? '',
    );
  }
}
