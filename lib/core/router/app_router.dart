import 'package:coinly/features/home/ui/screens/notifications_screen.dart';
import 'package:coinly/features/add/ui/screens/add_worker_screen.dart';
import 'package:coinly/features/add/ui/screens/add_worker_info.dart';
import 'package:flutter/material.dart';
import '../layout/main_layout.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/ui/screens/onboarding_screen.dart';
import '../../features/auth/ui/screens/phone_auth_screen.dart';
import '../../features/auth/ui/screens/otp_verification_screen.dart';
import '../../features/auth/ui/screens/complete_registration_screen.dart';
import '../../features/auth/ui/screens/login_screen.dart';
import '../../features/auth/ui/screens/owwner_access_screen.dart';
import '../../features/auth/ui/screens/select role.dart';
import '../../features/kiosk/create_kiosk_screen.dart';

class AppRouter {
  // Route names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String phoneAuth = '/phone-auth';
  static const String otpVerification = '/otp-verification';
  static const String completeRegistration = '/complete-registration';
  static const String selectUserRole = '/select-user-role';
  static const String ownerAccess = '/owner-access';
  static const String createKiosk = '/create-kiosk';
  static const String createStore = '/create-store';
  static const String home = '/home';
  static const String notifications = '/notifications';
  static const String addWorker = '/add-worker';
  static const String addWorkerInfo = '/add-worker-info';

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );

      case onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
          settings: settings,
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
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

      case selectUserRole:
        return MaterialPageRoute(
          builder: (_) => const SelectUserRoleScreen(),
          settings: settings,
        );

      case ownerAccess:
        return MaterialPageRoute(
          builder: (_) => const OwwnerAccessScreen(),
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

      case notifications:
        return MaterialPageRoute(
          builder: (_) => const NotificationsScreen(),
          settings: settings,
        );

      case addWorker:
        return MaterialPageRoute(
          builder: (_) => const AddWorkerScreen(),
          settings: settings,
        );

      case addWorkerInfo:
        return MaterialPageRoute(
          builder: (_) => const AddWorkerInfoScreen(),
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
