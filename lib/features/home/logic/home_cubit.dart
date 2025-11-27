import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/constants.dart';
import '../../kiosk/data/repository/kiosk_repository.dart';
import '../data/models/owner_data_model.dart';
import '../data/repository/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;
  final KioskRepository kioskRepository;
  final SharedPreferences sharedPreferences;

  HomeCubit({
    required this.repository,
    required this.kioskRepository,
    required this.sharedPreferences,
  }) : super(HomeInitial());

  Future<void> loadHome() async {
    emit(HomeLoading());

    final accessToken =
        sharedPreferences.getString(AppConstants.accessToken);

    if (accessToken == null || accessToken.isEmpty) {
      emit(const HomeError(
          'لم يتم العثور على رمز الدخول. يرجى تسجيل الدخول مرة أخرى.'));
      return;
    }

    final authorization = 'Bearer $accessToken';
    final result = await repository.getOwnerMe(authorization);

    result.fold(
      (failure) => emit(HomeError(_mapFailureToMessage(failure))),
      (ownerData) => emit(HomeLoaded(ownerData)),
    );
  }

  Future<void> deleteMarket(int marketId) async {
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final accessToken =
        sharedPreferences.getString(AppConstants.accessToken);

    if (accessToken == null || accessToken.isEmpty) {
      emit(const HomeError(
          'لم يتم العثور على رمز الدخول. يرجى تسجيل الدخول مرة أخرى.'));
      return;
    }

    final authorization = 'Bearer $accessToken';

    final result =
        await kioskRepository.deleteMarket(marketId, authorization);

    result.fold(
      (failure) => emit(HomeError(_mapFailureToMessage(failure))),
      (_) {
        final updatedMarkets = currentState.ownerData.markets
            .where((market) => market.id != marketId)
            .toList();

        final updatedOwner = OwnerDataModel(
          id: currentState.ownerData.id,
          email: currentState.ownerData.email,
          fullName: currentState.ownerData.fullName,
          job: currentState.ownerData.job,
          role: currentState.ownerData.role,
          isVerified: currentState.ownerData.isVerified,
          phoneNumber: currentState.ownerData.phoneNumber,
          points: currentState.ownerData.points,
          loans: currentState.ownerData.loans,
          profits: currentState.ownerData.profits,
          workersCount: currentState.ownerData.workersCount,
          markets: updatedMarkets,
        );

        emit(HomeLoaded(updatedOwner));
      },
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.message;
      case NetworkFailure:
        return failure.message;
      default:
        return 'حدث خطأ غير متوقع';
    }
  }
}