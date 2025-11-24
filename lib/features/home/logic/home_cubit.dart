import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../data/repository/home_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeRepository repository;

  HomeCubit({required this.repository}) : super(HomeInitial());

  Future<void> getOwnerMe(String authorization) async {
    emit(HomeLoading());

    final result = await repository.getOwnerMe(authorization);

    result.fold(
      (failure) => emit(HomeError(_mapFailureToMessage(failure))),
      (ownerData) => emit(HomeLoaded(ownerData)),
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

