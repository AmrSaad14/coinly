import 'package:flutter/material.dart';
import '../layout/main_layout.dart';
import '../../features/onboarding/ui/screens/onboarding_screen.dart';
import '../../features/auth/phone_auth_screen.dart';
import '../../features/auth/otp_verification_screen.dart';
import '../../features/auth/complete_registration_screen.dart';
import '../../features/kiosk/create_kiosk_screen.dart';

class AppRouter {
  // Route names
  static const String onboarding = '/';
  static const String phoneAuth = '/phone-auth';
  static const String otpVerification = '/otp-verification';
  static const String completeRegistration = '/complete-registration';
  static const String createKiosk = '/create-kiosk';
  static const String createStore = '/create-store';
  static const String home = '/home';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );

      case phoneAuth:
        return MaterialPageRoute(
          builder: (_) => const PhoneAuthScreen(),
          settings: settings,
        );

      case otpVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(
            phoneNumber: args?['phoneNumber'] ?? '',
            verificationId: args?['verificationId'],
          ),
          settings: settings,
        );

      case completeRegistration:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => CompleteRegistrationScreen(
            phoneNumber: args?['phoneNumber'] ?? '',
          ),
          settings: settings,
        );

      case createKiosk:
        return MaterialPageRoute(
          builder: (_) => const CreatekioskScreen(),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const MainLayout(),
          settings: settings,
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }

  // Navigation helper methods
  static Future<dynamic> pushNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static Future<dynamic> pushReplacementNamed(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushReplacementNamed(
      context,
      routeName,
      arguments: arguments,
    );
  }

  static Future<dynamic> pushNamedAndRemoveUntil(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static void pop(BuildContext context, [dynamic result]) {
    Navigator.pop(context, result);
  }
}
