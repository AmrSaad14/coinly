import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/kiosk_remote_data_source.dart';
import '../models/create_kiosk_request_model.dart';
import '../models/market_model.dart';
import '../models/market_details_model.dart';

abstract class KioskRepository {
  Future<Either<Failure, void>> createKiosk(CreateKioskRequestModel request, String authorization);
  Future<Either<Failure, List<MarketModel>>> getOwnerMarkets(String authorization);
  Future<Either<Failure, MarketDetailsModel>> getMarketById(
    int marketId,
    String month,
    int workerId,
    String authorization,
  );

  Future<Either<Failure, void>> deleteMarket(
    int marketId,
    String authorization,
  );
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
    String authorization,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.createKiosk(request, authorization);
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

  @override
  Future<Either<Failure, List<MarketModel>>> getOwnerMarkets(
    String authorization,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final markets = await remoteDataSource.getOwnerMarkets(authorization);
        return Right(markets);
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

  @override
  Future<Either<Failure, MarketDetailsModel>> getMarketById(
    int marketId,
    String month,
    int workerId,
    String authorization,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final market = await remoteDataSource.getMarketById(
          marketId,
          month,
          workerId,
          authorization,
        );
        return Right(market);
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

  @override
  Future<Either<Failure, void>> deleteMarket(
    int marketId,
    String authorization,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.deleteMarket(marketId, authorization);
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
