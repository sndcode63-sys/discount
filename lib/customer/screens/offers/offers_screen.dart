import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Offers & Coupons'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Banner
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.primaryLight],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Great Offers',
                    style: AppTextStyles.h3.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                  Text(
                    'Big Savings',
                    style: AppTextStyles.h5.copyWith(
                      color: AppColors.textWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Coupon List
          _buildCouponCard(
            'FIRST50',
            '50% OFF',
            'On first order',
            'Min order ₹500',
            AppColors.discountOrange,
          ),
          const SizedBox(height: 16),
          _buildCouponCard(
            'SAVE20',
            '20% OFF',
            'On groceries',
            'Min order ₹300',
            AppColors.discountGreen,
          ),
          const SizedBox(height: 16),
          _buildCouponCard(
            'FLAT100',
            '₹100 OFF',
            'On all orders',
            'Min order ₹1000',
            AppColors.primary,
          ),
          const SizedBox(height: 16),
          _buildCouponCard(
            'EMI0',
            'NO COST EMI',
            'On electronics',
            'Select banks only',
            AppColors.accent,
          ),
          const SizedBox(height: 16),
          _buildCouponCard(
            'FREEDEL',
            'FREE DELIVERY',
            'On orders above ₹200',
            'Valid for new users',
            AppColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard(
    String code,
    String title,
    String subtitle,
    String condition,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  title,
                  style: AppTextStyles.semiboldMedium.copyWith(
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        code,
                        style: AppTextStyles.semiboldMedium.copyWith(
                          color: color,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.copy, size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    condition,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
