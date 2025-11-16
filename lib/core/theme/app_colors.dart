import 'package:flutter/material.dart';

/// App color palette extracted from the design
/// Complete color system for Coinly app following design guidelines
class AppColors {
  // ============================================================================
  // PRIMARY COLORS
  // Brand color - enhances user engagement by making interactive elements
  // stand out. Used for primary buttons, icons, and hyperlinks.
  // ============================================================================
  static const Color primary100 = Color(0xFFD7FBF3);
  static const Color primary200 = Color(0xFFABEDDA);
  static const Color primary300 = Color(0xFF81E4D8);
  static const Color primary400 = Color(0xFF56D6D6);
  static const Color primary500 = Color(0xFF187259); // Main brand color
  static const Color primary600 = Color(0xFF23A983);
  static const Color primary700 = Color(0xFF187562);
  static const Color primary800 = Color(0xFF125441);
  static const Color primary900 = Color(0xFF092621);

  // Legacy aliases for backward compatibility
  static const Color primaryTeal = primary500;
  static const Color darkTeal = primary800;
  static const Color lightTeal = primary600;
  static const Color secondaryTeal = primary600;
  static const Color accentTeal = primary400;
  static const Color brightTeal = primary400;

  // ============================================================================
  // NEUTRAL COLORS
  // Applied to text, form fields, dividers, borders, and backgrounds.
  // Creates a cohesive and aesthetic interface for readability.
  // ============================================================================
  static const Color neutral100 = Color(0xFFFFFFFF);
  static const Color neutral200 = Color(0xFFCCCCCC);
  static const Color neutral300 = Color(0xFFCCCCCC);
  static const Color neutral400 = Color(0xFFB3B383);
  static const Color neutral500 = Color(0xFF999999);
  static const Color neutral600 = Color(0xFF666666);
  static const Color neutral700 = Color(0xFF4D4D4D);
  static const Color neutral800 = Color(0xFF333333);
  static const Color neutral900 = Color(0xFF1A1A1A);

  // Legacy aliases for backward compatibility
  static const Color white = neutral100;
  static const Color textDark = neutral900;
  static const Color textMedium = neutral600;
  static const Color textLight = neutral500;
  static const Color textGray = Color(0xFF8A8A8A);
  static const Color textWhite = neutral100;

  // ============================================================================
  // ERROR COLORS
  // Highlight form errors, drawing attention for prompt correction.
  // Enhances usability with immediate and clear feedback.
  // ============================================================================
  static const Color error100 = Color(0xFFFFCCCB);
  static const Color error200 = Color(0xFFFF9999);
  static const Color error300 = Color(0xFFFF6464);
  static const Color error400 = Color(0xFFFF3333);
  static const Color error500 = Color(0xFFFF4B4B); // Main error color
  static const Color error600 = Color(0xFFCC0000);
  static const Color error700 = Color(0xFF990000);
  static const Color error800 = Color(0xFF660000);
  static const Color error900 = Color(0xFF330000);

  // Legacy alias for backward compatibility
  static const Color error = error500;

  // ============================================================================
  // WARNING COLORS
  // Signal caution in actions or flag potential issues, guiding users
  // with visual cues. Supports safer decision-making and user awareness.
  // ============================================================================
  static const Color warning100 = Color(0xFFFFF2CC);
  static const Color warning200 = Color(0xFFFFE699);
  static const Color warning300 = Color(0xFFFFDB66);
  static const Color warning400 = Color(0xFFFFC233);
  static const Color warning500 = Color(0xFFFFC107); // Main warning color
  static const Color warning600 = Color(0xFFCC9900);
  static const Color warning700 = Color(0xFF997300);
  static const Color warning800 = Color(0xFF664D00);
  static const Color warning900 = Color(0xFF332600);

  // Legacy alias for backward compatibility
  static const Color warning = warning500;

  // ============================================================================
  // SUCCESS COLORS
  // Denote completion, approval, or positive outcomes, visually reinforcing
  // user actions with satisfying feedback. Signals achievement and progress.
  // ============================================================================
  static const Color success100 = Color(0xFFD9F9DC);
  static const Color success200 = Color(0xFFB3E9B9);
  static const Color success300 = Color(0xFF8CD08F);
  static const Color success400 = Color(0xFF71C175);
  static const Color success500 = Color(0xFF4CAF4F); // Main success color
  static const Color success600 = Color(0xFF3E8E40);
  static const Color success700 = Color(0xFF2E6830);
  static const Color success800 = Color(0xFF1F4720);
  static const Color success900 = Color(0xFF0F2410);

  // Legacy alias for backward compatibility
  static const Color success = success500;

  // ============================================================================
  // ADDITIONAL COLORS
  // ============================================================================

  // Background Colors
  static const Color lightMint = Color(0xFFABEDDA);
  static const Color paleMint = Color(0xFFD4E9E5);
  static const Color cardBackground = Color(0xFFF5F5F5);
  static const Color scaffoldBackground = Color(0xFFFAFAFA);

  // Info Color
  static const Color info = Color(0xFF2196F3);

  // Shadow Colors
  static const Color shadowLight = Color(0x1A000000);
  static const Color shadowMedium = Color(0x33000000);

  // ============================================================================
  // GRADIENT COLORS
  // ============================================================================

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primary500, primary800],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [neutral100, lightMint],
  );
}
