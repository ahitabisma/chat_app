import 'package:chat_app/utils/api_helper.dart';
import 'package:dio/dio.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await ApiHelper.dio.post(
        '/api/login',
        data: {'email': email, 'password': password},
      );

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      String errorMessage = 'Login failed';

      if (e.response != null && e.response!.data is Map) {
        final data = e.response!.data as Map;

        // Check if errors field exists first
        if (data.containsKey('errors') && data['errors'] != null) {
          final errors = data['errors'];

          // Process errors object that contains field-specific errors
          if (errors is Map) {
            // Convert all field errors to a formatted string
            List<String> errorMessages = [];

            errors.forEach((field, value) {
              if (value is List) {
                // For array of error messages
                errorMessages.add('$field: ${value.join(", ")}');
              } else {
                // For single error message
                errorMessages.add('$field: $value');
              }
            });

            if (errorMessages.isNotEmpty) {
              errorMessage = errorMessages.join('\n');
            }
          } else if (errors is String) {
            errorMessage = errors;
          }
        }
        // If errors doesn't exist or is null, try message
        else if (data.containsKey('message') && data['message'] != null) {
          errorMessage = data['message'].toString();
        }
      }

      throw Exception(errorMessage);
    }
  }

  static Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response = await ApiHelper.dio.post(
        '/api/register',
        data: {'name': name, 'email': email, 'password': password},
      );

      // print('Registered User: ' + (response.data));

      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      // print('Error: ' + e.response!.data);
      String errorMessage = 'Register failed';

      if (e.response != null && e.response!.data is Map) {
        final data = e.response!.data as Map;

        // Check if errors field exists first
        if (data.containsKey('errors') && data['errors'] != null) {
          final errors = data['errors'];

          // Process errors object that contains field-specific errors
          if (errors is Map) {
            // Convert all field errors to a formatted string
            List<String> errorMessages = [];

            errors.forEach((field, value) {
              if (value is List) {
                // For array of error messages
                errorMessages.add('$field: ${value.join(", ")}');
              } else {
                // For single error message
                errorMessages.add('$field: $value');
              }
            });

            if (errorMessages.isNotEmpty) {
              errorMessage = errorMessages.join('\n');
            }
          } else if (errors is String) {
            errorMessage = errors;
          }
        }
        // If errors doesn't exist or is null, try message
        else if (data.containsKey('message') && data['message'] != null) {
          errorMessage = data['message'].toString();
        }
      }

      throw Exception(errorMessage);
    }
  }
}
