import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MerchantSettlementsScreen extends StatelessWidget {
  const MerchantSettlementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Settlements'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildSummaryItem('Total Settled', '₹52,500'),
                _buildSummaryItem('Pending', '₹3,200'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Settlement History
          Text(
            'Settlement History',
            style: AppTextStyles.semiboldMedium,
          ),
          const SizedBox(height: 16),
          _buildSettlementCard('Oct 20, 2024', '₹12,500', 'Completed'),
          _buildSettlementCard('Oct 15, 2024', '₹15,000', 'Completed'),
          _buildSettlementCard('Oct 10, 2024', '₹10,000', 'Completed'),
          _buildSettlementCard('Oct 5, 2024', '₹15,000', 'Completed'),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String amount) {
    return Column(
      children: [
        Text(
          amount,
          style: AppTextStyles.h5.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.caption,
        ),
      ],
    );
  }

  Widget _buildSettlementCard(String date, String amount, String status) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.check_circle, color: AppColors.success),
        ),
        title: Text(date, style: AppTextStyles.semiboldMedium),
        subtitle: Text('Settlement ID: #S001'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount, style: AppTextStyles.semiboldMedium),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: AppTextStyles.overline.copyWith(color: AppColors.textWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
