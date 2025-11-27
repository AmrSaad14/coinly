import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../data/repository/kiosk_repository.dart';
import 'market_state.dart';

class MarketCubit extends Cubit<MarketState> {
  final KioskRepository repository;

  MarketCubit({required this.repository}) : super(MarketInitial());

  Future<void> getMarketById({
    required int marketId,
    required String month,
    required int workerId,
    required String authorization,
  }) async {
    emit(MarketLoading());

    final result = await repository.getMarketById(
      marketId,
      month,
      workerId,
      authorization,
    );

    result.fold(
      (failure) => emit(MarketError(_mapFailureToMessage(failure))),
      (market) => emit(MarketLoaded(market)),
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





