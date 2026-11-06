import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MerchantWalletScreen extends StatelessWidget {
  const MerchantWalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Merchant Wallet'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Balance Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Available Balance',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '₹15,500',
                    style: AppTextStyles.h2.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textWhite,
                            side: const BorderSide(color: AppColors.textWhite),
                          ),
                          child: const Text('Withdraw'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textWhite,
                            foregroundColor: AppColors.primary,
                          ),
                          child: const Text('View Statement'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Pending Amount
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warning),
              ),
              child: Row(
                children: [
                  Icon(Icons.pending, color: AppColors.warning, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pending Settlement',
                          style: AppTextStyles.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹3,200',
                          style: AppTextStyles.priceMedium.copyWith(
                            color: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Transaction History
            Text(
              'Transaction History',
              style: AppTextStyles.semiboldMedium,
            ),
            const SizedBox(height: 16),
            _buildTransactionItem(
              'Order Payment',
              '₹250',
              'Today, 2:30 PM',
              Icons.arrow_downward,
              AppColors.success,
            ),
            _buildTransactionItem(
              'Withdrawal',
              '-₹5,000',
              'Yesterday, 5:45 PM',
              Icons.arrow_upward,
              AppColors.error,
            ),
            _buildTransactionItem(
              'Order Payment',
              '₹180',
              'Oct 20, 10:00 AM',
              Icons.arrow_downward,
              AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    String title,
    String amount,
    String date,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: AppTextStyles.bodyMedium),
      subtitle: Text(date, style: AppTextStyles.caption),
      trailing: Text(
        amount,
        style: AppTextStyles.semiboldMedium.copyWith(
          color: color,
        ),
      ),
    );
  }
}
