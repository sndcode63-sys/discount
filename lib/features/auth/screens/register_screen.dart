import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/toast_utils.dart';
import '../bloc/auth_bloc.dart';

class ModernRegisterScreen extends StatefulWidget {
  final String initialRole;
  const ModernRegisterScreen({super.key, this.initialRole = 'customer'});

  @override
  State<ModernRegisterScreen> createState() => _ModernRegisterScreenState();
}

class _ModernRegisterScreenState extends State<ModernRegisterScreen> {
  late String _role;
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _referralCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _role = widget.initialRole;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _referralCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: AppColors.textPrimary,
        ),
        body: SafeArea(
          child: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthenticatedState) {
                ToastUtils.success('Account created successfully!');
                if (state.user.isMerchant) {
                  Get.offAllNamed(AppRoutes.merchantDashboard);
                } else {
                  Get.offAllNamed(AppRoutes.customerHome);
                }
              } else if (state is AuthErrorState) {
                ToastUtils.error(state.message);
              }
            },
            builder: (context, state) {
              final isLoading = state is AuthLoading;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Join Discount & Start Saving',
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),

                    const SizedBox(height: 24),

                    // Role Segmented Tabs (Customer | Merchant) - Matching Image 2 Screen 5
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _role = 'customer'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _role == 'customer' ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: _role == 'customer'
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.05),
                                            blurRadius: 6,
                                          )
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    'Customer',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: _role == 'customer'
                                          ? AppColors.primary
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _role = 'merchant'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: _role == 'merchant' ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: _role == 'merchant'
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.05),
                                            blurRadius: 6,
                                          )
                                        ]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    'Merchant',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: _role == 'merchant'
                                          ? AppColors.primary
                                          : Colors.grey[700],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Inputs matching Image 2 Screen 5
                    _buildInputField('Full Name', _nameCtrl, Icons.person_outline_rounded),
                    const SizedBox(height: 14),
                    _buildInputField('Mobile Number', _phoneCtrl, Icons.phone_android_rounded, isNumber: true),
                    const SizedBox(height: 14),
                    _buildInputField('Email Address', _emailCtrl, Icons.mail_outline_rounded),
                    const SizedBox(height: 14),
                    _buildInputField('Password', _passCtrl, Icons.lock_outline_rounded, isPassword: true),
                    const SizedBox(height: 14),
                    _buildInputField('Referral Code (Optional)', _referralCtrl, Icons.card_giftcard_rounded),

                    const SizedBox(height: 28),

                    // Big Red Register Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                final name = _nameCtrl.text.trim();
                                final phone = _phoneCtrl.text.trim();
                                final email = _emailCtrl.text.trim();
                                final pass = _passCtrl.text.trim();
                                if (name.isEmpty) {
                                  ToastUtils.error('Please enter your full name');
                                  return;
                                }
                                if (phone.isEmpty || phone.length < 10) {
                                  ToastUtils.error('Please enter a valid 10-digit mobile number');
                                  return;
                                }
                                if (email.isEmpty || !email.contains('@')) {
                                  ToastUtils.error('Please enter a valid email address');
                                  return;
                                }
                                if (pass.isEmpty || pass.length < 6) {
                                  ToastUtils.error('Password must be at least 6 characters');
                                  return;
                                }
                                context.read<AuthBloc>().add(
                                      RegisterUserEvent(
                                        name: name,
                                        phone: phone,
                                        email: email,
                                        password: pass,
                                        role: _role,
                                        referralCode: _referralCtrl.text.trim(),
                                      ),
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
                                'Register',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Already have an account? Login
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                          InkWell(
                            onTap: () => Get.back(),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
          obscureText: isPassword,
          style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
