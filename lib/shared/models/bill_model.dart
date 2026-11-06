class BillModel {
  final String billNumber;
  final String storeName;
  final double totalAmount;
  final double customerCashback;
  final double merchantNetReceived;
  final String paymentStatus;
  final String paymentMethod;
  final String digitalReceiptUrl;
  final DateTime createdAt;

  BillModel({
    required this.billNumber,
    required this.storeName,
    required this.totalAmount,
    required this.customerCashback,
    this.merchantNetReceived = 0.0,
    this.paymentStatus = 'paid',
    this.paymentMethod = 'upi',
    this.digitalReceiptUrl = '',
    required this.createdAt,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.now();
    if (json['createdAt'] != null) {
      date = DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now();
    }

    String sName = 'Apna Kirana & Supermarket';
    if (json['store'] is Map && json['store']['name'] != null) {
      sName = json['store']['name'];
    } else if (json['storeName'] != null) {
      sName = json['storeName'];
    }

    return BillModel(
      billNumber: json['billNumber'] ?? 'BILL-${DateTime.now().millisecondsSinceEpoch}',
      storeName: sName,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      customerCashback: (json['customerCashback'] as num?)?.toDouble() ?? 0.0,
      merchantNetReceived: (json['merchantNetReceived'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['paymentStatus'] ?? 'paid',
      paymentMethod: json['paymentMethod'] ?? 'upi',
      digitalReceiptUrl: json['digitalReceiptUrl'] ?? '',
      createdAt: date,
    );
  }
}
