import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../core/network/api_client.dart';
import '../../wallet/screens/my_wallet_screen.dart';
import '../../deals/screens/deals_and_offers_screen.dart';

class CustomerProfileScreen extends StatelessWidget {
  const CustomerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dynamic User Profile Card
            FutureBuilder<Map<String, dynamic>?>(
              future: apiClient.getUserData(),
              builder: (context, snapshot) {
                final user = snapshot.data;
                final name = user?['name']?.toString() ?? 'Guest Shopper';
                final phone = user?['phone']?.toString() ?? 'Tap below to Login / Register';
                final isCustomer = user != null;

                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundColor: AppColors.primaryLight,
                        child: const Icon(
                          Icons.person_rounded,
                          size: 38,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              phone,
                              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: isCustomer ? const Color(0xFFFFD54F) : Colors.grey[200],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isCustomer ? 'Verified Member (5% Cashback)' : 'Guest Mode',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isCustomer ? const Color(0xFF3E2723) : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Profile Menu List (Matching Image 2 Screen 8)
            _buildProfileTile(
              Icons.shopping_bag_outlined,
              'My Orders & Receipts',
              onTap: () {
                ToastUtils.info('Opening My Orders');
              },
            ),
            _buildProfileTile(
              Icons.account_balance_wallet_outlined,
              'My Wallet & Withdrawals',
              onTap: () {
                Get.to(() => const MyWalletScreen());
              },
            ),
            _buildProfileTile(
              Icons.local_offer_outlined,
              'Deals & Offers',
              onTap: () {
                Get.to(() => const DealsAndOffersScreen());
              },
            ),
            _buildProfileTile(
              Icons.location_on_outlined,
              'My Saved Addresses',
              onTap: () {
                ToastUtils.info('Sector 15, Bengaluru');
              },
            ),
            _buildProfileTile(
              Icons.settings_outlined,
              'Settings',
              onTap: () {
                ToastUtils.info('Settings & Preferences');
              },
            ),
            _buildProfileTile(
              Icons.help_outline_rounded,
              'Help & Support',
              onTap: () {
                ToastUtils.info('Support: support@discountapp.in');
              },
            ),
            _buildProfileTile(
              Icons.logout_rounded,
              'Logout',
              color: AppColors.error,
              onTap: () async {
                await apiClient.clearAuth();
                ToastUtils.success('Logged out successfully');
                Get.offAllNamed(AppRoutes.customerLogin);
              },
            ),

            const SizedBox(height: 24),

            // App Version Footer
            Center(
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/app_logo.png',
                    height: 32,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.shopping_bag, color: AppColors.primary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Discount App India • Version 1.0.0 Production',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileTile(
    IconData icon,
    String title, {
    required VoidCallback onTap,
    Color? color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: (color ?? AppColors.primary).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color ?? AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color ?? AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
      ),
    );
  }
}
