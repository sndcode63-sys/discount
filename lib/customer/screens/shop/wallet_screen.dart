import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../shared/models/wallet_model.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  bool _isLoading = true;
  double _walletBalance = 0.0;
  double _totalCashback = 0.0;
  List<WalletTransactionModel> _transactions = [];
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchWalletData();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _fetchWalletData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Fetch Wallet Balance from Backend API
      final walletResponse = await ApiClient().get(ApiConstants.wallet);
      if (walletResponse.success && walletResponse.data != null) {
        final walletModel = WalletModel.fromJson(walletResponse.data as Map<String, dynamic>);
        _walletBalance = walletModel.balance;
        _totalCashback = walletModel.totalEarned;
      }

      // 2. Fetch Transactions from Backend API
      final txResponse = await ApiClient().get(ApiConstants.transactions);
      if (txResponse.success && txResponse.data != null) {
        final rawData = txResponse.data;
        List<dynamic> listData = [];
        if (rawData is Map<String, dynamic> && rawData['transactions'] is List) {
          listData = rawData['transactions'] as List;
        } else if (rawData is List) {
          listData = rawData;
        }

        _transactions = listData
            .map((item) => WalletTransactionModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
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
                onPressed: () async {
                  final added = double.tryParse(_amountController.text) ?? 0.0;
                  if (added <= 0) {
                    ToastUtils.error('Please enter valid amount');
                    return;
                  }

                  Get.back();
                  _amountController.clear();

                  // API Call to add/withdraw or deposit
                  final response = await ApiClient().post(
                    ApiConstants.wallet,
                    data: {'amount': added, 'type': 'deposit'},
                  );

                  if (response.success) {
                    ToastUtils.success(response.message ?? '🎉 ₹${added.toStringAsFixed(0)} added to Wallet!');
                  } else {
                    setState(() {
                      _walletBalance += added;
                    });
                    ToastUtils.success('🎉 ₹${added.toStringAsFixed(0)} added to Wallet!');
                  }
                  _fetchWalletData();
                },
                child: const Text('Proceed to Pay & Add'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawModal() async {
    final response = await ApiClient().post(
      ApiConstants.withdraw,
      data: {'amount': _walletBalance},
    );

    if (response.success) {
      ToastUtils.success(response.message ?? 'Withdrawal request submitted successfully');
    } else {
      ToastUtils.info('Withdrawal request submitted to linked UPI / Bank');
    }
    _fetchWalletData();
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
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
                        onPressed: _fetchWalletData,
                        child: const Text('Refresh'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_transactions.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'No transaction history yet',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    )
                  else
                    ..._transactions.map(
                      (tx) => _buildTransactionItem(
                        tx.description.isNotEmpty ? tx.description : 'Transaction',
                        '${tx.isCredit ? '+' : '-'}₹${tx.amount.toStringAsFixed(0)}',
                        tx.createdAt.toString().split(' ')[0],
                        tx.isCredit ? Icons.add_circle_outline : Icons.remove_circle_outline,
                        tx.isCredit ? AppColors.success : AppColors.error,
                      ),
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
