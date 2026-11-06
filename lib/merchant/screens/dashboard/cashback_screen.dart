import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MerchantCashbackScreen extends StatelessWidget {
  const MerchantCashbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Cashback Management'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Cashback Rate
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Cashback Rate',
                  style: AppTextStyles.semiboldMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '5%',
                      style: AppTextStyles.h3.copyWith(color: AppColors.primary),
                    ),
                    const Spacer(),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Change'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Cashback Rules
          Text(
            'Cashback Rules',
            style: AppTextStyles.semiboldMedium,
          ),
          const SizedBox(height: 16),
          _buildRuleCard('Minimum Order', '₹100'),
          _buildRuleCard('Maximum Cashback', '₹50 per order'),
          _buildRuleCard('Cashback Validity', '30 days'),
          const SizedBox(height: 24),
          // Cashback History
          Text(
            'Recent Cashback Given',
            style: AppTextStyles.semiboldMedium,
          ),
          const SizedBox(height: 16),
          _buildCashbackItem('Order #12345', '₹5', 'Today'),
          _buildCashbackItem('Order #12346', '₹9', 'Yesterday'),
          _buildCashbackItem('Order #12347', '₹15', 'Oct 22'),
        ],
      ),
    );
  }

  Widget _buildRuleCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(label, style: AppTextStyles.bodyMedium),
        trailing: Text(value, style: AppTextStyles.semiboldMedium),
      ),
    );
  }

  Widget _buildCashbackItem(String orderId, String amount, String date) {
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
          child: const Icon(Icons.account_balance_wallet, color: AppColors.success),
        ),
        title: Text(orderId, style: AppTextStyles.semiboldMedium),
        subtitle: Text(date, style: AppTextStyles.caption),
        trailing: Text(amount, style: AppTextStyles.semiboldMedium),
      ),
    );
  }
}
