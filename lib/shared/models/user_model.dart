class UserModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String role; // 'customer', 'merchant', 'admin'
  final String loyaltyTier;
  final double walletBalance;
  final String referralCode;
  final String? token;
  final bool isPhoneVerified;
  final bool isEmailVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.role = 'customer',
    this.loyaltyTier = '',
    this.walletBalance = 0.0,
    this.referralCode = '',
    this.token,
    this.isPhoneVerified = false,
    this.isEmailVerified = false,
  });

  bool get isMerchant => role == 'merchant';
  bool get isAdmin => role == 'admin';
  bool get isCustomer => role == 'customer';

  factory UserModel.fromJson(Map<String, dynamic> json, {String? token}) {
    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'customer',
      loyaltyTier: json['loyaltyTier']?.toString() ?? '',
      walletBalance: (json['walletBalance'] as num?)?.toDouble() ?? 0.0,
      referralCode: json['referralCode']?.toString() ?? '',
      token: token ?? json['token']?.toString(),
      isPhoneVerified: json['isPhoneVerified'] == true,
      isEmailVerified: json['isEmailVerified'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
      'loyaltyTier': loyaltyTier,
      'walletBalance': walletBalance,
      'referralCode': referralCode,
      'token': token,
      'isPhoneVerified': isPhoneVerified,
      'isEmailVerified': isEmailVerified,
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? role,
    String? loyaltyTier,
    double? walletBalance,
    String? token,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      role: role ?? this.role,
      loyaltyTier: loyaltyTier ?? this.loyaltyTier,
      walletBalance: walletBalance ?? this.walletBalance,
      referralCode: referralCode,
      token: token ?? this.token,
      isPhoneVerified: isPhoneVerified,
      isEmailVerified: isEmailVerified,
    );
  }
}
