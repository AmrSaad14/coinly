import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';

import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/utils/constants.dart';

void main() async {
  // Preserve the splash screen while we initialize
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize App Check for security
  // TEMPORARILY DISABLED to test phone auth - App Check debug token needs to be registered
  // Set to true after registering debug token in Firebase Console
  const bool enableAppCheck = bool.fromEnvironment(
    'ENABLE_APP_CHECK',
    defaultValue: false,
  );
  if (enableAppCheck) {
    await _initializeAppCheck();
  } else {
    print('⚠️  App Check is temporarily disabled for testing');
    print(
      '📱 Phone auth should work, but App Check is recommended for production',
    );
  }

  // Configure Firebase Auth for testing
  // This allows test phone numbers to work properly
  await _configureFirebaseAuth();

  // Initialize dependencies
  await di.init();

  runApp(const MyApp());

  // Remove the splash screen after app is ready
}

/// Initialize Firebase App Check for security
/// This is required for phone authentication with reCAPTCHA Enterprise
Future<void> _initializeAppCheck() async {
  try {
    if (kDebugMode) {
      // In debug mode, use debug provider and get the token
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.debug,
        appleProvider: AppleProvider.appAttest,
      );

      print('✅ App Check initialized successfully (Debug Mode)');
      print('📱 To get the App Check debug token:');
      print('   1. Check Android logcat for "App Check debug token"');
      print('   2. Or run: adb logcat | grep -i "app check"');
      print(
        '   3. Add the token to Firebase Console > App Check > Apps > Manage debug tokens',
      );

      // Try to get token after a short delay (token might not be available immediately)
      Future.delayed(const Duration(seconds: 2), () async {
        try {
          final token = await FirebaseAppCheck.instance.getToken();
          if (token != null && token.isNotEmpty) {
            print('🔑 App Check Debug Token: $token');
            print('📋 Copy this token and add it to Firebase Console');
          }
        } catch (e) {
          // Token might not be available yet, that's okay
          print('💡 Debug token will appear in logcat. Check Android logs.');
        }
      });
    } else {
      // In release mode, use Play Integrity
      await FirebaseAppCheck.instance.activate(
        androidProvider: AndroidProvider.playIntegrity,
        appleProvider: AppleProvider.appAttest,
      );
      print('✅ App Check initialized successfully (Release Mode)');
    }
  } catch (e) {
    print('❌ Error initializing App Check: $e');
    print('⚠️  Phone authentication may not work properly');
    print('💡 If phone auth fails, App Check might need to be configured');
    print('📖 See FIREBASE_SETUP.md for setup instructions');
    // Don't throw - let the app continue, but phone auth might fail
  }
}

/// Configure Firebase Auth settings for proper phone authentication
Future<void> _configureFirebaseAuth() async {
  try {
    final auth = FirebaseAuth.instance;

    // Set auth settings for better stability
    await auth.setSettings(
      appVerificationDisabledForTesting: false,
      forceRecaptchaFlow: false,
    );

    // Optional: Use emulator for unlimited testing during development
    // Uncomment the lines below and run: firebase emulators:start --only auth
    // if (kDebugMode) {
    //   await auth.useAuthEmulator('localhost', 9099);
    //   print('Using Firebase Auth Emulator');
    // }

    if (kDebugMode) {
      print('✅ Firebase Auth configured successfully');
      print(
        '💡 TIP: Add test phone numbers in Firebase Console for unlimited testing',
      );
      print(
        '   Go to: Authentication > Sign-in method > Phone > Phone numbers for testing',
      );
    }
  } catch (e) {
    print('❌ Error configuring Firebase Auth: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: GoogleFonts.cairo().fontFamily,
            scaffoldBackgroundColor: AppColors.scaffoldBackground,
          ),
          themeMode: ThemeMode.system,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: AppRouter.splash,
        );
      },
    );
  }
}
