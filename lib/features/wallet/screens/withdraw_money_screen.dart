import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/toast_utils.dart';
import '../bloc/wallet_bloc.dart';

class WithdrawMoneyScreen extends StatefulWidget {
  final double currentBalance;
  final WalletBloc walletBloc;

  const WithdrawMoneyScreen({
    super.key,
    required this.currentBalance,
    required this.walletBloc,
  });

  @override
  State<WithdrawMoneyScreen> createState() => _WithdrawMoneyScreenState();
}

class _WithdrawMoneyScreenState extends State<WithdrawMoneyScreen> {
  String _selectedProvider = 'Google Pay';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _upiController = TextEditingController();

  final List<Map<String, dynamic>> _providers = [
    {'name': 'Google Pay', 'icon': Icons.account_balance_wallet_rounded, 'color': Color(0xFF4285F4)},
    {'name': 'PhonePe', 'icon': Icons.payment_rounded, 'color': Color(0xFF5F259F)},
    {'name': 'Paytm', 'icon': Icons.wallet_rounded, 'color': Color(0xFF00B9F5)},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _upiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.walletBloc,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Withdraw Money',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 0.5,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Available Balance Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Available for Withdrawal:',
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
                    ),
                    Text(
                      '₹${widget.currentBalance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Select Bank / UPI
              const Text(
                'Select Bank / UPI',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Row(
                children: _providers.map((p) {
                  final isSelected = _selectedProvider == p['name'];
                  final color = p['color'] as Color;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedProvider = p['name'] as String);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primaryLight : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.border,
                            width: isSelected ? 1.8 : 1.0,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(p['icon'] as IconData, color: color, size: 28),
                            const SizedBox(height: 6),
                            Text(
                              p['name'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                color: isSelected ? AppColors.primary : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // UPI ID input
              const Text(
                'Enter UPI ID',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _upiController,
                decoration: InputDecoration(
                  hintText: 'e.g. yourname@okhdfcbank',
                  prefixIcon: const Icon(Icons.alternate_email_rounded, color: AppColors.primary),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Enter Amount
              const Text(
                'Enter Amount (Min ₹50)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  prefixStyle: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.border),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Quick amount presets
              Row(
                children: [50, 100, 200, 500].map((amt) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text('₹$amt'),
                      backgroundColor: Colors.white,
                      onPressed: () {
                        setState(() => _amountController.text = amt.toString());
                      },
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 36),

              // Request Withdrawal Button
              BlocConsumer<WalletBloc, WalletState>(
                listener: (context, state) {
                  if (state is WalletLoadedState && state.withdrawalSuccessRef != null) {
                    ToastUtils.success(
                      'Withdrawal Successful! Reference ID: ${state.withdrawalSuccessRef}',
                    );
                    Get.back();
                  }
                },
                builder: (context, state) {
                  final isLoading =
                      state is WalletLoadedState && state.isWithdrawing;

                  return SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              final amt = double.tryParse(_amountController.text.trim()) ?? 0.0;
                              final upi = _upiController.text.trim();

                              if (amt < 50) {
                                ToastUtils.error('Minimum withdrawal amount is ₹50');
                                return;
                              }
                              if (amt > widget.currentBalance) {
                                ToastUtils.error('Amount exceeds your current balance');
                                return;
                              }
                              if (upi.isEmpty) {
                                ToastUtils.error('Please enter a valid UPI ID');
                                return;
                              }

                              widget.walletBloc.add(
                                RequestWithdrawalEvent(amount: amt, upiId: upi),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Request Withdrawal',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
