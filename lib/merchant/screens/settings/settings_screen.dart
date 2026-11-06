import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MerchantSettingsScreen extends StatelessWidget {
  const MerchantSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Store Details
          _buildSectionHeader('Store Details'),
          _buildSettingItem(
            Icons.store,
            'Store Information',
            'Update shop details',
            () {},
          ),
          _buildSettingItem(
            Icons.location_on,
            'Store Location',
            'Update store address',
            () {},
          ),
          _buildSettingItem(
            Icons.phone,
            'Contact Information',
            'Update phone and email',
            () {},
          ),
          const SizedBox(height: 24),
          // Payment Settings
          _buildSectionHeader('Payment Settings'),
          _buildSettingItem(
            Icons.account_balance,
            'Bank Details',
            'Manage bank account',
            () {},
          ),
          _buildSettingItem(
            Icons.qr_code,
            'QR Code Settings',
            'Customize QR code',
            () {},
          ),
          const SizedBox(height: 24),
          // Business Settings
          _buildSectionHeader('Business Settings'),
          _buildSettingItem(
            Icons.inventory,
            'Inventory Management',
            'Manage stock levels',
            () {},
          ),
          _buildSettingItem(
            Icons.local_offer,
            'Cashback Settings',
            'Configure cashback offers',
            () {},
          ),
          _buildSettingItem(
            Icons.receipt_long,
            'Invoice Settings',
            'Customize invoices',
            () {},
          ),
          const SizedBox(height: 24),
          // App Settings
          _buildSectionHeader('App Settings'),
          _buildSettingItem(
            Icons.language,
            'Language',
            'English',
            () {},
          ),
          _buildSettingItem(
            Icons.notifications,
            'Notifications',
            'Manage notifications',
            () {},
          ),
          _buildSettingItem(
            Icons.dark_mode,
            'Dark Mode',
            'Off',
            () {},
          ),
          const SizedBox(height: 24),
          // Account
          _buildSectionHeader('Account'),
          _buildSettingItem(
            Icons.security,
            'Security',
            'Password and 2FA',
            () {},
          ),
          _buildSettingItem(
            Icons.delete,
            'Delete Account',
            'Permanently delete account',
            () {},
            color: AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.semiboldMedium.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap, {
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(color: color),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.caption,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
