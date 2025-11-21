import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit({required TickerProvider tickerProvider})
    : _tickerProvider = tickerProvider,
      super(SplashInitial());

  final TickerProvider _tickerProvider;
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _logoSlide;

  static const _animationDuration = Duration(milliseconds: 4000);

  void init() {
    _controller = AnimationController(
      vsync: _tickerProvider,
      duration: _animationDuration,
    );
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.85), weight: 30),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.85,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.9,
        ).chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 35,
      ),
    ]).animate(_controller);
    _logoOpacity = TweenSequence<double>([
      TweenSequenceItem(tween: ConstantTween(0.0), weight: 30),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
    ]).animate(_controller);
    _logoSlide = TweenSequence<Offset>([
      TweenSequenceItem(tween: ConstantTween(const Offset(0, 0)), weight: 60),
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(0, 0),
          end: const Offset(-1.2, 0),
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 40,
      ),
    ]).animate(_controller);

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        emit(SplashNavigate());
      }
    });

    emit(
      SplashReady(
        logoScale: _logoScale,
        logoOpacity: _logoOpacity,
        logoSlide: _logoSlide,
      ),
    );

    _controller.forward();
  }

  @override
  Future<void> close() {
    _controller.dispose();
    return super.close();
  }
}
