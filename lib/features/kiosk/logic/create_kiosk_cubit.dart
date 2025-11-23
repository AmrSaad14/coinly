import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/constants.dart';
import '../data/models/create_kiosk_request_model.dart';
import '../data/models/market_model.dart';
import '../data/repository/kiosk_repository.dart';
import 'create_kiosk_state.dart';

class CreateKioskCubit extends Cubit<CreateKioskState> {
  final KioskRepository repository;
  final SharedPreferences sharedPreferences;

  CreateKioskCubit({
    required this.repository,
    required this.sharedPreferences,
  }) : super(CreateKioskInitial());

  Future<void> createKiosk({
    required String name,
    required String kind,
    required String location,
  }) async {
    emit(CreateKioskLoading());

    // Get access token from SharedPreferences
    final accessToken = sharedPreferences.getString(AppConstants.accessToken);
    
    if (accessToken == null || accessToken.isEmpty) {
      emit(const CreateKioskError('لم يتم العثور على رمز الدخول. يرجى تسجيل الدخول مرة أخرى.'));
      return;
    }

    final authorization = 'Bearer $accessToken';

    final request = CreateKioskRequestModel(
      market: MarketModel(
        id: 0, // ID will be assigned by the server
        name: name,
        kind: kind,
        location: location,
      ),
    );

    final result = await repository.createKiosk(request, authorization);

    result.fold(
      (failure) => emit(CreateKioskError(_mapFailureToMessage(failure))),
      (_) => emit(CreateKioskSuccess()),
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

