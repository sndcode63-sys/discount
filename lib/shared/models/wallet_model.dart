class WalletModel {
  final double balance;
  final double totalEarned;
  final double pendingCashback;
  final String loyaltyTier;
  final String currency;

  WalletModel({
    this.balance = 0.0,
    this.totalEarned = 0.0,
    this.pendingCashback = 0.0,
    this.loyaltyTier = '',
    this.currency = 'INR',
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      totalEarned: (json['totalEarned'] as num?)?.toDouble() ??
          (json['totalCashbackEarned'] as num?)?.toDouble() ??
          0.0,
      pendingCashback: (json['pendingCashback'] as num?)?.toDouble() ??
          (json['pendingBalance'] as num?)?.toDouble() ??
          0.0,
      loyaltyTier: json['loyaltyTier']?.toString() ?? '',
      currency: json['currency']?.toString() ?? 'INR',
    );
  }
}

class WalletTransactionModel {
  final String id;
  final String type;
  final double amount;
  final double balanceAfter;
  final String description;
  final DateTime createdAt;

  WalletTransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.balanceAfter,
    required this.description,
    required this.createdAt,
  });

  bool get isCredit => amount > 0 || type.contains('credit') || type.contains('bonus');

  factory WalletTransactionModel.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.now();
    if (json['createdAt'] != null) {
      date = DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();
    }
    return WalletTransactionModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      balanceAfter: (json['balanceAfter'] as num?)?.toDouble() ?? 0.0,
      description: json['description']?.toString() ?? '',
      createdAt: date,
    );
  }
}
