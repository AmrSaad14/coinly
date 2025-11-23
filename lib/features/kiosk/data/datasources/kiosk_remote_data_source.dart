import 'package:dio/dio.dart';
import '../models/create_kiosk_request_model.dart';
import '../models/market_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/constants.dart';

abstract class KioskRemoteDataSource {
  Future<void> createKiosk(
    CreateKioskRequestModel request,
    String authorization,
  );
  Future<List<MarketModel>> getOwnerMarkets(String authorization);
  Future<MarketModel> getMarketById(int marketId, String authorization);
}

class KioskRemoteDataSourceImpl implements KioskRemoteDataSource {
  final Dio dio;
  final ApiService apiService;

  KioskRemoteDataSourceImpl({required this.dio, required this.apiService});

  @override
  Future<void> createKiosk(
    CreateKioskRequestModel request,
    String authorization,
  ) async {
    try {
      print('📤 Creating kiosk with data: ${request.toJson()}');
      print(
        '📤 Authorization header: ${authorization.substring(0, authorization.length > 30 ? 30 : authorization.length)}...',
      );

      final response = await apiService.createMarket(
        request.toJson(),
        authorization,
      );

      print('✅ Response status: ${response.statusCode}');
      print('✅ Response data: ${response.data}');

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException('Failed to create kiosk: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.type}');
      print('❌ Error message: ${e.message}');
      print('❌ Response: ${e.response?.data}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(
          'Unable to connect to server. Please check if the API URL is correct and your internet connection.',
        );
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        final errorMessage =
            e.response?.data?['message']?.toString() ??
            e.response?.data?['error']?.toString() ??
            'Server error occurred';
        throw ServerException('Server error (${statusCode}): $errorMessage');
      } else if (e.type == DioExceptionType.unknown) {
        throw NetworkException(
          'Network error: ${e.message ?? "Unable to reach server. Please check your internet connection."}',
        );
      } else {
        throw NetworkException('Network error occurred: ${e.message}');
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      print('❌ Unexpected error: $e');
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<List<MarketModel>> getOwnerMarkets(String authorization) async {
    try {
      print('📤 Fetching owner markets with authorization');
      print(
        '📤 Authorization header: ${authorization.substring(0, authorization.length > 30 ? 30 : authorization.length)}...',
      );
      print(
        '📤 Full URL will be: ${AppConstants.baseUrl}/api/v1/owner/markets',
      );
      final response = await apiService.getOwnerMarkets(authorization);
      print('✅ Successfully fetched ${response.records.length} markets');
      print(
        '✅ Metadata: count=${response.metadata.count}, page=${response.metadata.page}',
      );
      return response.records;
    } on DioException catch (e) {
      print('❌ DioException: ${e.type}');
      print('❌ Error message: ${e.message}');
      print('❌ Error response: ${e.response?.data}');
      print('❌ Error status code: ${e.response?.statusCode}');
      print('❌ Error request path: ${e.requestOptions.path}');
      print('❌ Error stack trace: ${e.stackTrace}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(
          'Unable to connect to server. Please check if the API URL is correct and your internet connection.',
        );
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        final errorMessage =
            e.response?.data?['message']?.toString() ??
            e.response?.data?['error']?.toString() ??
            'Server error occurred';
        throw ServerException('Server error (${statusCode}): $errorMessage');
      } else if (e.type == DioExceptionType.unknown) {
        // Check if there's an underlying error
        final error = e.error;
        print('❌ Underlying error: $error');
        print('❌ Error type: ${error.runtimeType}');

        if (error != null) {
          final errorString = error.toString();
          // Check if it's a JSON parsing error
          if (errorString.contains('type') ||
              errorString.contains('cast') ||
              errorString.contains('fromJson') ||
              errorString.contains('FormatException')) {
            print('❌ This appears to be a JSON parsing error');
            throw ServerException(
              'Failed to parse server response. The response format may be incorrect.',
            );
          }
          throw NetworkException('Network error: ${error.toString()}');
        } else {
          throw NetworkException(
            'Unknown network error. Please check your internet connection and try again.',
          );
        }
      } else {
        throw NetworkException(
          'Network error occurred: ${e.message ?? "Unknown error"}',
        );
      }
    } catch (e, stackTrace) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      print('❌ Unexpected error type: ${e.runtimeType}');
      print('❌ Unexpected error: $e');
      print('❌ Stack trace: $stackTrace');

      // Check if it's a JSON parsing error
      final errorString = e.toString();
      if (errorString.contains('type') ||
          errorString.contains('cast') ||
          errorString.contains('fromJson') ||
          errorString.contains('FormatException')) {
        throw ServerException(
          'Failed to parse server response. Please check the API response format.',
        );
      }

      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<MarketModel> getMarketById(int marketId, String authorization) async {
    try {
      print('📤 Fetching market by ID: $marketId');
      print(
        '📤 Authorization header: ${authorization.substring(0, authorization.length > 30 ? 30 : authorization.length)}...',
      );
      print(
        '📤 Full URL will be: ${AppConstants.baseUrl}/api/v1/owner/markets/$marketId',
      );
      final market = await apiService.getMarketById(marketId, authorization);
      print('✅ Successfully fetched market: ${market.name}');
      print('✅ Market data: id=${market.id}, name=${market.name}, points=${market.marketPoints}, loans=${market.marketLoans}');
      return market;
    } on DioException catch (e) {
      print('❌ DioException: ${e.type}');
      print('❌ Error message: ${e.message}');
      print('❌ Error response: ${e.response?.data}');
      print('❌ Error status code: ${e.response?.statusCode}');
      print('❌ Error request path: ${e.requestOptions.path}');

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException(
          'Connection timeout. Please check your internet connection.',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(
          'Unable to connect to server. Please check if the API URL is correct and your internet connection.',
        );
      } else if (e.type == DioExceptionType.badResponse) {
        final statusCode = e.response?.statusCode;
        final errorMessage =
            e.response?.data?['message']?.toString() ??
            e.response?.data?['error']?.toString() ??
            'Server error occurred';
        throw ServerException('Server error (${statusCode}): $errorMessage');
      } else if (e.type == DioExceptionType.unknown) {
        final error = e.error;
        print('❌ Underlying error: $error');

        if (error != null) {
          final errorString = error.toString();
          if (errorString.contains('type') ||
              errorString.contains('cast') ||
              errorString.contains('fromJson') ||
              errorString.contains('FormatException')) {
            print('❌ This appears to be a JSON parsing error');
            throw ServerException(
              'Failed to parse server response. The response format may be incorrect.',
            );
          }
          throw NetworkException('Network error: ${error.toString()}');
        } else {
          throw NetworkException(
            'Unknown network error. Please check your internet connection and try again.',
          );
        }
      } else {
        throw NetworkException(
          'Network error occurred: ${e.message ?? "Unknown error"}',
        );
      }
    } catch (e, stackTrace) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
      print('❌ Unexpected error type: ${e.runtimeType}');
      print('❌ Unexpected error: $e');
      print('❌ Stack trace: $stackTrace');

      final errorString = e.toString();
      if (errorString.contains('type') ||
          errorString.contains('cast') ||
          errorString.contains('fromJson') ||
          errorString.contains('FormatException')) {
        throw ServerException(
          'Failed to parse server response. Please check the API response format.',
        );
      }

      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }
}
