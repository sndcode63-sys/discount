import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/toast_utils.dart';
import '../../../shared/models/bill_model.dart';

class CounterBillingScreen extends StatefulWidget {
  const CounterBillingScreen({super.key});

  @override
  State<CounterBillingScreen> createState() => _CounterBillingScreenState();
}

class _CounterBillingScreenState extends State<CounterBillingScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final List<Map<String, dynamic>> _billingItems = [];
  String _paymentMethod = 'upi';
  BillModel? _generatedBill;

  double get _subTotal => _billingItems.fold(
      0.0, (sum, item) => sum + ((item['price'] as double) * (item['qty'] as int)));

  double get _customerCashback => _subTotal * 0.05;
  double get _merchantNet => _subTotal - _customerCashback;

  void _addItemDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Billing Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Product Name (e.g. Milk, Rice)'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price (₹)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final name = nameCtrl.text.trim();
              final price = double.tryParse(priceCtrl.text.trim()) ?? 0.0;
              if (name.isNotEmpty && price > 0) {
                setState(() {
                  _billingItems.add({'name': name, 'price': price, 'qty': 1});
                });
                Navigator.pop(ctx);
              } else {
                ToastUtils.error('Please enter valid item name and price');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _generateBill() {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ToastUtils.error('Please enter a valid 10-digit customer mobile number');
      return;
    }
    if (_billingItems.isEmpty) {
      ToastUtils.error('Please add at least 1 item to generate counter bill');
      return;
    }

    setState(() {
      _generatedBill = BillModel(
        billNumber: 'BILL-${DateTime.now().millisecondsSinceEpoch % 1000000}',
        storeName: 'Merchant Counter',
        totalAmount: _subTotal,
        customerCashback: _customerCashback,
        merchantNetReceived: _merchantNet,
        paymentStatus: 'paid',
        paymentMethod: _paymentMethod,
        createdAt: DateTime.now(),
      );
    });
    ToastUtils.success('Bill generated! 5% Instant Cashback (₹${_customerCashback.toStringAsFixed(1)}) credited to customer!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Counter Billing',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Customer Mobile Input
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Mobile Number',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixText: '+91 ',
                      prefixIcon: const Icon(Icons.phone_android_rounded, color: AppColors.primary),
                      hintText: 'Enter 10-digit mobile number',
                      filled: true,
                      fillColor: AppColors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Customer will automatically receive 5% instant wallet cashback on this number.',
                    style: TextStyle(fontSize: 11, color: AppColors.success, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Billing Items (Matching Image 2 Row 3 Screen 5)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Billing Items',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      TextButton.icon(
                        onPressed: _addItemDialog,
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text('Add Item'),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  if (_billingItems.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      alignment: Alignment.center,
                      child: const Column(
                        children: [
                          Icon(Icons.shopping_bag_outlined, color: AppColors.textTertiary, size: 36),
                          SizedBox(height: 6),
                          Text('No items in bill yet', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          SizedBox(height: 2),
                          Text('Tap Add Item to enter products or scan barcode', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    )
                  else
                    ..._billingItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(Icons.shopping_bag_outlined, color: AppColors.primary, size: 18),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              item['name'],
                              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                            ),
                          ),
                          Text('Qty: ${item['qty']}'),
                          const SizedBox(width: 14),
                          Text(
                            '₹${(item['price'] as double).toInt()}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  }),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Bill Amount', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                        '₹${_subTotal.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Customer Cashback (5%)', style: TextStyle(color: AppColors.success, fontWeight: FontWeight.bold)),
                      Text(
                        '- ₹${_customerCashback.toStringAsFixed(1)}',
                        style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Generate Bill Button (Matching Image 2 Row 3 Screen 5)
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _generateBill,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'Generate Bill',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            if (_generatedBill != null) ...[
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.success, width: 1.5),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 40),
                    const SizedBox(height: 8),
                    const Text(
                      'Bill Generated Successfully',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Invoice #${_generatedBill!.billNumber}',
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      width: 140,
                      height: 140,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.qr_code_2_rounded, size: 120),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Ask customer to scan to claim 5% instant cashback',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
