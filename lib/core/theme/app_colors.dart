import 'package:flutter/material.dart';

class AppColors {
  // Brand Red Palette (matching UI design screenshots)
  static const Color primary = Color(0xFFE53935);
  static const Color primaryDark = Color(0xFFC62828);
  static const Color primaryDeep = Color(0xFFB71C1C);
  static const Color primaryLight = Color(0xFFFFEBEE);
  static const Color primaryAccent = Color(0xFFFF5252);

  // Merchant Amber/Orange & Secondary
  static const Color merchantOrange = Color(0xFFE65100);
  static const Color merchantOrangeLight = Color(0xFFFFF3E0);
  static const Color secondary = Color(0xFFE65100);
  static const Color secondaryLight = Color(0xFFFFF3E0);
  static const Color cardBackground = Colors.white;
  static const Color shadow = Color(0x14000000);

  // Backward-compatible color aliases
  static const Color discountRed = primary;
  static const Color discountOrange = Color(0xFFFF9800);
  static const Color discountGreen = success;
  static const Color accent = Color(0xFFFF5252);

  // Functional Status Colors
  static const Color success = Color(0xFF2E7D32);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFFA000);
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF1976D2);
  static const Color infoLight = Color(0xFFE3F2FD);

  // Background & Surfaces
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFF1F3F5);
  static const Color surfaceLight = Color(0xFFFAFAFA);
  static const Color card = Colors.white;
  static const Color white = Colors.white;

  // Text Colors
  static const Color textPrimary = Color(0xFF1E2022);
  static const Color textSecondary = Color(0xFF616161);
  static const Color textTertiary = Color(0xFF9E9E9E);
  static const Color textWhite = Colors.white;

  // Borders & Dividers
  static const Color border = Color(0xFFEEEEEE);
  static const Color borderDark = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFF0F0F0);

  // Shadows
  static Color shadowLight = Colors.black.withValues(alpha: 0.05);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.09);
  static Color shadowRed = primary.withValues(alpha: 0.25);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroRedGradient = LinearGradient(
    colors: [Color(0xFFE53935), Color(0xFFC62828)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient merchantGradient = LinearGradient(
    colors: [Color(0xFFE65100), Color(0xFFBF360C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFFFB300), Color(0xFFFFA000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
