import 'package:dio/dio.dart';
import '../models/create_kiosk_request_model.dart';
import '../../../../core/errors/exceptions.dart';

abstract class KioskRemoteDataSource {
  Future<void> createKiosk(CreateKioskRequestModel request);
}

class KioskRemoteDataSourceImpl implements KioskRemoteDataSource {
  final Dio dio;

  KioskRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> createKiosk(CreateKioskRequestModel request) async {
    try {
      print('📤 Creating kiosk with data: ${request.toJson()}');
      final response = await dio.post(
        '/kiosk', // Update this endpoint path as needed
        data: request.toJson(),
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
}
