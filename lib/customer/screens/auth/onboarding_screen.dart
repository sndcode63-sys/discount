import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class CustomerOnboardingScreen extends StatelessWidget {
  const CustomerOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Icon(
                    Icons.local_offer,
                    size: 120,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              // Title
              Text(
                'Save More Every Day',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                'Find the best deals and discounts from nearby stores. Compare prices and save money on your daily shopping.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              // Get Started Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.customerLogin);
                  },
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 16),
              // Skip Button
              TextButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.customerHome);
                },
                child: Text(
                  'Skip for now',
                  style: AppTextStyles.semiboldMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
