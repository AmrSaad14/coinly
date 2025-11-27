import 'package:dio/dio.dart';
import '../models/owner_data_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/constants.dart';

abstract class HomeRemoteDataSource {
  Future<OwnerDataModel> getOwnerMe(String authorization);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;
  final ApiService apiService;

  HomeRemoteDataSourceImpl({required this.dio, required this.apiService});

  @override
  Future<OwnerDataModel> getOwnerMe(String authorization) async {
    try {
      print('📤 Fetching owner data with authorization');
      print(
        '📤 Authorization header: ${authorization.substring(0, authorization.length > 30 ? 30 : authorization.length)}...',
      );
      print(
        '📤 Full URL will be: ${AppConstants.baseUrl}/api/v1/owner/me',
      );
      final response = await apiService.getOwnerMe(authorization);
      print('✅ Successfully fetched owner data: ${response.data.fullName}');
      print(
        '✅ Owner data: id=${response.data.id}, points=${response.data.points}, markets=${response.data.markets.length}',
      );
      return response.data;
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




