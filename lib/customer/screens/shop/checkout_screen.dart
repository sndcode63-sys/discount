import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/toast_utils.dart';
import '../../controllers/cart_controller.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CartController cartController = Get.find<CartController>();
  final TextEditingController _couponController = TextEditingController();

  final List<String> _addresses = [
    'Home - Flat 302, Sector 15, Noida, UP - 201301',
    'Work - Tech Park, Sector 62, Noida, UP - 201309',
    'Parents Home - Sector 22, Gurgaon, HR - 122015',
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'title': 'UPI (Google Pay / PhonePe / Paytm)',
      'subtitle': 'Fast & Instant Payment',
      'icon': Icons.account_balance_wallet_outlined,
    },
    {
      'title': 'Credit / Debit Card',
      'subtitle': 'Visa, Mastercard, RuPay',
      'icon': Icons.credit_card,
    },
    {
      'title': 'Net Banking',
      'subtitle': 'All Indian Banks Supported',
      'icon': Icons.account_balance,
    },
    {
      'title': 'Cash on Delivery (COD)',
      'subtitle': 'Pay in cash or UPI at your doorstep',
      'icon': Icons.local_atm,
    },
  ];

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  void _showAddressPicker() {
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
            Text('Select Delivery Address', style: AppTextStyles.h4),
            const SizedBox(height: 16),
            ..._addresses.map(
              (addr) => ListTile(
                leading: const Icon(Icons.location_on, color: AppColors.primary),
                title: Text(addr, style: AppTextStyles.bodyMedium),
                trailing: Obx(() => Radio<String>(
                      value: addr,
                      groupValue: cartController.selectedAddress.value,
                      onChanged: (val) {
                        if (val != null) {
                          cartController.selectedAddress.value = val;
                          ToastUtils.success('Address updated');
                          Get.back();
                        }
                      },
                    )),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.back();
                  ToastUtils.info('Add new address feature');
                },
                icon: const Icon(Icons.add),
                label: const Text('+ Add New Address'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _placeOrder() {
    if (cartController.cartItems.isEmpty) {
      ToastUtils.error('Your cart is empty');
      return;
    }

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: AppColors.primary),
              const SizedBox(height: 20),
              Text('Processing Payment...', style: AppTextStyles.h4),
              const SizedBox(height: 8),
              Text(
                'Please do not close or refresh',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
      final orderId = 'DISC-${(10000 + (90000 * (DateTime.now().millisecond / 1000)).toInt())}';
      _showOrderSuccessModal(orderId);
    });
  }

  void _showOrderSuccessModal(String orderId) {
    ToastUtils.success('🎉 Order #$orderId Placed Successfully!');

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF2E7D32),
                  size: 64,
                ),
              ),
              const SizedBox(height: 16),
              Text('Order Placed!', style: AppTextStyles.h3),
              const SizedBox(height: 6),
              Text(
                'Order ID: #$orderId',
                style: AppTextStyles.semiboldMedium.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Estimated Delivery: 20-25 Mins',
                      style: AppTextStyles.semiboldSmall.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Your dummy order has been confirmed. The store is preparing your items!',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    cartController.clearCart();
                    Get.back();
                    Get.offAllNamed(AppRoutes.customerHome);
                  },
                  child: const Text('Continue Shopping'),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Checkout'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.shopping_bag_outlined, size: 80, color: AppColors.textTertiary),
                const SizedBox(height: 16),
                Text('Your basket is empty', style: AppTextStyles.h4),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Shop Products'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Address Section
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: AppColors.primary),
                                  const SizedBox(width: 8),
                                  Text('Delivery Address', style: AppTextStyles.semiboldMedium),
                                ],
                              ),
                              TextButton(
                                onPressed: _showAddressPicker,
                                child: const Text('Change'),
                              ),
                            ],
                          ),
                          const Divider(),
                          Text(
                            cartController.selectedAddress.value,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Order Items Summary
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Items (${cartController.cartItems.length})', style: AppTextStyles.semiboldMedium),
                          const SizedBox(height: 12),
                          ...cartController.cartItems.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${item.product.name} (${item.product.unit}) x${item.quantity}',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  ),
                                  Text(
                                    '₹${item.totalPrice.toStringAsFixed(0)}',
                                    style: AppTextStyles.semiboldSmall,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Coupon Code Section
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Apply Coupon', style: AppTextStyles.semiboldMedium),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _couponController,
                                  textCapitalization: TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    hintText: 'e.g. DISCOUNT50',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  if (_couponController.text.isNotEmpty) {
                                    cartController.applyCoupon(_couponController.text);
                                  } else {
                                    cartController.applyCoupon('DISCOUNT50');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                ),
                                child: const Text('Apply'),
                              ),
                            ],
                          ),
                          if (cartController.couponApplied.value) ...[
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Applied: ${cartController.couponCode.value}',
                                  style: AppTextStyles.semiboldSmall.copyWith(color: AppColors.success),
                                ),
                                GestureDetector(
                                  onTap: () => cartController.removeCoupon(),
                                  child: Text('Remove', style: AppTextStyles.caption.copyWith(color: AppColors.error)),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Payment Method Section
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Payment Method', style: AppTextStyles.semiboldMedium),
                          const SizedBox(height: 8),
                          ..._paymentMethods.map(
                            (pm) => RadioListTile<String>(
                              title: Text(pm['title'] as String, style: AppTextStyles.bodyMedium),
                              subtitle: Text(pm['subtitle'] as String, style: AppTextStyles.caption),
                              secondary: Icon(pm['icon'] as IconData, color: AppColors.primary),
                              value: pm['title'] as String,
                              groupValue: cartController.selectedPaymentMethod.value,
                              onChanged: (val) {
                                if (val != null) {
                                  cartController.selectedPaymentMethod.value = val;
                                  ToastUtils.info('Payment method: $val');
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Bill Details Summary
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bill Details', style: AppTextStyles.semiboldMedium),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Item Subtotal', style: AppTextStyles.bodyMedium),
                              Text('₹${cartController.subtotal.toStringAsFixed(0)}', style: AppTextStyles.bodyMedium),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Delivery Charge', style: AppTextStyles.bodyMedium),
                              Text(
                                cartController.deliveryFee == 0 ? 'FREE' : '₹${cartController.deliveryFee.toStringAsFixed(0)}',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: cartController.deliveryFee == 0 ? AppColors.success : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          if (cartController.couponApplied.value) ...[
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Discount Coupon', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success)),
                                Text('-₹${cartController.discountAmount.value.toStringAsFixed(0)}',
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success)),
                              ],
                            ),
                          ],
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('To Pay', style: AppTextStyles.semiboldLarge),
                              Text(
                                '₹${cartController.total.toStringAsFixed(0)}',
                                style: AppTextStyles.priceMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Bottom Place Order Bar
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _placeOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Place Order • ₹${cartController.total.toStringAsFixed(0)}',
                    style: AppTextStyles.button,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
