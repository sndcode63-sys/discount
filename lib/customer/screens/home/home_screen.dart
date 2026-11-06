import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/sample_data.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../shared/models/product.dart';
import '../../../shared/widgets/product_card.dart';
import '../../controllers/cart_controller.dart';
import '../../widgets/search_store_near_you_widget.dart';

class CustomerHomeScreen extends StatefulWidget {
  const CustomerHomeScreen({super.key});

  @override
  State<CustomerHomeScreen> createState() => _CustomerHomeScreenState();
}

class _CustomerHomeScreenState extends State<CustomerHomeScreen> {
  final List<Product> products = SampleData.getProducts();
  final CartController cartController = Get.put(CartController());
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
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
      bottomNavigationBar: _buildFloatingBottomNavBar(),
    );
  }

  Widget _buildFloatingBottomNavBar() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textTertiary,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Obx(() => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_cart_outlined),
                      if (cartController.cartItems.isNotEmpty)
                        Positioned(
                          right: -6,
                          top: -6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.error,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '${cartController.cartItems.length}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  )),
              activeIcon: const Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return CustomScrollView(
      slivers: [
        // White App Bar
        SliverAppBar(
          floating: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: InkWell(
            onTap: () {
              ToastUtils.info('Location: Sector 15, Noida');
            },
            child: Row(
              children: [
                Image.asset(
                  'assets/images/app_logo.png',
                  height: 28,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 18,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    'Sector 15, Noida',
                    style: AppTextStyles.semiboldMedium.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.arrow_drop_down, color: AppColors.textPrimary),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
              onPressed: () {
                ToastUtils.info('Opening Notifications');
                Get.toNamed(AppRoutes.customerNotifications);
              },
            ),
          ],
        ),
        // Search Bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
              readOnly: true,
              decoration: InputDecoration(
                hintText: 'Search products, stores...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () {
                    ToastUtils.info('Voice search');
                  },
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        // Categories Row
        SliverToBoxAdapter(
          child: SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: SampleData.getCategories().length,
              itemBuilder: (context, index) {
                final category = SampleData.getCategories()[index];
                return GestureDetector(
                  onTap: () {
                    ToastUtils.info('Category: $category');
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 14),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            _getCategoryIcon(category),
                            color: AppColors.primary,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          category,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        // Deals Section Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Best Deals Near You',
                  style: AppTextStyles.h4,
                ),
                TextButton(
                  onPressed: () {
                    ToastUtils.info('Viewing All Offers');
                    Get.toNamed(AppRoutes.customerOffers);
                  },
                  child: Text(
                    'View All',
                    style: AppTextStyles.semiboldSmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Product Grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
    );
  }

  Widget _buildSearchContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.w500,
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
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Google Maps "Search store near you" Section
          const SearchStoreNearYouWidget(),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Recent Searches',
              style: AppTextStyles.semiboldMedium,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SampleData.getRecentSearches()
                .map(
                  (search) => ActionChip(
                    label: Text(search),
                    onPressed: () {
                      ToastUtils.info('Searching for $search');
                    },
                    backgroundColor: AppColors.surface,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Popular Categories',
              style: AppTextStyles.semiboldMedium,
            ),
          ),
          const SizedBox(height: 12),
          ...SampleData.getPopularCategories().map(
            (category) => ListTile(
              leading: const Icon(Icons.arrow_forward_ios, size: 16),
              title: Text(category),
              onTap: () {
                ToastUtils.info('Selected category: $category');
              },
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildCartContent() {
    return Obx(() {
      if (cartController.cartItems.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 90,
                color: AppColors.textTertiary,
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
                            color: AppColors.primaryLight.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getCategoryIcon(item.product.category),
                            color: AppColors.primary,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.product.name, style: AppTextStyles.semiboldMedium),
                              const SizedBox(height: 2),
                              Text('${item.product.store} • ${item.product.unit}', style: AppTextStyles.caption),
                              const SizedBox(height: 6),
                              Text(
                                '₹${item.product.price.toStringAsFixed(0)}',
                                style: AppTextStyles.semiboldMedium.copyWith(color: AppColors.primary),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                              onPressed: () => cartController.updateQuantity(item.product, -1),
                            ),
                            Text(
                              '${item.quantity}',
                              style: AppTextStyles.semiboldLarge,
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
                              onPressed: () => cartController.updateQuantity(item.product, 1),
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
          // Total and Proceed to Checkout
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: AppTextStyles.bodyMedium),
                    Text('₹${cartController.subtotal.toStringAsFixed(0)}', style: AppTextStyles.semiboldMedium),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Charge', style: AppTextStyles.bodyMedium),
                    Text(
                      cartController.deliveryFee == 0 ? 'FREE' : '₹${cartController.deliveryFee.toStringAsFixed(0)}',
                      style: AppTextStyles.semiboldMedium.copyWith(
                        color: cartController.deliveryFee == 0 ? AppColors.success : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Grand Total', style: AppTextStyles.semiboldLarge),
                    Text('₹${cartController.total.toStringAsFixed(0)}', style: AppTextStyles.priceMedium),
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
                      backgroundColor: AppColors.primary,
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
    });
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 46,
            backgroundColor: AppColors.primary,
            child: const Icon(
              Icons.person,
              size: 50,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Rahul Sharma',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 4),
          Text(
            '+91 9876543210',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
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
            Icons.favorite_border,
            'Wishlist & Saved Items',
            () {
              ToastUtils.info('Opening Wishlist');
            },
          ),
          _buildMenuItem(
            Icons.location_on_outlined,
            'My Delivery Addresses',
            () {
              ToastUtils.info('Opening Saved Addresses');
            },
          ),
          _buildMenuItem(
            Icons.local_offer_outlined,
            'Offers & Coupons',
            () {
              Get.toNamed(AppRoutes.customerOffers);
            },
          ),
          _buildMenuItem(
            Icons.account_balance_wallet_outlined,
            'Discount Wallet',
            () {
              Get.toNamed(AppRoutes.customerWallet);
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
            () {
              ToastUtils.info('Logged out successfully');
              Get.offAllNamed(AppRoutes.customerLogin);
            },
            color: AppColors.error,
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/app_logo.png',
                  height: 36,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 6),
                Text(
                  'Discount India • Version 1.0.0',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textTertiary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.primary),
        title: Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'fruits':
        return Icons.apple;
      case 'vegetables':
        return Icons.eco;
      case 'dairy':
        return Icons.egg;
      case 'bakery':
        return Icons.bakery_dining;
      case 'grains':
        return Icons.grain;
      case 'snacks':
        return Icons.cookie;
      case 'beverages':
        return Icons.local_drink;
      case 'personal care':
        return Icons.face;
      case 'household':
        return Icons.cleaning_services;
      case 'frozen':
        return Icons.ac_unit;
      default:
        return Icons.shopping_bag;
    }
  }
}
