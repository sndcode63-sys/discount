import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/toast_utils.dart';
import '../bloc/shopping_list_bloc.dart';

class SmartShoppingListScreen extends StatefulWidget {
  const SmartShoppingListScreen({super.key});

  @override
  State<SmartShoppingListScreen> createState() => _SmartShoppingListScreenState();
}

class _SmartShoppingListScreenState extends State<SmartShoppingListScreen> {
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void _showAddItemDialog(BuildContext context, ShoppingListBloc bloc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Grocery Item', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _itemController,
              decoration: const InputDecoration(
                hintText: 'Item Name (e.g. Atta 5kg, Oil 1L)',
                labelText: 'Item Name',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'Estimated Price (₹)',
                labelText: 'Estimated Price',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _itemController.text.trim();
              final price = double.tryParse(_priceController.text.trim()) ?? 50.0;
              if (name.isNotEmpty) {
                bloc.add(AddShoppingItemEvent(name, price));
                _itemController.clear();
                _priceController.clear();
                Navigator.pop(ctx);
                ToastUtils.success('Added "$name" to shopping list');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Add Item', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ShoppingListBloc()..add(LoadShoppingListEvent()),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Smart 3-Store Shopping List',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0.5,
          actions: [
            Builder(
              builder: (ctx) => IconButton(
                icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                tooltip: 'Add Item',
                onPressed: () => _showAddItemDialog(ctx, ctx.read<ShoppingListBloc>()),
              ),
            ),
          ],
        ),
        body: BlocBuilder<ShoppingListBloc, ShoppingListState>(
          builder: (context, state) {
            if (state is! ShoppingListLoadedState) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            final items = state.items;
            final comp = state.comparison;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF7E57C2),
                          const Color(0xFF5E35B1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7E57C2).withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.checklist_rounded, color: Colors.white, size: 24),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Multi-Store Comparison',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Compare full basket across Top 3 nearest stores in 1-tap',
                                style: TextStyle(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Shopping Items Checklist Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        if (items.isEmpty)
                          Container(
                            padding: const EdgeInsets.all(28),
                            child: const Center(
                              child: Column(
                                children: [
                                  Icon(Icons.add_shopping_cart_rounded, size: 42, color: AppColors.textTertiary),
                                  SizedBox(height: 10),
                                  Text(
                                    'Your shopping list is empty',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Type an item above and tap + to add',
                                    style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return CheckboxListTile(
                              value: item.isChecked,
                              activeColor: AppColors.primary,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      item.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        decoration: item.isChecked ? null : TextDecoration.lineThrough,
                                        color: item.isChecked ? AppColors.textPrimary : Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    '₹${(item.estimatedPrice * item.quantity).toStringAsFixed(0)}',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              secondary: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Icon(Icons.shopping_basket_outlined, size: 18),
                                ),
                              ),
                              subtitle: Text('Qty: ${item.quantity}'),
                              onChanged: (val) {
                                context.read<ShoppingListBloc>().add(ToggleItemCheckedEvent(index));
                              },
                            );
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Estimated Bill (${items.where((i) => i.isChecked).length} items)',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '₹${state.totalBasketAmount.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Compare Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: state.isComparing
                          ? null
                          : () {
                              context.read<ShoppingListBloc>().add(
                                    const CompareBasketAcross3StoresEvent(),
                                  );
                            },
                      icon: state.isComparing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.compare_arrows_rounded, color: Colors.white),
                      label: Text(
                        state.isComparing
                            ? 'Evaluating across 3 nearest stores...'
                            : 'Compare Prices Across 3 Stores',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),

                  // 3-Store Comparison Result Cards
                  if (comp != null) ...[
                    const SizedBox(height: 24),
                    const Text(
                      '3-Store Best Deal Results',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    // Savings Report Banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.successLight,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle_rounded, color: AppColors.success),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              comp.savingsReport,
                              style: const TextStyle(
                                color: AppColors.success,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Top 3 Stores Cards
                    ...comp.topStores.map((rank) {
                      final isRank1 = rank.rank == 1;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isRank1 ? AppColors.primary : AppColors.border,
                            width: isRank1 ? 1.8 : 1.0,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: isRank1 ? AppColors.primary : Colors.grey[300],
                                  child: Text(
                                    '#${rank.rank}',
                                    style: TextStyle(
                                      color: isRank1 ? Colors.white : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        rank.storeName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        'Items Available: ${rank.itemsAvailableRatio}',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: isRank1 ? AppColors.primaryLight : AppColors.surface,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    rank.badge,
                                    style: TextStyle(
                                      color: isRank1 ? AppColors.primary : Colors.grey[700],
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Store Bill: ₹${rank.totalAmount.toStringAsFixed(0)}',
                                        style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                                    Text(
                                      'Cashback: -₹${rank.cashback.toStringAsFixed(1)} (5%)',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.success,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text('Final Cost',
                                        style: TextStyle(fontSize: 11, color: Colors.grey)),
                                    Text(
                                      '₹${rank.finalEffectiveCost.toStringAsFixed(1)}',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                        color: isRank1 ? AppColors.primary : AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            if (isRank1) ...[
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                  onPressed: () {
                                    context.read<ShoppingListBloc>().add(
                                          ReserveBasketEvent(
                                            storeId: rank.storeId,
                                            amount: rank.totalAmount,
                                            cashback: rank.cashback,
                                          ),
                                        );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: AppColors.primary),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    state.reservationCode != null
                                        ? 'Hold Confirmed: ${state.reservationCode}'
                                        : 'Reserve Basket at Counter (1-Click)',
                                    style: const TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),
                  ],

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
