import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MerchantSupportScreen extends StatelessWidget {
  const MerchantSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Help & Support'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contact Options
          Text(
            'Contact Us',
            style: AppTextStyles.semiboldMedium,
          ),
          const SizedBox(height: 16),
          _buildContactOption(
            Icons.phone,
            'Call Support',
            '+91 1800-123-4567',
            () {},
          ),
          _buildContactOption(
            Icons.email,
            'Email Support',
            'support@discountapp.in',
            () {},
          ),
          _buildContactOption(
            Icons.chat,
            'Live Chat',
            'Available 24/7',
            () {},
          ),
          const SizedBox(height: 24),
          // FAQ
          Text(
            'Frequently Asked Questions',
            style: AppTextStyles.semiboldMedium,
          ),
          const SizedBox(height: 16),
          _buildFAQItem(
            'How do I add products?',
            'Go to Products tab and click on Add Product button to add new products to your store.',
          ),
          _buildFAQItem(
            'How do I receive payments?',
            'Payments are automatically settled to your registered bank account within 24-48 hours.',
          ),
          _buildFAQItem(
            'How do I change my store details?',
            'Go to Settings > Store Information to update your shop details.',
          ),
          _buildFAQItem(
            'What is the commission rate?',
            'We charge a 2% commission on each transaction. Premium plans have lower rates.',
          ),
          const SizedBox(height: 24),
          // Help Resources
          Text(
            'Help Resources',
            style: AppTextStyles.semiboldMedium,
          ),
          const SizedBox(height: 16),
          _buildResourceItem(Icons.video_library, 'Video Tutorials'),
          _buildResourceItem(Icons.menu_book, 'User Guide'),
          _buildResourceItem(Icons.article, 'Blog'),
        ],
      ),
    );
  }

  Widget _buildContactOption(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: AppTextStyles.semiboldMedium),
        subtitle: Text(subtitle, style: AppTextStyles.caption),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTextStyles.semiboldMedium,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              answer,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: AppTextStyles.bodyMedium),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {},
      ),
    );
  }
}
