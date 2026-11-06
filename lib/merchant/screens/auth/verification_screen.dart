import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MerchantVerificationScreen extends StatelessWidget {
  const MerchantVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // Icon
              Icon(
                Icons.verified_user,
                size: 100,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              // Title
              Text(
                'Business Verification',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Subtitle
              Text(
                'Upload your business documents to verify your shop',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Upload Sections
              _buildUploadSection(
                'Shop License',
                'Upload shop license document',
                Icons.description,
              ),
              const SizedBox(height: 16),
              _buildUploadSection(
                'GST Certificate',
                'Upload GST certificate',
                Icons.receipt,
              ),
              const SizedBox(height: 16),
              _buildUploadSection(
                'ID Proof',
                'Upload owner ID proof',
                Icons.badge,
              ),
              const SizedBox(height: 24),
              // Submit Button
              ElevatedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.merchantDashboard);
                },
                child: const Text('Submit for Verification'),
              ),
              const SizedBox(height: 16),
              // Skip Button
              OutlinedButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.merchantDashboard);
                },
                child: const Text('Skip for now'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection(String title, String subtitle, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: AppColors.primary),
          const SizedBox(height: 12),
          Text(
            title,
            style: AppTextStyles.semiboldMedium,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload'),
          ),
        ],
      ),
    );
  }
}
