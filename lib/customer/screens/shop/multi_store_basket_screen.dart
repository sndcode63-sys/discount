import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class MultiStoreBasketScreen extends StatelessWidget {
  const MultiStoreBasketScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Multi-Store Basket'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Store 1
                _buildStoreSection('FreshMart', [
                  _buildBasketItem('Apple Red', '1kg', 120, 1),
                  _buildBasketItem('Tomato', '1kg', 40, 2),
                ]),
                const SizedBox(height: 24),
                // Store 2
                _buildStoreSection('GroceryPlus', [
                  _buildBasketItem('Potato', '1kg', 30, 1),
                  _buildBasketItem('Rice', '5kg', 500, 1),
                ]),
              ],
            ),
          ),
          // Bottom Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      '₹810',
                      style: AppTextStyles.semiboldMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery',
                      style: AppTextStyles.bodyMedium,
                    ),
                    Text(
                      '₹40',
                      style: AppTextStyles.semiboldMedium,
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: AppTextStyles.semiboldLarge,
                    ),
                    Text(
                      '₹850',
                      style: AppTextStyles.priceMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Proceed to Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreSection(String storeName, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.store, color: AppColors.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              storeName,
              style: AppTextStyles.semiboldMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...items,
      ],
    );
  }

  Widget _buildBasketItem(String name, String unit, double price, int quantity) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.shopping_bag, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.semiboldMedium),
                  Text(unit, style: AppTextStyles.caption),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text('x$quantity', style: AppTextStyles.semiboldSmall),
                ),
                const SizedBox(width: 12),
                Text('₹${(price * quantity).toStringAsFixed(0)}',
                    style: AppTextStyles.semiboldMedium),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
