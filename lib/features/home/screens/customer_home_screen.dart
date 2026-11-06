import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/widgets/app_shimmer.dart';
import '../../../shared/models/store_model.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/models/deal_model.dart';
import '../bloc/home_bloc.dart';
import '../../stores/screens/nearby_stores_screen.dart';
import '../../stores/screens/store_details_screen.dart';
import '../../products/screens/products_catalog_screen.dart';
import '../../products/screens/product_details_view.dart';
import '../../compare/screens/price_comparison_screen.dart';
import '../../shopping_list/screens/smart_shopping_list_screen.dart';
import '../../wallet/screens/my_wallet_screen.dart';
import '../../billing/screens/qr_scanner_receipt_screen.dart';
import '../../deals/screens/deals_and_offers_screen.dart';
import 'customer_profile_screen.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(const LoadHomeDataEvent()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: IndexedStack(
          index: _currentTabIndex,
          children: [
            _buildHomeTab(context),
            const NearbyStoresScreen(),
            const SmartShoppingListScreen(),
            const MyWalletScreen(),
            const CustomerProfileScreen(),
          ],
        ),
        bottomNavigationBar: _buildCurvedBottomBar(),
      ),
    );
  }

  // --- FLOATING / CURVED BOTTOM NAVIGATION BAR ---
  Widget _buildCurvedBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home'),
              _buildNavItem(1, Icons.storefront_rounded, 'Stores'),
              // Floating Center QR Scanner Button
              GestureDetector(
                onTap: () {
                  Get.to(() => const QRScannerReceiptScreen());
                },
                child: Container(
                  width: 52,
                  height: 52,
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    gradient: AppColors.heroRedGradient,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.qr_code_scanner_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                ),
              ),
              _buildNavItem(3, Icons.account_balance_wallet_rounded, 'Wallet'),
              _buildNavItem(4, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentTabIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textTertiary,
              size: 24,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- HOME TAB MAIN VIEW (Matching Image 1 Left Phone) ---
  Widget _buildHomeTab(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading) {
          return _buildHomeShimmer();
        }

        if (state is HomeLoaded) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // 1. Red Header matching Image 1
              _buildRedHeader(state),

              // 2. Search Bar with Barcode Scanner Icon
              _buildSearchBar(context),

              // 3. Hero Cashback Card (Save 5% on Every Purchase)
              _buildHeroCashbackBanner(context),

              // 4. 4 Feature Action Cards (Nearby Stores, Price Compare, Shopping List, My Wallet)
              _buildFourFeatureActions(context),

              // 5. Category Chips Row
              _buildCategoryChips(context, state),

              // 6. "Nearby Stores" Section Header + Carousel (Image 1)
              _buildSectionHeader(
                title: 'Nearby Stores',
                actionText: 'See All ->',
                onActionTap: () {
                  setState(() {
                    _currentTabIndex = 1; // go to stores tab
                  });
                },
              ),
              _buildNearbyStoresList(state.nearbyStores),

              // 7. "Deals & Offers" Section Header + Carousel (Image 1)
              _buildSectionHeader(
                title: 'Deals & Offers',
                actionText: 'See All ->',
                onActionTap: () {
                  Get.to(() => const DealsAndOffersScreen());
                },
              ),
              _buildDealsBanner(state.deals),

              // 8. "Featured Products" Section Header + Grid
              _buildSectionHeader(
                title: 'Best Deals on Groceries',
                actionText: 'View All ->',
                onActionTap: () {
                  Get.to(() => const ProductsCatalogScreen());
                },
              ),
              _buildProductsGrid(state.filteredProducts),

              const SliverToBoxAdapter(child: SizedBox(height: 30)),
            ],
          );
        }

        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
      },
    );
  }

  // --- 1. RED HEADER (Matching Image 1) ---
  Widget _buildRedHeader(HomeLoaded state) {
    return SliverToBoxAdapter(
      child: Container(
        color: AppColors.primary,
        padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Discount Logo Bag Icon
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.shopping_bag_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.user != null
                            ? 'Hi, ${state.user!.name.split(' ').first}!'
                            : 'Discount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        state.user != null
                            ? 'Wallet: ₹${state.user!.walletBalance.toStringAsFixed(0)} • 5% Cashback Active'
                            : 'Smart Savings Platform',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.88),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                // Notification Bell with Badge '2'
                Stack(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () {
                          ToastUtils.info('You have 2 new cashback notifications!');
                        },
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryDark,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Text(
                              '2',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),
            // Location Picker Pill: "Bengaluru, Karnataka v"
            InkWell(
              onTap: () {
                ToastUtils.info('Location: Bengaluru, Karnataka (Current GPS)');
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      state.locationName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. SEARCH BAR WITH BARCODE SCAN ICON (Image 1) ---
  Widget _buildSearchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextField(
            style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
            cursorColor: AppColors.primary,
            onSubmitted: (query) {
              if (query.isNotEmpty) {
                Get.to(() => PriceComparisonScreen(initialQuery: query));
              }
            },
            decoration: InputDecoration(
              hintText: 'Search products, stores...',
              hintStyle: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
                fontSize: 14,
              ),
              prefixIcon: const Icon(
                Icons.search_rounded,
                color: AppColors.textSecondary,
                size: 22,
              ),
              // Right Barcode Scanner Icon
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.qr_code_scanner_rounded,
                  color: AppColors.textPrimary,
                  size: 22,
                ),
                onPressed: () {
                  Get.to(() => const QRScannerReceiptScreen());
                },
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),
      ),
    );
  }

  // --- 3. HERO CASHBACK BANNER (Save 5% on Every Purchase - Image 1) ---
  Widget _buildHeroCashbackBanner(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          height: 146,
          decoration: BoxDecoration(
            gradient: AppColors.heroRedGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Left Content
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Instant Cashback Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD54F),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Instant Cashback',
                        style: TextStyle(
                          color: Color(0xFF3E2723),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Save 5%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const Text(
                      'on Every Purchase',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Shop Now ->
                    InkWell(
                      onTap: () {
                        Get.to(() => const ProductsCatalogScreen());
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Shop Now',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: AppColors.primary,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Right Graphic Shopper Woman
              Positioned(
                right: 10,
                bottom: 0,
                top: 0,
                child: Image.asset(
                  'assets/images/shopper_woman.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/hero_banner_customer.png',
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 4. 4 FEATURE ACTIONS (Nearby Stores, Price Compare, Shopping List, My Wallet) ---
  Widget _buildFourFeatureActions(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFeatureActionCard(
              icon: Icons.storefront_rounded,
              label: 'Nearby\nStores',
              color: const Color(0xFFE53935),
              onTap: () {
                setState(() {
                  _currentTabIndex = 1;
                });
              },
            ),
            _buildFeatureActionCard(
              icon: Icons.local_offer_rounded,
              label: 'Price\nCompare',
              color: const Color(0xFFE53935),
              onTap: () {
                Get.to(() => const PriceComparisonScreen());
              },
            ),
            _buildFeatureActionCard(
              icon: Icons.checklist_rounded,
              label: 'Shopping\nList',
              color: const Color(0xFF7E57C2),
              onTap: () {
                setState(() {
                  _currentTabIndex = 2;
                });
              },
            ),
            _buildFeatureActionCard(
              icon: Icons.account_balance_wallet_rounded,
              label: 'My\nWallet',
              color: const Color(0xFFFFA000),
              onTap: () {
                setState(() {
                  _currentTabIndex = 3;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 78,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 5. CATEGORY CHIPS ROW ---
  Widget _buildCategoryChips(BuildContext context, HomeLoaded state) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 42,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.categories.length,
          itemBuilder: (context, index) {
            final cat = state.categories[index];
            final isSelected = state.selectedCategory == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(
                  cat,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                onSelected: (selected) {
                  if (selected) {
                    context.read<HomeBloc>().add(SelectCategoryEvent(cat));
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }

  // --- SECTION HEADER HELPER ---
  Widget _buildSectionHeader({
    required String title,
    required String actionText,
    required VoidCallback onActionTap,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            InkWell(
              onTap: onActionTap,
              child: Text(
                actionText,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 6. NEARBY STORES CAROUSEL (Matching Image 1) ---
  Widget _buildNearbyStoresList(List<StoreModel> stores) {
    if (stores.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: const Row(
            children: [
              Icon(Icons.storefront_outlined, color: AppColors.textTertiary, size: 36),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No stores found nearby', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    SizedBox(height: 2),
                    Text('Stores will appear here once registered near you', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 195,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: stores.length,
          itemBuilder: (context, index) {
            final store = stores[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => StoreDetailsScreen(store: store));
              },
              child: Container(
                width: 250,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Store Photo with 5% Cashback Badge
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: store.imageUrl.startsWith('http')
                              ? CachedNetworkImage(
                                  imageUrl: store.imageUrl,
                                  height: 105,
                                  width: 250,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const ShimmerBox(width: 250, height: 105),
                                  errorWidget: (context, url, error) => Image.asset(
                                    'assets/images/store_fresh_mart.png',
                                    height: 105,
                                    width: 250,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Image.asset(
                                  'assets/images/store_fresh_mart.png',
                                  height: 105,
                                  width: 250,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        // Top Left "5% Cashback" Badge
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${store.defaultCashbackPercentage.toInt()}% Cashback',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Store Name & Rating
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                              const SizedBox(width: 3),
                              Text(
                                '${store.rating} (${store.reviewCount} reviews)',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.near_me_rounded, color: AppColors.primary, size: 13),
                              const SizedBox(width: 3),
                              Text(
                                '${store.distanceKm} km',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.successLight,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  store.isOpen ? 'Open' : 'Closed',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.success,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- 7. DEALS & OFFERS BANNER (Big Billion Days - Image 1) ---
  Widget _buildDealsBanner(List<DealModel> deals) {
    if (deals.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: deals.length,
          itemBuilder: (context, index) {
            final deal = deals[index];
            return Container(
              width: 310,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: const DecorationImage(
                  image: AssetImage('assets/images/deals_banner.png'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.65),
                      Colors.transparent,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      deal.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          '₹${deal.dealPrice.toInt()}',
                          style: const TextStyle(
                            color: Color(0xFFFFD54F),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '₹${deal.regularPrice.toInt()}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${deal.cashbackPercent.toInt()}% Cashback',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // --- 8. PRODUCTS GRID ---
  Widget _buildProductsGrid(List<ProductModel> products) {
    if (products.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: const Center(
            child: Column(
              children: [
                Icon(Icons.inventory_2_outlined, color: AppColors.textTertiary, size: 40),
                SizedBox(height: 8),
                Text('No products found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 4),
                Text('Try selecting another category or clear search', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => ProductDetailsView(product: product));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image + Discount Tag
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Container(
                            height: 110,
                            width: double.infinity,
                            color: const Color(0xFFF9FAFB),
                            child: product.imageUrl.startsWith('http')
                                ? CachedNetworkImage(
                                    imageUrl: product.imageUrl,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    ),
                                    errorWidget: (context, url, error) => Image.asset(
                                      'assets/images/amul_milk.png',
                                      fit: BoxFit.contain,
                                    ),
                                  )
                                : Image.asset(
                                    'assets/images/amul_milk.png',
                                    fit: BoxFit.contain,
                                  ),
                          ),
                        ),
                        if (product.discountPercent > 0)
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${product.discountPercent.toInt()}% OFF',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    // Title, Unit, Price, Add to Basket
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            product.unit,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Text(
                                '₹${product.price.toInt()}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '₹${product.mrp.toInt()}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          // Cashback amount note
                          Text(
                            '₹${product.effectivePrice.toStringAsFixed(1)} after 5% cashback',
                            style: const TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.success,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          childCount: products.length,
        ),
      ),
    );
  }

  // --- SHIMMER PLACEHOLDER WHILE HOME IS LOADING ---
  Widget _buildHomeShimmer() {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Container(
          height: 120,
          color: AppColors.primary,
          padding: const EdgeInsets.all(16),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: ShimmerBox(width: double.infinity, height: 48, borderRadius: 16),
        ),
        const DealsBannerShimmer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              ShimmerBox(width: 78, height: 78, borderRadius: 16),
              ShimmerBox(width: 78, height: 78, borderRadius: 16),
              ShimmerBox(width: 78, height: 78, borderRadius: 16),
              ShimmerBox(width: 78, height: 78, borderRadius: 16),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(16),
          child: StoreCardShimmer(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: StoreCardShimmer(),
        ),
      ],
    );
  }
}
