import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';

import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/utils/constants.dart';

void main() async {
  // Preserve the splash screen while we initialize
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize App Check for security
  // This is required for phone authentication to work
  await _initializeAppCheck();

  // Configure Firebase Auth for testing
  // This allows test phone numbers to work properly
  await _configureFirebaseAuth();

  // Initialize dependencies
  await di.init();

  runApp(const MyApp());

  // Remove the splash screen after app is ready
  FlutterNativeSplash.remove();
}

/// Initialize Firebase App Check for security
/// This is required for phone authentication with reCAPTCHA Enterprise
Future<void> _initializeAppCheck() async {
  try {
    await FirebaseAppCheck.instance.activate(
      // Use debug provider in debug mode for easier testing
      androidProvider: kDebugMode
          ? AndroidProvider.debug
          : AndroidProvider.playIntegrity,
      appleProvider: AppleProvider.appAttest,
    );

    if (kDebugMode) {
      print('✅ App Check initialized successfully (Debug Mode)');
      print('📱 If you see App Check errors, follow these steps:');
      print('   1. Check the debug token in logcat');
      print(
        '   2. Add it to Firebase Console > App Check > Apps > Manage debug tokens',
      );
      print('   3. Or follow the setup guide in FIREBASE_RECAPTCHA_SETUP.md');
    }
  } catch (e) {
    print('❌ Error initializing App Check: $e');
    print('⚠️  Phone authentication may not work properly');
    print('📖 See FIREBASE_RECAPTCHA_SETUP.md for setup instructions');
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
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: AppRouter.onboarding,
    );
  }
}
