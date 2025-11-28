import 'package:coinly/core/theme/app_assets.dart';
import 'package:coinly/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coinly/core/di/injection_container.dart' as di;
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
      create: (_) => SplashCubit(
        tickerProvider: this,
        sharedPreferences: di.sl(),
      )..init(),
      child: BlocListener<SplashCubit, SplashState>(
        listenWhen: (_, current) => current is SplashNavigate,
        listener: (context, state) {
          if (!mounted) return;
          if (state is SplashNavigate) {
            Navigator.of(context).pushReplacementNamed(state.route);
          }
        },
        child: Scaffold(
          body: BlocBuilder<SplashCubit, SplashState>(
            buildWhen: (_, current) => current is SplashReady,
            builder: (context, state) {
              if (state is! SplashReady) {
                return const SizedBox.shrink();
              }
              return SlideTransition(
                position: state.logoSlide,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Main logo that extends from the hole
                      FadeTransition(
                        opacity: state.logoOpacity,
                        child: ScaleTransition(
                          scale: state.logoScale,
                          child: Image.asset(AppAssets.logoPng),
                        ),
                      ),
                      // Shadow circle under the bouncing logo_2
                      Align(
                        alignment: Alignment.center,
                        child: Transform.translate(
                          offset: const Offset(0, 32),
                          child: Container(
                            width: 64,
                            height: 12,
                            decoration: BoxDecoration(
                              color: AppColors.primary500,
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ),
                      // Hole logo that appears first and bounces
                      FadeTransition(
                        opacity: state.holeOpacity,
                        child: ScaleTransition(
                          scale: state.holeScale,
                          child: AnimatedBuilder(
                            animation: state.holeVerticalOffset,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(
                                  0,
                                  state.holeVerticalOffset.value,
                                ),
                                child: child,
                              );
                            },
                            child: Image.asset(AppAssets.logo2Png),
                          ),
                        ),
                      ),
                    ],
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
