import 'package:coinly/core/theme/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coinly/core/router/app_router.dart';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:coinly/features/splash/logic/cubit/splash_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SplashCubit(tickerProvider: this)..init(),
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (_, current) => current is SplashNavigate,
        listener: (context, state) {
          if (!mounted) return;
          Navigator.of(context).pushReplacementNamed(AppRouter.onboarding);
        },
        child: Scaffold(
          backgroundColor: AppColors.primary500,
          body: BlocBuilder<SplashCubit, SplashState>(
            buildWhen: (_, current) => current is SplashReady,
            builder: (context, state) {
              if (state is! SplashReady) {
                return const SizedBox.shrink();
              }
              return SlideTransition(
                position: state.logoSlide,
                child: Center(
                  child: FadeTransition(
                    opacity: state.logoOpacity,
                    child: ScaleTransition(
                      scale: state.logoScale,
                      child: Image.asset(AppAssets.logo2Png)
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
