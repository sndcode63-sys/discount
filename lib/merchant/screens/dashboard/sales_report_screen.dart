import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MerchantSalesReportScreen extends StatelessWidget {
  const MerchantSalesReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Sales Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Date Range
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Oct 1 - Oct 24, 2024',
                    style: AppTextStyles.semiboldMedium,
                  ),
                ),
                const Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Summary
          _buildSummaryRow('Total Revenue', '₹45,000'),
          _buildSummaryRow('Total Orders', '156'),
          _buildSummaryRow('Average Order Value', '₹288'),
          _buildSummaryRow('Total Customers', '89'),
          const SizedBox(height: 24),
          // Order List
          Text(
            'Recent Orders',
            style: AppTextStyles.semiboldMedium,
          ),
          const SizedBox(height: 16),
          _buildOrderItem('#12345', '₹250', 'Completed', 'Today, 2:30 PM'),
          _buildOrderItem('#12346', '₹180', 'Completed', 'Today, 1:15 PM'),
          _buildOrderItem('#12347', '₹320', 'Pending', 'Yesterday, 5:45 PM'),
          _buildOrderItem('#12348', '₹150', 'Completed', 'Yesterday, 4:20 PM'),
          _buildOrderItem('#12349', '₹200', 'Completed', 'Oct 22, 3:10 PM'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium,
          ),
          Text(
            value,
            style: AppTextStyles.semiboldMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(String orderId, String amount, String status, String time) {
    Color statusColor = status == 'Completed' ? AppColors.success : AppColors.warning;

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
          child: const Icon(Icons.receipt, color: AppColors.primary),
        ),
        title: Text('Order $orderId', style: AppTextStyles.semiboldMedium),
        subtitle: Text(time, style: AppTextStyles.caption),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount, style: AppTextStyles.semiboldMedium),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor,
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
