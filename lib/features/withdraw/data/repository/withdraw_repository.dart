import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../datasources/withdraw_remote_data_source.dart';
import '../models/withdrawal_request_model.dart';
import '../models/withdrawal_response_model.dart';
import '../models/transaction_request_model.dart';
import '../models/transaction_response_model.dart';

abstract class WithdrawRepository {
  Future<Either<Failure, WithdrawalResponseModel>> createWithdrawalRequest(
    WithdrawalRequestModel request,
    String authorization,
  );

  Future<Either<Failure, TransactionResponseModel>> createTransaction(
    TransactionRequestModel request,
    String authorization,
  );
}

class WithdrawRepositoryImpl implements WithdrawRepository {
  final WithdrawRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WithdrawRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, WithdrawalResponseModel>> createWithdrawalRequest(
    WithdrawalRequestModel request,
    String authorization,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.createWithdrawalRequest(
          request,
          authorization,
        );
        return Right(response);
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
  Future<Either<Failure, TransactionResponseModel>> createTransaction(
    TransactionRequestModel request,
    String authorization,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await remoteDataSource.createTransaction(
          request,
          authorization,
        );
        return Right(response);
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
