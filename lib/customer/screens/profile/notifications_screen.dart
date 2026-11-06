import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationItem(
            'Order Delivered',
            'Your order #12345 has been delivered successfully',
            '2 hours ago',
            Icons.check_circle,
            AppColors.success,
            true,
          ),
          _buildNotificationItem(
            'Great Offer!',
            'Get 50% off on your next order. Use code: FIRST50',
            '5 hours ago',
            Icons.local_offer,
            AppColors.discountOrange,
            true,
          ),
          _buildNotificationItem(
            'Cashback Received',
            'You received ₹25 cashback on your last order',
            'Yesterday',
            Icons.account_balance_wallet,
            AppColors.primary,
            false,
          ),
          _buildNotificationItem(
            'Price Drop Alert',
            'Apple Red price dropped to ₹120 from ₹200',
            '2 days ago',
            Icons.trending_down,
            AppColors.discountGreen,
            false,
          ),
          _buildNotificationItem(
            'New Store Added',
            'FreshMart is now available in your area',
            '3 days ago',
            Icons.store,
            AppColors.info,
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String message,
    String time,
    IconData icon,
    Color color,
    bool isUnread,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isUnread ? AppColors.primaryLight.withOpacity(0.1) : null,
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: AppTextStyles.semiboldMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: AppTextStyles.caption,
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
