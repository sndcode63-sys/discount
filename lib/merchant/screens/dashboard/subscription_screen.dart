import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MerchantSubscriptionScreen extends StatelessWidget {
  const MerchantSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Subscription Plans'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Plan
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary),
              ),
              child: Row(
                children: [
                  Icon(Icons.workspace_premium, color: AppColors.primary, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Plan: Basic',
                          style: AppTextStyles.semiboldMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Renews on Nov 24, 2024',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Available Plans
            Text(
              'Available Plans',
              style: AppTextStyles.semiboldMedium,
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              'Basic',
              '₹499/month',
              'For small businesses',
              [
                'Up to 100 products',
                'Basic analytics',
                'Email support',
              ],
              false,
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              'Professional',
              '₹999/month',
              'For growing businesses',
              [
                'Up to 500 products',
                'Advanced analytics',
                'Priority support',
                'Custom branding',
              ],
              true,
            ),
            const SizedBox(height: 16),
            _buildPlanCard(
              'Enterprise',
              '₹2499/month',
              'For large businesses',
              [
                'Unlimited products',
                'Full analytics suite',
                '24/7 support',
                'API access',
                'Dedicated manager',
              ],
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
    String name,
    String price,
    String description,
    List<String> features,
    bool isPopular,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: AppTextStyles.h5,
                          ),
                          if (isPopular) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.warning,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Popular',
                                style: AppTextStyles.overline.copyWith(
                                  color: AppColors.textWhite,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        price,
                        style: AppTextStyles.priceMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: AppColors.success,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: AppTextStyles.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: isPopular
                    ? null
                    : ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textTertiary,
                      ),
                child: const Text('Subscribe'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
