/// Utility class to extract messages from API responses
class MessageExtractor {
  /// Extracts error message from DioException response data
  /// Tries multiple common error message fields: 'message', 'error', 'errors', 'detail'
  static String extractErrorMessage(dynamic responseData) {
    if (responseData == null) {
      return 'حدث خطأ غير متوقع';
    }

    // If responseData is a String, return it directly
    if (responseData is String) {
      return responseData;
    }

    // If responseData is a Map, try to extract message
    if (responseData is Map<String, dynamic>) {
      // Try common error message fields
      if (responseData['message'] != null) {
        final message = responseData['message'];
        if (message is String) {
          return message;
        }
        // If message is a list, join them
        if (message is List) {
          return message.join(', ');
        }
      }

      // For OAuth2 errors, prioritize error_description over error
      // error_description is human-readable, error is just the error code (e.g., "invalid_grant")
      if (responseData['error_description'] != null) {
        final errorDescription = responseData['error_description'];
        if (errorDescription is String && errorDescription.isNotEmpty) {
          return errorDescription;
        }
      }

      if (responseData['error'] != null) {
        final error = responseData['error'];
        if (error is String) {
          // Only use error if it's not a generic OAuth error code
          // OAuth error codes like "invalid_grant" are not user-friendly
          const oauthErrorCodes = ['invalid_grant', 'invalid_client', 'invalid_request', 'unauthorized_client', 'unsupported_grant_type', 'invalid_scope'];
          if (oauthErrorCodes.contains(error.toLowerCase())) {
            // Skip generic OAuth error codes, they're not user-friendly
            // If error_description wasn't found, we'll fall back to a default message
          } else {
            return error;
          }
        }
        if (error is Map) {
          // Try to get message from error object
          if (error['message'] != null) {
            return error['message'].toString();
          }
        }
      }

      if (responseData['errors'] != null) {
        final errors = responseData['errors'];
        if (errors is Map) {
          // Extract first error from validation errors
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            return firstError.first.toString();
          }
          if (firstError is String) {
            return firstError;
          }
        }
        if (errors is List && errors.isNotEmpty) {
          return errors.first.toString();
        }
      }

      if (responseData['detail'] != null) {
        return responseData['detail'].toString();
      }
    }

    return 'حدث خطأ غير متوقع';
  }

  /// Extracts success message from API response data
  /// Tries common success message fields: 'message', 'success', 'data.message'
  static String? extractSuccessMessage(dynamic responseData) {
    if (responseData == null) {
      return null;
    }

    // If responseData is a String, return it directly
    if (responseData is String) {
      return responseData;
    }

    // If responseData is a Map, try to extract message
    if (responseData is Map<String, dynamic>) {
      // Try common success message fields
      if (responseData['message'] != null) {
        final message = responseData['message'];
        if (message is String) {
          return message;
        }
        return message.toString();
      }

      if (responseData['success'] != null) {
        final success = responseData['success'];
        if (success is String) {
          return success;
        }
      }

      // Try nested data.message
      if (responseData['data'] != null &&
          responseData['data'] is Map<String, dynamic>) {
        final data = responseData['data'] as Map<String, dynamic>;
        if (data['message'] != null) {
          return data['message'].toString();
        }
      }
    }

    return null;
  }

  /// Extracts message from DioException, removing status code prefix if present
  static String extractErrorFromDioException(dynamic responseData) {
    final message = extractErrorMessage(responseData);
    
    // Remove status code prefix if present (e.g., "Server error (400): Actual message")
    final regex = RegExp(r'^Server error \(\d+\):\s*');
    return message.replaceFirst(regex, '');
  }
}

