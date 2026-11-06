import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MerchantAnalyticsScreen extends StatelessWidget {
  const MerchantAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time Filter
            Row(
              children: [
                _buildTimeFilter('Daily', true),
                const SizedBox(width: 8),
                _buildTimeFilter('Weekly', false),
                const SizedBox(width: 8),
                _buildTimeFilter('Monthly', false),
              ],
            ),
            const SizedBox(height: 24),
            // Sales Chart Placeholder
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.show_chart,
                      size: 60,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sales Chart',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Stats Grid
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Total Sales', '₹45,000', Icons.trending_up),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Orders', '156', Icons.shopping_bag),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Avg Order', '₹288', Icons.receipt),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Customers', '89', Icons.people),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Top Products
            Text(
              'Top Selling Products',
              style: AppTextStyles.semiboldMedium,
            ),
            const SizedBox(height: 16),
            _buildTopProduct('Apple Red', '₹12,500', 50),
            _buildTopProduct('Milk', '₹8,500', 85),
            _buildTopProduct('Bread', '₹6,200', 62),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeFilter(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: isSelected ? AppColors.textWhite : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: AppTextStyles.h6,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopProduct(String name, String sales, int orders) {
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
          child: const Icon(Icons.shopping_bag, color: AppColors.primary),
        ),
        title: Text(name, style: AppTextStyles.semiboldMedium),
        subtitle: Text('$orders orders'),
        trailing: Text(sales, style: AppTextStyles.semiboldMedium),
      ),
    );
  }
}
