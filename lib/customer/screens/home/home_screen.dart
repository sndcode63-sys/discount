import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../shared/models/product.dart';
import '../../../shared/models/store.dart';
import '../../../shared/widgets/product_card.dart';
import '../../controllers/cart_controller.dart';
import '../../widgets/search_store_near_you_widget.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final CartController cartController = Get.put(CartController());
  int _currentIndex = 0;
  bool _isLoading = true;

  List<Product> products = [];
  List<Store> nearbyStores = [];
  List<String> categories = [
    'Fruits',
    'Vegetables',
    'Dairy',
    'Bakery',
    'Grains',
    'Snacks',
    'Beverages',
    'Household'
  ];

  @override
  void initState() {
    super.initState();
    _loadHomeDataFromApi();
  }

  Future<void> _loadHomeDataFromApi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Fetch Products
      final prodResp = await ApiClient().get(ApiConstants.products);
      if (prodResp.success && prodResp.data != null) {
        final rawData = prodResp.data;
        List<dynamic> listData = [];
        if (rawData is Map<String, dynamic>) {
          if (rawData['data'] is List) {
            listData = rawData['data'] as List;
          } else if (rawData['products'] is List) {
            listData = rawData['products'] as List;
          }
        } else if (rawData is List) {
          listData = rawData;
        }

        products = listData
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      // 2. Fetch Nearby Stores
      final storeResp = await ApiClient().get(ApiConstants.nearbyStores);
      if (storeResp.success && storeResp.data != null) {
        final rawData = storeResp.data;
        List<dynamic> storeList = [];
        if (rawData is Map<String, dynamic> && rawData['stores'] is List) {
          storeList = rawData['stores'] as List;
        } else if (rawData is List) {
          storeList = rawData;
        }

        nearbyStores = storeList
            .map((item) => Store.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE53935), // Red top header
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildHomeContent(),
            _buildSearchContent(),
            _buildCartContent(),
            _buildProfileContent(),
          ],
        ),
      ),
      bottomNavigationBar: _buildFloatingCustomerBottomBar(),
    );
  }

  // Floating Bottom Bar matching UI Screenshot (5 items with center red QR button)
  Widget _buildFloatingCustomerBottomBar() {
    return Container(
      margin: const EdgeInsets.only(left: 14, right: 14, bottom: 14, top: 4),
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home, 'Home'),
          _buildNavItem(1, Icons.storefront, 'Stores', onTapOverride: () {
            Get.toNamed(AppRoutes.customerNearbyStores);
          }),
          // Center Red Floating QR Button
          GestureDetector(
            onTap: () {
              ToastUtils.info('Opening QR Scanner');
              Get.toNamed('/customer/qr-scanner');
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE53935), Color(0xFFC62828)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE53935).withValues(alpha: 0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.qr_code_scanner,
                color: Colors.white,
                size: 26,
              ),
            ),
          ),
          _buildNavItem(2, Icons.account_balance_wallet, 'Wallet', isCartTab: true),
          _buildNavItem(3, Icons.person, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label,
      {VoidCallback? onTapOverride, bool isCartTab = false}) {
    final bool isSelected = _currentIndex == index;
    final color = isSelected ? const Color(0xFFE53935) : Colors.grey[500];

    return InkWell(
      onTap: () {
        if (onTapOverride != null) {
          onTapOverride();
        } else {
          setState(() {
            _currentIndex = index;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isCartTab)
              Obx(() => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(Icons.shopping_cart, color: color, size: 22),
                      if (cartController.cartItems.isNotEmpty)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE53935),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${cartController.cartItems.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ))
            else
              Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              isCartTab ? 'Cart' : label,
              style: TextStyle(
                color: color,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        // 1. Red Header matching Screenshot
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          color: const Color(0xFFE53935),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_offer,
                  color: Color(0xFFE53935),
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Discount',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Smart Savings Platform',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: Colors.white, size: 26),
                    onPressed: () {
                      ToastUtils.info('Opening Notifications');
                      Get.toNamed(AppRoutes.customerNotifications);
                    },
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '2',
                        style: TextStyle(
                          color: Color(0xFFE53935),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // 2. White Curved Container Overlay
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: CustomScrollView(
              slivers: [
                // Location Bar & Search Input
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      children: [
                        // Location Picker
                        InkWell(
                          onTap: () {
                            ToastUtils.info('Location: Sector 15, Noida');
                          },
                          child: Row(
                            children: [
                              const Icon(Icons.location_on_outlined,
                                  size: 18, color: Colors.black87),
                              const SizedBox(width: 4),
                              const Text(
                                'Sector 15, Noida',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down,
                                  size: 18, color: Colors.black87),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Search Field
                        TextField(
                          onTap: () {
                            setState(() {
                              _currentIndex = 1;
                            });
                          },
                          readOnly: true,
                          style: const TextStyle(color: Colors.black, fontSize: 14),
                          decoration: InputDecoration(
                            hintText: 'Search products, stores...',
                            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.qr_code_scanner,
                                  color: Color(0xFFE53935)),
                              onPressed: () {
                                Get.toNamed('/customer/qr-scanner');
                              },
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Promo Cashback Banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      height: 130,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE53935), Color(0xFFC62828)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE53935).withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFB300),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'Instant Cashback',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Save 5% on Every Purchase',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
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
                                          color: Color(0xFFE53935),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward,
                                        size: 12,
                                        color: Color(0xFFE53935),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 12,
                            bottom: 10,
                            child: Icon(
                              Icons.shopping_bag,
                              size: 90,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 4 Action Buttons Row (Nearby Stores, Price Compare, Shopping List, Wallet)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildActionCard('Nearby Stores', Icons.storefront,
                            const Color(0xFFE53935), () {
                          Get.toNamed(AppRoutes.customerNearbyStores);
                        }),
                        _buildActionCard('Price Compare', Icons.compare_arrows,
                            const Color(0xFFE53935), () {
                          Get.toNamed(AppRoutes.customerPriceComparison);
                        }),
                        _buildActionCard('Shopping List', Icons.check_box,
                            const Color(0xFF7B1FA2), () {
                          Get.toNamed(AppRoutes.customerShoppingList);
                        }),
                        _buildActionCard('My Wallet', Icons.account_balance_wallet,
                            const Color(0xFFE65100), () {
                          Get.toNamed(AppRoutes.customerWallet);
                        }),
                      ],
                    ),
                  ),
                ),

                // Nearby Stores Section Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nearby Stores',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.customerNearbyStores);
                          },
                          child: const Row(
                            children: [
                              Text(
                                'See All',
                                style: TextStyle(
                                  color: Color(0xFF1976D2),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.arrow_forward,
                                  size: 12, color: Color(0xFF1976D2)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Nearby Stores Horizontal List from API
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 130,
                    child: nearbyStores.isEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return _buildSampleStoreCard(
                                  index == 0 ? 'Fresh Mart' : 'Grocery Plus',
                                  index == 0 ? '1.2 km' : '2.0 km');
                            },
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: nearbyStores.length,
                            itemBuilder: (context, index) {
                              final st = nearbyStores[index];
                              return _buildSampleStoreCard(
                                  st.name, '${st.distance.toStringAsFixed(1)} km');
                            },
                          ),
                  ),
                ),

                // Best Deals Section Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Best Deals Near You',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(AppRoutes.customerOffers);
                          },
                          child: const Row(
                            children: [
                              Text(
                                'See All',
                                style: TextStyle(
                                  color: Color(0xFF1976D2),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.arrow_forward,
                                  size: 12, color: Color(0xFF1976D2)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Product Grid from API
                if (_isLoading)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(color: Color(0xFFE53935)),
                    ),
                  )
                else if (products.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_bag_outlined,
                              size: 60, color: Colors.grey),
                          const SizedBox(height: 12),
                          const Text('No products available right now',
                              style: TextStyle(color: Colors.black)),
                          const SizedBox(height: 12),
                          ElevatedButton(
                            onPressed: _loadHomeDataFromApi,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFE53935)),
                            child: const Text('Refresh API'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.customerProductDetails,
                                arguments: product,
                              );
                            },
                            onAddToCart: () {
                              cartController.addToCart(product);
                            },
                          );
                        },
                        childCount: products.length,
                      ),
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
      String title, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSampleStoreCard(String name, String dist) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F6F4),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.storefront,
                color: Color(0xFFE53935), size: 36),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '5% Cashback',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star,
                        size: 11, color: Color(0xFFFFB300)),
                    const SizedBox(width: 2),
                    const Text('4.5',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 10,
                            fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Open',
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '📍 $dist',
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchContent() {
    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              cursorColor: Colors.black,
              onSubmitted: (query) {
                if (query.trim().isNotEmpty) {
                  ToastUtils.info('Searching for "$query"');
                }
              },
              decoration: InputDecoration(
                hintText: 'Search products, grocery, fruits...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 14),
            const SearchStoreNearYouWidget(),
            const SizedBox(height: 20),
            const Text(
              'Popular Categories',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...categories.map(
              (category) => ListTile(
                leading: const Icon(Icons.arrow_forward_ios, size: 14),
                title: Text(category,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w600)),
                onTap: () {
                  ToastUtils.info('Selected category: $category');
                },
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent() {
    return Container(
      color: AppColors.background,
      child: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 90,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: AppTextStyles.h4,
                ),
                const SizedBox(height: 8),
                Text(
                  'Browse items and add deals to your cart',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  child: const Text('Start Shopping'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('My Shopping Basket', style: AppTextStyles.h4),
                  TextButton.icon(
                    onPressed: () {
                      cartController.clearCart();
                      ToastUtils.info('Cart cleared');
                    },
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Clear'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartController.cartItems[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F6F4),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.shopping_bag,
                              color: Color(0xFFE53935),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(
                                    '${item.product.store} • ${item.product.unit}',
                                    style: AppTextStyles.caption),
                                const SizedBox(height: 6),
                                Text(
                                  '₹${item.product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      color: Color(0xFFE53935),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline,
                                    color: AppColors.error),
                                onPressed: () => cartController.updateQuantity(
                                    item.product, -1),
                              ),
                              Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline,
                                    color: Color(0xFFE53935)),
                                onPressed: () => cartController.updateQuantity(
                                    item.product, 1),
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
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal', style: AppTextStyles.bodyMedium),
                      Text('₹${cartController.subtotal.toStringAsFixed(0)}',
                          style: AppTextStyles.semiboldMedium),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery Charge', style: AppTextStyles.bodyMedium),
                      Text(
                        cartController.deliveryFee == 0
                            ? 'FREE'
                            : '₹${cartController.deliveryFee.toStringAsFixed(0)}',
                        style: AppTextStyles.semiboldMedium.copyWith(
                          color: cartController.deliveryFee == 0
                              ? AppColors.success
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Grand Total', style: AppTextStyles.semiboldLarge),
                      Text('₹${cartController.total.toStringAsFixed(0)}',
                          style: AppTextStyles.priceMedium),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.customerCheckout);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE53935),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'Proceed to Checkout (${cartController.cartItems.length} Items)',
                        style: AppTextStyles.button,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildProfileContent() {
    return FutureBuilder<Map<String, dynamic>?>(
      future: ApiClient().getUserData(),
      builder: (context, snapshot) {
        final userData = snapshot.data;
        final name = userData?['name'] ?? userData?['phone'] ?? 'Rohit Sharma';
        final phone = userData?['phone'] ?? '+91 98765-43210';

        return Container(
          color: AppColors.background,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                CircleAvatar(
                  radius: 44,
                  backgroundColor: const Color(0xFFE53935),
                  child: const Icon(
                    Icons.person,
                    size: 46,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  name.toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  phone.toString(),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),
                _buildMenuItem(
                  Icons.shopping_bag_outlined,
                  'My Orders',
                  () {
                    ToastUtils.info('Opening My Orders');
                  },
                ),
                _buildMenuItem(
                  Icons.account_balance_wallet_outlined,
                  'My Wallet',
                  () {
                    Get.toNamed(AppRoutes.customerWallet);
                  },
                ),
                _buildMenuItem(
                  Icons.location_on_outlined,
                  'My Addresses',
                  () {
                    ToastUtils.info('Opening Saved Addresses');
                  },
                ),
                _buildMenuItem(
                  Icons.settings_outlined,
                  'Settings',
                  () {
                    ToastUtils.info('Opening Settings');
                  },
                ),
                _buildMenuItem(
                  Icons.help_outline,
                  'Help & Support',
                  () {
                    ToastUtils.info('Opening Support');
                  },
                ),
                _buildMenuItem(
                  Icons.logout,
                  'Logout',
                  () async {
                    await ApiClient().clearAuth();
                    ToastUtils.info('Logged out successfully');
                    Get.offAllNamed(AppRoutes.customerLogin);
                  },
                  color: AppColors.error,
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'Discount India • Version 1.0.0',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? const Color(0xFFE53935)),
        title: Text(
          title,
          style: TextStyle(
              color: color ?? Colors.black, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }
}
