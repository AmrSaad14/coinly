import 'package:flutter/material.dart';

/// App color palette extracted from the design
/// Main colors for Coinly app
class AppColors {
  // Primary Colors
  static const Color primaryTeal = Color(0xFF187259);
  static const Color darkTeal = Color(0xFF0F5343);
  static const Color lightTeal = Color(0xFF1F8771);
  static const Color secondaryTeal = Color(0xFF23A983);
  static const Color accentTeal = Color(0xFF56DCB6);
  static const Color brightTeal = Color(0xFF56DCB6);

  // Background Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightMint = Color(0xFFABEDDA);
  static const Color paleMint = Color(0xFFD4E9E5);
  static const Color cardBackground = Color(0xFFF5F5F5);
  static const Color scaffoldBackground = Color(0xFFFAFAFA);

  // Text Colors
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textMedium = Color(0xFF666666);
  static const Color textLight = Color(0xFF999999);
  static const Color textGray = Color(0xFF8A8A8A);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Accent Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryTeal, darkTeal],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [white, lightMint],
  );
}
