import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/toast_utils.dart';

class CustomerLocationScreen extends StatefulWidget {
  const CustomerLocationScreen({super.key});

  @override
  State<CustomerLocationScreen> createState() => _CustomerLocationScreenState();
}

class _CustomerLocationScreenState extends State<CustomerLocationScreen> {
  final List<String> _popularCities = [
    'Noida / Greater Noida',
    'Delhi NCR',
    'Gurgaon',
    'Mumbai',
    'Bengaluru',
    'Hyderabad',
    'Ahmedabad',
    'Jaipur',
  ];

  void _showManualCityPicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Your City Manually', style: AppTextStyles.h4),
            const SizedBox(height: 14),
            ..._popularCities.map(
              (city) => ListTile(
                leading: const Icon(Icons.location_city, color: AppColors.primary),
                title: Text(city, style: AppTextStyles.bodyMedium),
                onTap: () {
                  Get.back();
                  ToastUtils.success('Location set to $city');
                  Get.offAllNamed(AppRoutes.customerHome);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Location Access'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.primaryDark],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.my_location,
                        size: 42,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Find Deals Near You',
                style: AppTextStyles.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Allow location permission to discover nearby grocery stores, live cashback, and hyper-local discounts.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              // Allow Button
              SizedBox(
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ToastUtils.success('📍 Location set to Sector 15, Noida');
                    Get.offAllNamed(AppRoutes.customerHome);
                  },
                  icon: const Icon(Icons.near_me),
                  label: const Text('Allow Location Access', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Select Manually
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _showManualCityPicker,
                  icon: const Icon(Icons.search),
                  label: const Text('Select Location Manually'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  ToastUtils.info('Continuing with default location');
                  Get.offAllNamed(AppRoutes.customerHome);
                },
                child: Text(
                  'Skip for now',
                  style: AppTextStyles.semiboldMedium.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
