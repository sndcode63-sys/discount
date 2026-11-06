import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/toast_utils.dart';

class MerchantDashboardScreen extends StatefulWidget {
  const MerchantDashboardScreen({super.key});

  @override
  State<MerchantDashboardScreen> createState() =>
      _MerchantDashboardScreenState();
}

class _MerchantDashboardScreenState extends State<MerchantDashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: [
            _buildDashboardContent(),
            _buildProductsContent(),
            _buildOrdersContent(),
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2),
              label: 'Products',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return CustomScrollView(
      slivers: [
        // White App Bar
        SliverAppBar(
          floating: true,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Image.asset(
                'assets/images/app_logo.png',
                height: 26,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Text(
                'Merchant',
                style: AppTextStyles.h5.copyWith(color: AppColors.textPrimary),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: AppColors.textPrimary),
              onPressed: () {
                ToastUtils.info('Opening Merchant Notifications');
              },
            ),
          ],
        ),
        // Stats Cards
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Today\'s Sales',
                        '₹12,500',
                        Icons.trending_up,
                        AppColors.success,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Orders',
                        '45',
                        Icons.shopping_bag,
                        AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Products',
                        '128',
                        Icons.inventory,
                        AppColors.info,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Customers',
                        '256',
                        Icons.people,
                        AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Quick Actions
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'Quick Actions',
              style: AppTextStyles.semiboldMedium,
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    'Add Product',
                    Icons.add_circle,
                    () {
                      Get.toNamed(AppRoutes.merchantAddProduct);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAction(
                    'Billing',
                    Icons.qr_code_scanner,
                    () {
                      Get.toNamed(AppRoutes.merchantBilling);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildQuickAction(
                    'Share QR',
                    Icons.share,
                    () {
                      Get.toNamed(AppRoutes.merchantShareQR);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildQuickAction(
                    'Offers',
                    Icons.local_offer,
                    () {
                      Get.toNamed(AppRoutes.merchantOffers);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        // Recent Orders
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Orders',
                  style: AppTextStyles.semiboldMedium,
                ),
                TextButton(
                  onPressed: () {
                    ToastUtils.info('Opening All Merchant Orders');
                    Get.toNamed(AppRoutes.merchantSalesReport);
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: _buildOrderCard('#12345', '₹250', 'Completed'),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: _buildOrderCard('#12346', '₹180', 'Pending'),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.h5.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primary, size: 30),
              const SizedBox(height: 8),
              Text(
                title,
                style: AppTextStyles.semiboldSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(String orderId, String amount, String status) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.receipt, color: AppColors.primary),
        ),
        title: Text('Order $orderId', style: AppTextStyles.semiboldMedium),
        subtitle: Text(amount, style: AppTextStyles.bodyMedium),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: status == 'Completed'
                ? AppColors.success
                : AppColors.warning,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: AppTextStyles.overline.copyWith(color: AppColors.textWhite, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 90,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'Inventory & Products',
            style: AppTextStyles.h5,
          ),
          const SizedBox(height: 8),
          Text(
            'Manage store listings and stock levels',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.merchantProducts);
            },
            child: const Text('Manage Products'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 90,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            'Sales & Orders',
            style: AppTextStyles.h5,
          ),
          const SizedBox(height: 8),
          Text(
            'View order history & customer bills',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.merchantSalesReport);
            },
            child: const Text('View Sales Report'),
          ),
        ],
      ),
    );
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
              Icons.store,
              size: 50,
              color: AppColors.textWhite,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'FreshMart Store',
            style: AppTextStyles.h4,
          ),
          const SizedBox(height: 4),
          Text(
            '+91 9876543210 • Sector 15 Noida',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          _buildMenuItem(Icons.inventory, 'My Products', () {
            Get.toNamed(AppRoutes.merchantProducts);
          }),
          _buildMenuItem(Icons.analytics, 'Analytics & Reports', () {
            Get.toNamed(AppRoutes.merchantAnalytics);
          }),
          _buildMenuItem(Icons.account_balance_wallet, 'Merchant Wallet', () {
            Get.toNamed(AppRoutes.merchantWallet);
          }),
          _buildMenuItem(Icons.account_balance, 'Bank Settlements', () {
            Get.toNamed(AppRoutes.merchantSettlements);
          }),
          _buildMenuItem(Icons.local_offer, 'Store Offers', () {
            Get.toNamed(AppRoutes.merchantOffers);
          }),
          _buildMenuItem(Icons.subscriptions, 'Subscription Plan', () {
            Get.toNamed(AppRoutes.merchantSubscription);
          }),
          _buildMenuItem(Icons.settings, 'Settings', () {
            Get.toNamed(AppRoutes.merchantSettings);
          }),
          _buildMenuItem(Icons.help, 'Support', () {
            Get.toNamed(AppRoutes.merchantSupport);
          }),
          _buildMenuItem(Icons.logout, 'Logout', () {
            ToastUtils.info('Logged out from Merchant Portal');
            Get.offAllNamed(AppRoutes.merchantLogin);
          }, color: AppColors.error),
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
}
