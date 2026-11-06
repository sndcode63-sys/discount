import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/toast_utils.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Fruits', 'icon': Icons.apple, 'selected': true},
    {'name': 'Vegetables', 'icon': Icons.eco, 'selected': true},
    {'name': 'Dairy', 'icon': Icons.egg, 'selected': false},
    {'name': 'Bakery', 'icon': Icons.bakery_dining, 'selected': false},
    {'name': 'Grains', 'icon': Icons.grain, 'selected': false},
    {'name': 'Snacks', 'icon': Icons.cookie, 'selected': false},
    {'name': 'Beverages', 'icon': Icons.local_drink, 'selected': false},
    {'name': 'Personal Care', 'icon': Icons.face, 'selected': false},
    {'name': 'Household', 'icon': Icons.cleaning_services, 'selected': false},
    {'name': 'Frozen', 'icon': Icons.ac_unit, 'selected': false},
  ];

  void _toggleCategory(int index) {
    setState(() {
      _categories[index]['selected'] = !_categories[index]['selected'];
    });
    final catName = _categories[index]['name'];
    final isSel = _categories[index]['selected'];
    ToastUtils.info(isSel ? '$catName selected' : '$catName unselected');
  }

  void _selectAll(bool select) {
    setState(() {
      for (var cat in _categories) {
        cat['selected'] = select;
      }
    });
    ToastUtils.info(select ? 'All categories selected' : 'Categories cleared');
  }

  void _proceedToLogin() {
    final selectedCount = _categories.where((c) => c['selected'] == true).length;
    if (selectedCount == 0) {
      ToastUtils.warning('Please select at least 1 category to personalize your experience');
      return;
    }
    ToastUtils.success('$selectedCount categories selected! Proceeding to Login...');
    Get.toNamed(AppRoutes.customerLogin);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Select Categories'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => _selectAll(true),
            child: const Text('Select All'),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'What do you like to shop for?',
                    style: AppTextStyles.h3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose your preferred categories to discover exclusive discounts and localized deals.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final bool isSelected = cat['selected'] as bool;

                  return GestureDetector(
                    onTap: () => _toggleCategory(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryLight.withOpacity(0.2)
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowLight,
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  cat['icon'] as IconData,
                                  size: 40,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  cat['name'] as String,
                                  style: AppTextStyles.semiboldMedium.copyWith(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Icon(
                              isSelected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textTertiary,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _proceedToLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue to Login',
                        style: AppTextStyles.button,
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
