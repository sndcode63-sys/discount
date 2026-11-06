import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/toast_utils.dart';
import '../bloc/auth_bloc.dart';
import 'register_screen.dart';

class ModernLoginScreen extends StatefulWidget {
  final String role; // 'customer' or 'merchant'
  const ModernLoginScreen({super.key, this.role = 'customer'});

  @override
  State<ModernLoginScreen> createState() => _ModernLoginScreenState();
}

class _ModernLoginScreenState extends State<ModernLoginScreen> {
  final _identifierCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isOtpMode = false;
  final _otpCtrl = TextEditingController();

  @override
  void dispose() {
    _identifierCtrl.dispose();
    _passwordCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthenticatedState) {
                ToastUtils.success('Welcome back, ${state.user.name}!');
                if (state.user.isMerchant) {
                  Get.offAllNamed(AppRoutes.merchantDashboard);
                } else {
                  Get.offAllNamed(AppRoutes.customerHome);
                }
              } else if (state is OtpSentState) {
                ToastUtils.info(state.message);
                setState(() => _isOtpMode = true);
              } else if (state is AuthErrorState) {
                ToastUtils.error(state.message);
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Logo (Discount Smart Savings Platform)
                    Image.asset(
                      'assets/images/app_logo.png',
                      height: 55,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.shopping_bag, size: 50, color: AppColors.primary),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Welcome Back!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Login to continue to ${widget.role == 'merchant' ? 'Merchant Portal' : 'Discount App'}',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 32),

                    // Identifier Field
                    TextField(
                      controller: _identifierCtrl,
                      keyboardType: TextInputType.text,
                      style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number / Email',
                        hintText: 'Enter mobile number or email',
                        prefixIcon: const Icon(Icons.person_outline_rounded, color: AppColors.primary),
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (!_isOtpMode) ...[
                      // Password Field
                      TextField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        style: const TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.w500),
                        cursorColor: AppColors.primary,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded, color: AppColors.primary),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            context.read<AuthBloc>().add(SendOtpEvent(_identifierCtrl.text.trim()));
                          },
                          child: const Text('Login with OTP instead'),
                        ),
                      ),
                    ] else ...[
                      // OTP Field
                      TextField(
                        controller: _otpCtrl,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 4),
                        cursorColor: AppColors.primary,
                        decoration: InputDecoration(
                          labelText: '6-Digit OTP',
                          hintText: 'Enter received OTP',
                          prefixIcon: const Icon(Icons.pin_outlined, color: AppColors.primary),
                          filled: true,
                          fillColor: AppColors.surface,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                    ],

                    const SizedBox(height: 16),

                    // Red Primary Login Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                final id = _identifierCtrl.text.trim();
                                if (id.isEmpty) {
                                  ToastUtils.error('Please enter mobile number or email');
                                  return;
                                }
                                if (_isOtpMode) {
                                  final otp = _otpCtrl.text.trim();
                                  if (otp.isEmpty || otp.length < 4) {
                                    ToastUtils.error('Please enter a valid OTP');
                                    return;
                                  }
                                  context.read<AuthBloc>().add(
                                        VerifyOtpEvent(
                                          phone: id,
                                          otp: otp,
                                        ),
                                      );
                                } else {
                                  final pwd = _passwordCtrl.text.trim();
                                  if (pwd.isEmpty) {
                                    ToastUtils.error('Please enter your password');
                                    return;
                                  }
                                  context.read<AuthBloc>().add(
                                        LoginWithPasswordEvent(
                                          identifier: id,
                                          password: pwd,
                                        ),
                                      );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                _isOtpMode ? 'Verify & Login' : 'Login',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // "or continue with" (Image 2)
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            'or continue with',
                            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Google & Apple Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ToastUtils.info('Google Sign-in connected');
                            },
                            icon: const Icon(Icons.g_mobiledata, size: 28, color: Colors.red),
                            label: const Text('Google', style: TextStyle(color: Colors.black87)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              ToastUtils.info('Apple Sign-in connected');
                            },
                            icon: const Icon(Icons.apple, size: 22, color: Colors.black87),
                            label: const Text('Apple', style: TextStyle(color: Colors.black87)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Live Test Credentials Quick Fill
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Live Test Accounts (Tap to Fill)',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            alignment: WrapAlignment.center,
                            children: [
                              ActionChip(
                                label: const Text('Customer (Pooja: 9811122233)', style: TextStyle(fontSize: 11)),
                                onPressed: () {
                                  setState(() {
                                    _isOtpMode = false;
                                    _identifierCtrl.text = '9811122233';
                                    _passwordCtrl.text = 'CustomerPass@123';
                                  });
                                },
                              ),
                              ActionChip(
                                label: const Text('Merchant (Ramesh: 9820000001)', style: TextStyle(fontSize: 11)),
                                onPressed: () {
                                  setState(() {
                                    _isOtpMode = false;
                                    _identifierCtrl.text = '9820000001';
                                    _passwordCtrl.text = 'MerchantPassword@123';
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Register Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                        InkWell(
                          onTap: () {
                            Get.to(() => ModernRegisterScreen(initialRole: widget.role));
                          },
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
