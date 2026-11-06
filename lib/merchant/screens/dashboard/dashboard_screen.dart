import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
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

  String storeName = 'ABC General Store';
  String storeAddress = 'Sector 15, Noida, UP';
  double totalSales = 24580.0;
  double cashbackGiven = 1230.0;

  @override
  void initState() {
    super.initState();
    _fetchMerchantDataFromApi();
  }

  Future<void> _fetchMerchantDataFromApi() async {
    try {
      final user = await ApiClient().getUserData();
      if (user != null) {
        if (user['name'] != null && user['name'].toString().isNotEmpty) {
          storeName = user['name'].toString();
        }
        if (user['phone'] != null && user['phone'].toString().isNotEmpty) {
          storeAddress = '+91 ${user['phone']}';
        }
      }

      final response = await ApiClient().get(ApiConstants.adminDashboard);
      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        if (data['totalSales'] != null) {
          totalSales = (data['totalSales'] as num).toDouble();
        }
        if (data['cashbackGiven'] != null) {
          cashbackGiven = (data['cashbackGiven'] as num).toDouble();
        }
      }

      setState(() {});
    } catch (e) {
      setState(() {});
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
            _buildDashboardContent(),
            _buildProductsContent(),
            _buildOrdersContent(),
            _buildProfileContent(),
          ],
        ),
      ),
      bottomNavigationBar: _buildFloatingMerchantBottomBar(),
    );
  }

  Widget _buildFloatingMerchantBottomBar() {
    return Container(
      margin: const EdgeInsets.only(left: 14, right: 14, bottom: 14, top: 4),
      height: 62,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
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
          _buildNavItem(0, Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
          _buildNavItem(1, Icons.inventory_2_outlined, Icons.inventory_2, 'Products', onTapOverride: () {
            Get.toNamed(AppRoutes.merchantProducts);
          }),
          _buildNavItem(2, Icons.receipt_long_outlined, Icons.receipt_long, 'Bills', onTapOverride: () {
            Get.toNamed(AppRoutes.merchantBilling);
          }),
          _buildNavItem(3, Icons.person_outline, Icons.person, 'Profile'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label,
      {VoidCallback? onTapOverride}) {
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Column(
          mainAxisAlignment: Main.center,
          children: [
            Icon(isSelected ? activeIcon : icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Column(
      children: [
        // 1. Red Header
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
                  Icons.store,
                  color: Color(0xFFE53935),
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Merchant',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Grow Your Business',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: Colors.white, size: 26),
                onPressed: () {
                  ToastUtils.info('Merchant Notifications');
                },
              ),
            ],
          ),
        ),

        // 2. White Body Container Overlay
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Store Card matching Screenshot
                  Container(
                    padding: const EdgeInsets.all(14),
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
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F6F4),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.storefront,
                              color: Color(0xFFE53935), size: 32),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    storeName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE8F5E9),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.check_circle,
                                            size: 10, color: Color(0xFF2E7D32)),
                                        SizedBox(width: 2),
                                        Text(
                                          'Verified',
                                          style: TextStyle(
                                            color: Color(0xFF2E7D32),
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                storeAddress,
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2 KPI Stat Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildKpiCard(
                          'Total Sales ➔',
                          '₹${totalSales.toStringAsFixed(0)}',
                          '↑ 12%',
                          Icons.account_balance_wallet,
                          const Color(0xFFE53935),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildKpiCard(
                          'Cashback Given',
                          '₹${cashbackGiven.toStringAsFixed(0)}',
                          '↑ 10%',
                          Icons.stars,
                          const Color(0xFFFFB300),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // 4 Quick Action Buttons Grid matching Screenshot
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildActionGridButton(
                          'Add Products', Icons.add_box, const Color(0xFFE53935),
                          () {
                        Get.toNamed(AppRoutes.merchantAddProduct);
                      }),
                      _buildActionGridButton(
                          'Update Prices', Icons.local_offer, const Color(0xFF7B1FA2),
                          () {
                        Get.toNamed(AppRoutes.merchantProducts);
                      }),
                      _buildActionGridButton(
                          'View Bills', Icons.receipt_long, const Color(0xFF1976D2),
                          () {
                        Get.toNamed(AppRoutes.merchantBilling);
                      }),
                      _buildActionGridButton(
                          'Sales Report', Icons.bar_chart, const Color(0xFF2E7D32),
                          () {
                        Get.toNamed(AppRoutes.merchantSalesReport);
                      }),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Quick Actions List
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Quick Actions',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text('See All ➔',
                            style: TextStyle(
                                color: Color(0xFFE53935),
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  _buildQuickActionListTile(
                      'Manage Inventory', Icons.inventory, () {
                    Get.toNamed(AppRoutes.merchantInventory);
                  }),
                  _buildQuickActionListTile(
                      'View Customer Bills', Icons.description, () {
                    Get.toNamed(AppRoutes.merchantBilling);
                  }),
                  _buildQuickActionListTile(
                      'Check Cashback Summary', Icons.monetization_on, () {
                    Get.toNamed(AppRoutes.merchantCashback);
                  }),
                  _buildQuickActionListTile('Store Settings', Icons.settings,
                      () {
                    Get.toNamed(AppRoutes.merchantSettings);
                  }),
                  const SizedBox(height: 20),

                  // Grow Business Banner matching Screenshot
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFFFB74D)),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Grow Your Business',
                                style: TextStyle(
                                  color: Color(0xFFE65100),
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Get More Customers, Increase Local Repeat Sales with Discount App.',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.trending_up,
                            size: 45, color: Color(0xFFE65100)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard(
      String label, String value, String trend, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  trend,
                  style: const TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(color: Colors.grey[600], fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildActionGridButton(
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
                color: color.withValues(alpha: 0.12),
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

  Widget _buildQuickActionListTile(
      String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFE53935)),
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: onTap,
      ),
    );
  }

  Widget _buildProductsContent() {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Inventory & Products',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.merchantProducts);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935)),
              child: const Text('Manage Products Catalog'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersContent() {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Customer Bills & Sales',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(AppRoutes.merchantSalesReport);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE53935)),
              child: const Text('View Sales Reports'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
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
                Icons.store,
                size: 46,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              storeName,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              storeAddress,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),
            const SizedBox(height: 24),
            _buildQuickActionListTile('My Products Catalog', Icons.inventory,
                () {
              Get.toNamed(AppRoutes.merchantProducts);
            }),
            _buildQuickActionListTile('Analytics & Reports', Icons.analytics,
                () {
              Get.toNamed(AppRoutes.merchantAnalytics);
            }),
            _buildQuickActionListTile('Merchant Wallet', Icons.account_balance_wallet,
                () {
              Get.toNamed(AppRoutes.merchantWallet);
            }),
            _buildQuickActionListTile('Bank Settlements', Icons.account_balance,
                () {
              Get.toNamed(AppRoutes.merchantSettlements);
            }),
            _buildQuickActionListTile('Store Settings', Icons.settings, () {
              Get.toNamed(AppRoutes.merchantSettings);
            }),
            _buildQuickActionListTile('Logout', Icons.logout, () async {
              await ApiClient().clearAuth();
              ToastUtils.info('Logged out from Merchant Portal');
              Get.offAllNamed(AppRoutes.merchantLogin);
            }),
          ],
        ),
      ),
    );
  }
}
