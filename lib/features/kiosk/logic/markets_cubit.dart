import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../data/repository/kiosk_repository.dart';
import 'markets_state.dart';

class MarketsCubit extends Cubit<MarketsState> {
  final KioskRepository repository;

  MarketsCubit({required this.repository}) : super(MarketsInitial());

  Future<void> getOwnerMarkets(String authorization) async {
    emit(MarketsLoading());

    final result = await repository.getOwnerMarkets(authorization);

    result.fold(
      (failure) => emit(MarketsError(_mapFailureToMessage(failure))),
      (markets) => emit(MarketsLoaded(markets)),
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


