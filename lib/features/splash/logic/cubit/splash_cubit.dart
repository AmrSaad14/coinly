import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:coinly/core/utils/constants.dart';
import 'package:coinly/core/router/app_router.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({
    required TickerProvider tickerProvider,
    required SharedPreferences sharedPreferences,
  })  : _tickerProvider = tickerProvider,
        _sharedPreferences = sharedPreferences,
        super(SplashInitial());

  final TickerProvider _tickerProvider;
  final SharedPreferences _sharedPreferences;
  late final AnimationController _controller;
  late final Animation<double> _holeScale;
  late final Animation<double> _holeOpacity;
  late final Animation<double> _holeVerticalOffset;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _logoSlide;

  static const _animationDuration = Duration(milliseconds: 4000);

  void init() {
    _controller = AnimationController(
      vsync: _tickerProvider,
      duration: _animationDuration,
    );
    // Hole (logo_2.png) appears first and bounces like a trampoline
    _holeScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 20),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.1)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 40,
      ),
    ]).animate(_controller);

    // Opacity: appear quickly, then disappear completely BEFORE main logo fades in
    _holeOpacity = TweenSequence<double>([
      // 0% - 15%: fade in
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),
      // 15% - 55%: fully visible while bouncing
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 40),
      // 55% - 70%: fade out to zero
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      // 70% - 100%: stay hidden
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 30),
    ]).animate(_controller);

    // Vertical trampoline motion: up, then down past center, then settle
    _holeVerticalOffset = TweenSequence<double>([
      // Start at center, jump slightly up
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: -40.0)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 25,
      ),
      // Fall down past center (where it will extend into the main logo)
      TweenSequenceItem(
        tween: Tween(begin: -40.0, end: 20.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 35,
      ),
      // Small bounce back to center
      TweenSequenceItem(
        tween: Tween(begin: 20.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
    ]).animate(_controller);

    // Main logo grows in as the hole fades out
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.8), weight: 50),
      TweenSequenceItem(
        tween: Tween(begin: 0.8, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.05)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
    ]).animate(_controller);

    // Main logo opacity: start ONLY after hole is fully gone (no stacking)
    _logoOpacity = TweenSequence<double>([
      // 0% - 70%: fully hidden while hole exists
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 70),
      // 70% - 95%: fade in
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 25,
      ),
      // 95% - 100%: stay visible until navigation
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 5),
    ]).animate(_controller);

    _logoSlide = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _checkAuthAndNavigate();
      }
    });

    emit(
      SplashReady(
        holeScale: _holeScale,
        holeOpacity: _holeOpacity,
        holeVerticalOffset: _holeVerticalOffset,
        logoScale: _logoScale,
        logoOpacity: _logoOpacity,
        logoSlide: _logoSlide,
      ),
    );

    _controller.forward();
  }

  void _checkAuthAndNavigate() {
    // Check if onboarding has been shown before
    final onboardingShown = _sharedPreferences.getBool(AppConstants.onboardingShown) ?? false;
    
    // If onboarding hasn't been shown, show it first
    if (!onboardingShown) {
      emit(SplashNavigate(route: AppRouter.onboarding));
      return;
    }
    
    // If onboarding has been shown, check authentication
    final token = _sharedPreferences.getString(AppConstants.accessToken);
    
    // If token exists, navigate to home, otherwise to login
    final route = (token != null && token.isNotEmpty)
        ? AppRouter.home
        : AppRouter.login;
    
    emit(SplashNavigate(route: route));
  }

  @override
  Future<void> close() {
    _controller.dispose();
    return super.close();
  }
}
