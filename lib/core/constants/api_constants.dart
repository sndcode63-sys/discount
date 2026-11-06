class ApiConstants {
  static const String baseUrl = 'https://discount.webvisionsoftech.tech/api/v1';
  // System
  static const String health = '/health';

  // Auth
  static const String sendOtp = '/auth/send-otp';
  static const String verifyOtp = '/auth/verify-otp';
  static const String sendEmailOtp = '/auth/email-otp/send';
  static const String verifyEmailOtp = '/auth/email-otp/verify';
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String getProfile = '/auth/me';

  // Stores
  static const String nearbyStores = '/stores/nearby';
  static const String createStore = '/stores';
  static String storeDetails(String id) => '/stores/$id';
  static String storeReviews(String id) => '/stores/$id/reviews';

  // Products
  static const String products = '/products';
  static String productByBarcode(String barcode) => '/products/barcode/$barcode';
  static const String updateStoreInventory = '/products/store-inventory';

  // Price Comparison & AI Recommendation
  static const String compareProduct = '/compare/product';

  // Smart 3-Store Shopping Lists
  static const String shoppingLists = '/shopping-lists';
  static String compareShoppingList(String id) => '/shopping-lists/$id/compare';
  static const String reserveShoppingList = '/shopping-lists/reserve';

  // Bills & Instant Cashback
  static const String bills = '/bills';
  static String billReceipt(String billNumber) => '/bills/receipt/$billNumber';
  static const String myPurchases = '/bills/my-purchases';

  // Wallet
  static const String wallet = '/wallet';
  static const String withdraw = '/wallet/withdraw';
  static const String transactions = '/wallet/transactions';

  // Affiliate & Festival Deals
  static const String affiliateDeals = '/affiliate/deals';
  static const String festivalOffers = '/affiliate/festival-offers';
  static String trackAffiliateClick(String id) => '/affiliate/track-click/$id';

  // Admin
  static const String adminDashboard = '/admin/dashboard';
  static const String adminWithdrawals = '/admin/withdrawals';
  static String adminKyc(String id) => '/admin/merchants/$id/kyc';

  // Timeout settings
  static const int connectTimeoutSeconds = 8;
  static const int receiveTimeoutSeconds = 8;
}
