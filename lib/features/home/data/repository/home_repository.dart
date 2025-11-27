import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/home_remote_data_source.dart';
import '../models/owner_data_model.dart';

abstract class HomeRepository {
  Future<Either<Failure, OwnerDataModel>> getOwnerMe(String authorization);
}

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, OwnerDataModel>> getOwnerMe(
    String authorization,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final ownerData = await remoteDataSource.getOwnerMe(authorization);
        return Right(ownerData);
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




