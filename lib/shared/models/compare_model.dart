class CompareResultModel {
  final String productName;
  final double mrp;
  final int offlineStoresCount;
  final OfflineDealModel? bestOfflineDeal;
  final List<OnlineDealModel> onlineDeals;
  final AiRecommendationModel? aiRecommendation;

  CompareResultModel({
    required this.productName,
    required this.mrp,
    this.offlineStoresCount = 0,
    this.bestOfflineDeal,
    this.onlineDeals = const [],
    this.aiRecommendation,
  });

  factory CompareResultModel.fromJson(Map<String, dynamic> json) {
    String pName = '';
    double mrpVal = 0.0;

    if (json['product'] is Map) {
      pName = json['product']['name']?.toString() ?? '';
      mrpVal = (json['product']['mrp'] as num?)?.toDouble() ?? 0.0;
    } else if (json['productName'] != null) {
      pName = json['productName'].toString();
    }

    OfflineDealModel? offline;
    if (json['bestOfflineDeal'] is Map) {
      offline = OfflineDealModel.fromJson(json['bestOfflineDeal'] as Map<String, dynamic>);
    }

    List<OnlineDealModel> online = [];
    if (json['onlineDeals'] is List) {
      online = (json['onlineDeals'] as List)
          .map((item) => OnlineDealModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    AiRecommendationModel? ai;
    if (json['aiRecommendation'] is Map) {
      ai = AiRecommendationModel.fromJson(json['aiRecommendation'] as Map<String, dynamic>);
    }

    return CompareResultModel(
      productName: pName,
      mrp: mrpVal,
      offlineStoresCount: (json['offlineStoresCount'] as num?)?.toInt() ?? 0,
      bestOfflineDeal: offline,
      onlineDeals: online,
      aiRecommendation: ai,
    );
  }
}

class OfflineDealModel {
  final String storeId;
  final String storeName;
  final double distanceKm;
  final double sellingPrice;
  final double cashbackPercentage;
  final double cashbackAmount;
  final double effectivePrice;

  OfflineDealModel({
    required this.storeId,
    required this.storeName,
    required this.distanceKm,
    required this.sellingPrice,
    required this.cashbackPercentage,
    required this.cashbackAmount,
    required this.effectivePrice,
  });

  factory OfflineDealModel.fromJson(Map<String, dynamic> json) {
    return OfflineDealModel(
      storeId: json['storeId']?.toString() ?? '',
      storeName: json['storeName']?.toString() ?? '',
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      cashbackPercentage: (json['cashbackPercentage'] as num?)?.toDouble() ?? 0.0,
      cashbackAmount: (json['cashbackAmount'] as num?)?.toDouble() ?? 0.0,
      effectivePrice: (json['effectivePrice'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class OnlineDealModel {
  final String platform;
  final double price;
  final int deliveryDays;
  final double deliveryFee;
  final String affiliateUrl;

  OnlineDealModel({
    required this.platform,
    required this.price,
    this.deliveryDays = 0,
    this.deliveryFee = 0.0,
    this.affiliateUrl = '',
  });

  factory OnlineDealModel.fromJson(Map<String, dynamic> json) {
    return OnlineDealModel(
      platform: json['platform']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      deliveryDays: (json['deliveryDays'] as num?)?.toInt() ?? 0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      affiliateUrl: json['affiliateUrl']?.toString() ?? '',
    );
  }
}

class AiRecommendationModel {
  final String recommendation;
  final String headline;
  final double priceDifference;
  final String reasoning;

  AiRecommendationModel({
    required this.recommendation,
    required this.headline,
    required this.priceDifference,
    required this.reasoning,
  });

  bool get isBuyOffline => recommendation == 'BUY_OFFLINE';

  factory AiRecommendationModel.fromJson(Map<String, dynamic> json) {
    return AiRecommendationModel(
      recommendation: json['recommendation']?.toString() ?? '',
      headline: json['headline']?.toString() ?? '',
      priceDifference: (json['priceDifference'] as num?)?.toDouble() ?? 0.0,
      reasoning: json['reasoning']?.toString() ?? '',
    );
  }
}
