import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/kiosk_remote_data_source.dart';
import '../models/create_kiosk_request_model.dart';

abstract class KioskRepository {
  Future<Either<Failure, void>> createKiosk(CreateKioskRequestModel request);
}

class KioskRepositoryImpl implements KioskRepository {
  final KioskRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  KioskRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, void>> createKiosk(
    CreateKioskRequestModel request,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createKiosk(request);
        return const Right(null);
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      } on NetworkException catch (e) {
        return Left(NetworkFailure(e.message));
      } catch (e) {
        return Left(ServerFailure('Unexpected error: ${e.toString()}'));
      }
    } else {
      return const Left(NetworkFailure('No internet connection'));
    }
  }
}
