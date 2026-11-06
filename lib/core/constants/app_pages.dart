import 'package:get/get.dart';
import 'app_routes.dart';
import '../screens/main_splash_screen.dart';
import '../screens/app_selection_screen.dart';

// Clean Architecture & BLoC Screens (matching Image 1 & Image 2)
import '../../features/home/screens/customer_home_screen.dart';
import '../../features/merchant/screens/merchant_dashboard_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/stores/screens/nearby_stores_screen.dart';
import '../../features/compare/screens/price_comparison_screen.dart';
import '../../features/shopping_list/screens/smart_shopping_list_screen.dart';
import '../../features/wallet/screens/my_wallet_screen.dart';
import '../../features/products/screens/products_catalog_screen.dart';
import '../../features/deals/screens/deals_and_offers_screen.dart';
import '../../features/billing/screens/qr_scanner_receipt_screen.dart';
import '../../features/merchant/screens/sales_report_screen.dart';
import '../../features/merchant/screens/counter_billing_screen.dart';
import '../../features/merchant/screens/inventory_screen.dart';

class AppPages {
  static const String initial = AppRoutes.mainSplash;

  static final routes = [
    // Startup Routes
    GetPage(
      name: AppRoutes.mainSplash,
      page: () => const MainSplashScreen(),
    ),
    GetPage(
      name: AppRoutes.appSelection,
      page: () => const AppSelectionScreen(),
    ),

    // Customer App Routes
    GetPage(
      name: AppRoutes.customerOnboarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: AppRoutes.customerLogin,
      page: () => const ModernLoginScreen(role: 'customer'),
    ),
    GetPage(
      name: AppRoutes.customerHome,
      page: () => const CustomerHomeScreen(),
    ),
    GetPage(
      name: AppRoutes.customerNearbyStores,
      page: () => const NearbyStoresScreen(),
    ),
    GetPage(
      name: AppRoutes.customerPriceComparison,
      page: () => const PriceComparisonScreen(),
    ),
    GetPage(
      name: AppRoutes.customerShoppingList,
      page: () => const SmartShoppingListScreen(),
    ),
    GetPage(
      name: AppRoutes.customerProductListing,
      page: () => const ProductsCatalogScreen(),
    ),
    GetPage(
      name: AppRoutes.customerWallet,
      page: () => const MyWalletScreen(),
    ),
    GetPage(
      name: AppRoutes.customerOffers,
      page: () => const DealsAndOffersScreen(),
    ),
    GetPage(
      name: AppRoutes.customerQRScanner,
      page: () => const QRScannerReceiptScreen(),
    ),

    // Merchant App Routes
    GetPage(
      name: AppRoutes.merchantLogin,
      page: () => const ModernLoginScreen(role: 'merchant'),
    ),
    GetPage(
      name: AppRoutes.merchantRegistration,
      page: () => const ModernRegisterScreen(initialRole: 'merchant'),
    ),
    GetPage(
      name: AppRoutes.merchantDashboard,
      page: () => const MerchantDashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.merchantSalesReport,
      page: () => const SalesReportScreen(),
    ),
    GetPage(
      name: AppRoutes.merchantBilling,
      page: () => const CounterBillingScreen(),
    ),
    GetPage(
      name: AppRoutes.merchantInventory,
      page: () => const InventoryScreen(),
    ),
    GetPage(
      name: AppRoutes.merchantProducts,
      page: () => const InventoryScreen(),
    ),
  ];
}
