part of 'splash_cubit.dart';

sealed class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

final class SplashInitial extends SplashState {}

final class SplashReady extends SplashState {
  const SplashReady({
    required this.holeScale,
    required this.holeOpacity,
    required this.holeVerticalOffset,
    required this.logoScale,
    required this.logoOpacity,
    required this.logoSlide,
  });

  final Animation<double> holeScale;
  final Animation<double> holeOpacity;
  final Animation<double> holeVerticalOffset;
  final Animation<double> logoScale;
  final Animation<double> logoOpacity;
  final Animation<Offset> logoSlide;
}

final class SplashNavigate extends SplashState {
  const SplashNavigate({required this.route});

  final String route;

  @override
  List<Object?> get props => [route];
}
