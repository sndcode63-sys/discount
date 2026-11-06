import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ShoppingListScreen extends StatelessWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Smart Shopping List'),
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
          _buildListItem('Apple Red', '1kg', true),
          _buildListItem('Milk', '2L', false),
          _buildListItem('Bread', '1 loaf', true),
          _buildListItem('Eggs', '12 pcs', false),
          _buildListItem('Tomato', '500g', true),
        ],
      ),
    );
  }

  Widget _buildListItem(String name, String quantity, bool checked) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(
          value: checked,
          onChanged: (value) {},
        ),
        title: Text(
          name,
          style: AppTextStyles.semiboldMedium.copyWith(
            decoration: checked ? TextDecoration.lineThrough : null,
            color: checked ? AppColors.textTertiary : null,
          ),
        ),
        trailing: Text(
          quantity,
          style: AppTextStyles.caption,
        ),
      ),
    );
  }
}
