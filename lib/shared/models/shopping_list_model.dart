class ShoppingListItem {
  final String productId;
  final String name;
  final double estimatedPrice;
  int quantity;
  bool isChecked;

  ShoppingListItem({
    required this.productId,
    required this.name,
    required this.estimatedPrice,
    this.quantity = 1,
    this.isChecked = true,
  });

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'quantity': quantity,
      };
}

class ShoppingBasketComparison {
  final List<StoreBasketRank> topStores;
  final String bestOverallValue;
  final String savingsReport;

  ShoppingBasketComparison({
    required this.topStores,
    required this.bestOverallValue,
    required this.savingsReport,
  });

  factory ShoppingBasketComparison.fromJson(Map<String, dynamic> json) {
    List<StoreBasketRank> stores = [];
    if (json['topStores'] is List) {
      stores = (json['topStores'] as List)
          .map((item) => StoreBasketRank.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    String best = '';
    String savings = '';
    if (json['highlights'] is Map) {
      best = json['highlights']['bestOverallValue']?.toString() ?? '';
      savings = json['highlights']['savingsReport']?.toString() ?? '';
    }

    return ShoppingBasketComparison(
      topStores: stores,
      bestOverallValue: best,
      savingsReport: savings,
    );
  }
}

class StoreBasketRank {
  final int rank;
  final String storeId;
  final String storeName;
  final String itemsAvailableRatio;
  final double totalAmount;
  final double cashback;
  final double finalEffectiveCost;
  final String badge;

  StoreBasketRank({
    required this.rank,
    required this.storeId,
    required this.storeName,
    required this.itemsAvailableRatio,
    required this.totalAmount,
    required this.cashback,
    required this.finalEffectiveCost,
    required this.badge,
  });

  factory StoreBasketRank.fromJson(Map<String, dynamic> json) {
    return StoreBasketRank(
      rank: (json['rank'] as num?)?.toInt() ?? 1,
      storeId: json['storeId']?.toString() ?? '',
      storeName: json['storeName']?.toString() ?? '',
      itemsAvailableRatio: json['itemsAvailableRatio']?.toString() ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      cashback: (json['cashback'] as num?)?.toDouble() ?? 0.0,
      finalEffectiveCost: (json['finalEffectiveCost'] as num?)?.toDouble() ?? 0.0,
      badge: json['badge']?.toString() ?? '',
    );
  }
}
