import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/utils/constants.dart';
import 'core/theme/app_colors.dart';

void main() async {
  // Preserve the splash screen while we initialize
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize dependencies
  await di.init();

  runApp(const MyApp());

  // Remove the splash screen after app is ready
  FlutterNativeSplash.remove();
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
