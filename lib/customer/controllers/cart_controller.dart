import 'package:get/get.dart';
import '../../shared/models/product.dart';
import '../../core/utils/toast_utils.dart';
// import '../../core/constants/sample_data.dart'; // Removed dummy data import

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => product.price * quantity;
}

class CartController extends GetxController {
  static CartController get instance => Get.find<CartController>();

  var cartItems = <CartItem>[].obs;
  var selectedAddress = 'Home - Sector 15, Noida, UP (201301)'.obs;
  var selectedPaymentMethod = 'UPI (Google Pay / PhonePe)'.obs;
  var couponApplied = false.obs;
  var couponCode = ''.obs;
  var discountAmount = 0.0.obs;




  void addToCart(Product product, {int qty = 1}) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      cartItems[index].quantity += qty;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(product: product, quantity: qty));
    }
    ToastUtils.success('${product.name} added to cart!');
  }

  void removeFromCart(Product product) {
    cartItems.removeWhere((item) => item.product.id == product.id);
    cartItems.refresh();
    ToastUtils.info('${product.name} removed from cart');
  }

  void updateQuantity(Product product, int delta) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      cartItems[index].quantity += delta;
      if (cartItems[index].quantity <= 0) {
        cartItems.removeAt(index);
        ToastUtils.info('${product.name} removed from cart');
      } else {
        ToastUtils.info('Updated ${product.name} quantity to ${cartItems[index].quantity}');
      }
      cartItems.refresh();
    }
  }

  double get subtotal => cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get deliveryFee => (subtotal > 500 || cartItems.isEmpty) ? 0.0 : 40.0;
  double get total => (subtotal + deliveryFee - discountAmount.value).clamp(0.0, double.infinity);

  void applyCoupon(String code) {
    String formattedCode = code.trim().toUpperCase();
    if (formattedCode == 'DISCOUNT50' || formattedCode == 'SAVE50' || formattedCode == 'FIRST50') {
      couponApplied.value = true;
      couponCode.value = formattedCode;
      discountAmount.value = 50.0;
      ToastUtils.success('🎉 Coupon $formattedCode applied! Saved ₹50');
    } else if (formattedCode.isNotEmpty) {
      couponApplied.value = true;
      couponCode.value = formattedCode;
      discountAmount.value = 30.0;
      ToastUtils.success('🎉 Coupon $formattedCode applied! Saved ₹30');
    } else {
      ToastUtils.error('Please enter a valid coupon code');
    }
  }

  void removeCoupon() {
    couponApplied.value = false;
    couponCode.value = '';
    discountAmount.value = 0.0;
    ToastUtils.info('Coupon removed');
  }

  void clearCart() {
    cartItems.clear();
    couponApplied.value = false;
    couponCode.value = '';
    discountAmount.value = 0.0;
  }
}


