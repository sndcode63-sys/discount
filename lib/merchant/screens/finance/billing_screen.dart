import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MerchantBillingScreen extends StatelessWidget {
  const MerchantBillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Billing & Checkout'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // QR Code Display
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.qr_code_2,
                          size: 150,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'FreshMart',
                          style: AppTextStyles.h5,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Scan to pay',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Recent Bills
                  Text(
                    'Recent Bills',
                    style: AppTextStyles.semiboldMedium,
                  ),
                  const SizedBox(height: 16),
                  _buildBillCard('#B001', '₹250', 'Completed'),
                  _buildBillCard('#B002', '₹180', 'Completed'),
                  _buildBillCard('#B003', '₹320', 'Pending'),
                ],
              ),
            ),
          ),
          // Bottom Actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Get.toNamed(AppRoutes.merchantShareQR);
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Share QR'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                    label: const Text('New Bill'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillCard(String billId, String amount, String status) {
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
        title: Text(billId, style: AppTextStyles.semiboldMedium),
        subtitle: Text(amount),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: status == 'Completed'
                ? AppColors.success
                : AppColors.warning,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            status,
            style: AppTextStyles.overline.copyWith(color: AppColors.textWhite),
          ),
        ),
      ),
    );
  }
}
