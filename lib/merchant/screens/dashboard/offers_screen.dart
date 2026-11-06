import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MerchantOffersScreen extends StatelessWidget {
  const MerchantOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Offers & Promotions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Active Offers
          Text(
            'Active Offers',
            style: AppTextStyles.semiboldMedium,
          ),
          const SizedBox(height: 16),
          _buildOfferCard('Flat 20% OFF', 'On all products', 'Valid till Oct 30', true),
          _buildOfferCard('Buy 2 Get 1 Free', 'On dairy products', 'Valid till Oct 25', true),
          const SizedBox(height: 24),
          // Past Offers
          Text(
            'Past Offers',
            style: AppTextStyles.semiboldMedium,
          ),
          const SizedBox(height: 16),
          _buildOfferCard('First Order 50% OFF', 'For new customers', 'Expired', false),
          _buildOfferCard('Weekend Special', '15% off on weekends', 'Expired', false),
        ],
      ),
    );
  }

  Widget _buildOfferCard(String title, String description, String validity, bool isActive) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: AppTextStyles.semiboldMedium,
                  ),
                ),
                if (isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Active',
                      style: AppTextStyles.overline.copyWith(color: AppColors.textWhite),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.textTertiary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Expired',
                      style: AppTextStyles.overline.copyWith(color: AppColors.textWhite),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              validity,
              style: AppTextStyles.caption,
            ),
            if (isActive) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      child: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                      ),
                      child: const Text('End'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
