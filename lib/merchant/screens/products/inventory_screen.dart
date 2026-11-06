import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MerchantInventoryScreen extends StatelessWidget {
  const MerchantInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Inventory'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Low Stock Alert
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.error),
            ),
            child: Row(
              children: [
                Icon(Icons.warning, color: AppColors.error),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Low Stock Alert',
                        style: AppTextStyles.semiboldMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '3 products are running low on stock',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Inventory List
          _buildInventoryItem('Apple Red', '5 units', 'Low'),
          _buildInventoryItem('Banana', '50 units', 'Good'),
          _buildInventoryItem('Tomato', '10 units', 'Low'),
          _buildInventoryItem('Potato', '0 units', 'Out of Stock'),
          _buildInventoryItem('Milk', '25 units', 'Good'),
        ],
      ),
    );
  }

  Widget _buildInventoryItem(String name, String stock, String status) {
    Color statusColor;
    switch (status) {
      case 'Good':
        statusColor = AppColors.success;
        break;
      case 'Low':
        statusColor = AppColors.warning;
        break;
      case 'Out of Stock':
        statusColor = AppColors.error;
        break;
      default:
        statusColor = AppColors.textTertiary;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.inventory, color: AppColors.primary),
        ),
        title: Text(name, style: AppTextStyles.semiboldMedium),
        subtitle: Text('Stock: $stock'),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: AppTextStyles.overline.copyWith(color: statusColor),
          ),
        ),
      ),
    );
  }
}
