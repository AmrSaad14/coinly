import 'package:coinly/core/di/injection_container.dart' as di;
import 'package:coinly/features/add/ui/screens/add_worker_info.dart';
import 'package:coinly/features/add/ui/screens/add_worker_screen.dart';
import 'package:coinly/features/auth/logic/cubit/cubit/login_cubit.dart';
import 'package:coinly/features/home/logic/notifications_cubit.dart';
import 'package:coinly/features/home/ui/screens/kiosk_transactions_screen.dart';
import 'package:coinly/features/home/ui/screens/manage_kiosk.dart';
import 'package:coinly/features/home/ui/screens/notifications_screen.dart';
import 'package:coinly/features/withdraw/ui/screens/withdraw_confirmation_screen.dart';
import 'package:coinly/core/theme/app_assets.dart';
import 'package:coinly/features/withdraw/ui/screens/withdraw_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../layout/main_layout.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/ui/screens/onboarding_screen.dart';
import '../../features/auth/ui/screens/phone_auth_screen.dart';
import '../../features/auth/ui/screens/otp_verification_screen.dart';
import '../../features/auth/ui/screens/complete_registration_screen.dart';
import '../../features/auth/ui/screens/login_screen.dart';
import '../../features/auth/ui/screens/owner_access_screen.dart';
import '../../features/auth/ui/screens/blocked_user.dart';
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
  static const String blockedUser = '/blocked-user';
  static const String createKiosk = '/create-kiosk';
  static const String createStore = '/create-store';
  static const String withdraw = '/withdraw';
   static const String withdrawConfirmation = '/withdraw-confirmation';
  static const String home = '/home';
  static const String notifications = '/notifications';
  static const String manageKiosk = '/manage-kiosk';
  static const String addWorker = '/add-worker';
  static const String addWorkerInfo = '/add-worker-info';
  static const String kioskTransactions = '/kiosk-transactions';
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
          builder: (_) => BlocProvider(
            create: (_) => di.sl<LoginCubit>(),
            child: const LoginScreen(),
          ),
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
            role: args?['role'],
          ),
          settings: settings,
        );

      case selectUserRole:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => const SelectUserRoleScreen(),
          settings: RouteSettings(name: settings.name, arguments: args),
        );

      case ownerAccess:
        return MaterialPageRoute(
          builder: (_) => const OwnerAccessScreen(),
          settings: settings,
        );

      case blockedUser:
        return MaterialPageRoute(
          builder: (_) => const BlockedUserScreen(),
          settings: settings,
        );

      case createKiosk:
        return MaterialPageRoute(
          builder: (_) => const CreatekioskScreen(),
          settings: settings,
        );

      case withdraw:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => WithDrawScreen(
            marketId: args?['marketId'] as int?,
          ),
          settings: settings,
        );

      case withdrawConfirmation:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => WithdrawConfirmationScreen(
            paymentMethod: 'تحويل النقاط',
            paymentMethodIcon: AppAssets.transferIcon,
            isTransfer: true,
            marketId: args?['marketId'] as int?,
          ),
          settings: settings,
        );

      case home:
        return MaterialPageRoute(
          builder: (_) => const MainLayout(),
          settings: settings,
        );

      case notifications:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (_) => di.sl<NotificationsCubit>(),
            child: const NotificationsScreen(),
          ),
          settings: settings,
        );

      case manageKiosk:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>
              ManageKioskScreen(marketId: args?['marketId'] as int?),
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
      case kioskTransactions:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) =>
              KioskTransactionsScreen(marketId: args?['marketId'] as int?),
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
