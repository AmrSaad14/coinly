import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../data/models/create_kiosk_request_model.dart';
import '../data/models/market_model.dart';
import '../data/repository/kiosk_repository.dart';
import 'create_kiosk_state.dart';

class CreateKioskCubit extends Cubit<CreateKioskState> {
  final KioskRepository repository;

  CreateKioskCubit({required this.repository}) : super(CreateKioskInitial());

  Future<void> createKiosk({
    required String name,
    required String kind,
    required String location,
  }) async {
    emit(CreateKioskLoading());

    final request = CreateKioskRequestModel(
      market: MarketModel(
        name: name,
        kind: kind,
        location: location,
      ),
    );

    final result = await repository.createKiosk(request);

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

