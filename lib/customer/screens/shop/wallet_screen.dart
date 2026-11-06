import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/toast_utils.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double _walletBalance = 1250.0;
  final double _totalCashback = 750.0;
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _showAddMoneyModal() {
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
            Text('Add Money to Wallet', style: AppTextStyles.h4),
            const SizedBox(height: 16),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                labelText: 'Amount (₹)',
                hintText: 'Enter amount e.g. 500',
                prefixText: '₹ ',
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              children: [100, 200, 500, 1000, 2000].map((amt) {
                return ActionChip(
                  label: Text('+ ₹$amt'),
                  onPressed: () {
                    _amountController.text = amt.toString();
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  final added = double.tryParse(_amountController.text) ?? 500.0;
                  setState(() {
                    _walletBalance += added;
                  });
                  _amountController.clear();
                  Get.back();
                  ToastUtils.success('🎉 ₹${added.toStringAsFixed(0)} added to Wallet successfully!');
                },
                child: const Text('Proceed to Pay & Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawModal() {
    ToastUtils.info('Withdraw request submitted to linked UPI / Bank');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Wallet & Cashback'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Wallet Balance Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Discount Wallet Balance',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textWhite.withOpacity(0.9),
                        ),
                      ),
                      const Icon(Icons.account_balance_wallet, color: Colors.white),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '₹${_walletBalance.toStringAsFixed(0)}',
                    style: AppTextStyles.h1.copyWith(
                      color: AppColors.textWhite,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _showAddMoneyModal,
                          icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 18),
                          label: const Text('Add Money', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.vertical(12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _showWithdrawModal,
                          icon: const Icon(Icons.arrow_upward, color: Colors.white, size: 18),
                          label: const Text('Transfer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white, width: 1.5),
                            padding: const EdgeInsets.vertical(12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Total Cashback Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFA5D6A7)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFF2E7D32),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.stars, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total Cashback Earned', style: AppTextStyles.bodyMedium),
                        const SizedBox(height: 2),
                        Text(
                          '₹${_totalCashback.toStringAsFixed(0)}',
                          style: AppTextStyles.h4.copyWith(
                            color: const Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ToastUtils.info('Cashback credited directly on bills');
                    },
                    child: const Text('Details'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recent Transactions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recent Transactions', style: AppTextStyles.h4),
                TextButton(
                  onPressed: () {
                    ToastUtils.info('Viewing full history');
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTransactionItem(
              'Cashback Credited - FreshMart',
              '+₹50',
              'Today, 2:30 PM',
              Icons.add_circle_outline,
              AppColors.success,
            ),
            _buildTransactionItem(
              'Order Payment #DISC-8912',
              '-₹200',
              'Yesterday, 5:45 PM',
              Icons.remove_circle_outline,
              AppColors.error,
            ),
            _buildTransactionItem(
              'Money Added via UPI',
              '+₹500',
              'Oct 20, 10:00 AM',
              Icons.add_circle_outline,
              AppColors.success,
            ),
            _buildTransactionItem(
              'Festival Special Cashback',
              '+₹25',
              'Oct 18, 3:15 PM',
              Icons.add_circle_outline,
              AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(
    String title,
    String amount,
    String date,
    IconData icon,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: AppTextStyles.semiboldMedium),
        subtitle: Text(date, style: AppTextStyles.caption),
        trailing: Text(
          amount,
          style: AppTextStyles.semiboldMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
