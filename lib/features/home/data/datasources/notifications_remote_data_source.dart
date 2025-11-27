import 'package:dio/dio.dart';
import '../models/notifications_response_model.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_service.dart';
import '../../../../core/utils/message_extractor.dart';

abstract class NotificationsRemoteDataSource {
  Future<NotificationsResponseModel> getNotifications(String authorization);
  Future<String?> markAllNotificationsRead(String authorization);
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final Dio dio;
  final ApiService apiService;

  NotificationsRemoteDataSourceImpl({
    required this.dio,
    required this.apiService,
  });

  @override
  Future<NotificationsResponseModel> getNotifications(
    String authorization,
  ) async {
    try {
      final response = await apiService.getNotifications(authorization);
      return response;
    } on DioException catch (e) {
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
        final errorMessage = MessageExtractor.extractErrorFromDioException(
          e.response?.data,
        );
        throw ServerException(errorMessage);
      } else if (e.type == DioExceptionType.unknown) {
        final error = e.error;
        if (error != null) {
          final errorString = error.toString();
          if (errorString.contains('type') ||
              errorString.contains('cast') ||
              errorString.contains('fromJson') ||
              errorString.contains('FormatException')) {
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
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
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
  Future<String?> markAllNotificationsRead(String authorization) async {
    try {
      final response = await apiService.markAllNotificationsRead(authorization);
      // Extract success message if available
      if (response.data is Map<String, dynamic>) {
        return MessageExtractor.extractSuccessMessage(response.data);
      }
      return null;
    } on DioException catch (e) {
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
        final errorMessage = MessageExtractor.extractErrorFromDioException(
          e.response?.data,
        );
        throw ServerException(errorMessage);
      } else if (e.type == DioExceptionType.unknown) {
        final error = e.error;
        if (error != null) {
          final errorString = error.toString();
          if (errorString.contains('type') ||
              errorString.contains('cast') ||
              errorString.contains('fromJson') ||
              errorString.contains('FormatException')) {
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
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      }
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

