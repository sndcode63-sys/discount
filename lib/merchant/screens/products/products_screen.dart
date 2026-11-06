import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MerchantProductsScreen extends StatelessWidget {
  const MerchantProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.toNamed(AppRoutes.merchantAddProduct);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildProductCard('Apple Red', 'Fruits', '₹120', '50', true),
          _buildProductCard('Banana', 'Fruits', '₹50', '100', true),
          _buildProductCard('Tomato', 'Vegetables', '₹40', '30', true),
          _buildProductCard('Potato', 'Vegetables', '₹30', '0', false),
          _buildProductCard('Milk', 'Dairy', '₹60', '25', true),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    String name,
    String category,
    String price,
    String stock,
    bool inStock,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.shopping_bag, color: AppColors.primary),
        ),
        title: Text(name, style: AppTextStyles.semiboldMedium),
        subtitle: Text('$category • Stock: $stock'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(price, style: AppTextStyles.semiboldMedium),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.edit, size: 20),
              onPressed: () {
                Get.toNamed(AppRoutes.merchantAddProduct);
              },
            ),
          ],
        ),
      ),
    );
  }
}
