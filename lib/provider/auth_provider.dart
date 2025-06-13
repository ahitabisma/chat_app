import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/utils/storage_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  isRegistered,
}

class AuthStateNotifier extends StateNotifier<Map<String, dynamic>> {
  AuthStateNotifier()
    : super({'status': AuthState.initial, 'user': null, 'error': null});

  // Check if user is already logged in
  Future<void> checkAuthStatus() async {
    // First set loading state
    state = {...state, 'status': AuthState.loading};
    print('Checking auth status...');

    try {
      // First, check if token exists
      final token = await StorageHelper.getToken();
      print('Token from storage: ${token != null ? 'exists' : 'null'}');

      if (token == null || token.isEmpty) {
        print('No token found, setting unauthenticated');
        state = {
          'status': AuthState.unauthenticated,
          'user': null,
          'error': null,
        };
        return;
      }

      // If token exists, try to get user data
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      final userName = prefs.getString('user_name');
      final userEmail = prefs.getString('user_email');

      print(
        'User data from storage - ID: $userId, Name: $userName, Email: $userEmail',
      );

      // Only consider authenticated if we have all user data
      if (userId != null && userName != null && userEmail != null) {
        print('All user data found, setting authenticated');
        state = {
          'status': AuthState.authenticated,
          'user': {'id': userId, 'name': userName, 'email': userEmail},
          'error': null,
        };
        return;
      } else {
        print('Missing user data, setting unauthenticated');
        state = {
          'status': AuthState.unauthenticated,
          'user': null,
          'error': null,
        };
      }
    } catch (e) {
      print('Error checking auth status: ${e}');
      state = {
        'status': AuthState.unauthenticated,
        'user': null,
        'error': 'Failed to check auth status',
      };
    }
  }

    // Login
  Future<void> login(String email, String password) async {
    try {
      state = {...state, 'status': AuthState.loading, 'error': null};
      // Call API
      final response = await AuthService.login(email, password);

      final data = response['data'];
      print('Login response: $data');

      if (data == null) {
        throw Exception('Invalid response from server');
      }

      // Save token first
      if (data['token'] != null) {
        await StorageHelper.saveToken(data['token']);
        print('Token saved: ${data['token']}');
      } else {
        throw Exception('No token received from server');
      }

      // Save user data
      if (data['user'] != null) {
        final user = data['user'];
        // Convert ID to string to be consistent
        final userId = user['id'].toString(); 
        final userName = user['name'].toString();
        final userEmail = user['email'].toString();
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', userId);
        await prefs.setString('user_name', userName);
        await prefs.setString('user_email', userEmail);
        
        print('User data saved - ID: $userId, Name: $userName, Email: $userEmail');
        
        // Also save "is_logged_in" flag
        await prefs.setBool('is_logged_in', true);
      }

      // Update state to authenticated
      state = {
        'status': AuthState.authenticated,
        'user': data['user'],
        'error': null,
      };
      print('Authentication state set to authenticated');
    } catch (e) {
      print('Login error: ${e.toString()}');
      // Extract error message from Exception
      String errorMessage;
      if (e is Exception) {
        // Get clean error message without 'Exception: ' prefix
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      } else {
        errorMessage = e.toString();
      }

      // Update state with formatted error
      state = {'status': AuthState.error, 'user': null, 'error': errorMessage};
    }
  }

  // Register
  Future<void> register(String name, String email, String password) async {
    try {
      state = {...state, 'status': AuthState.loading, 'error': null};
      // Call API
      await AuthService.register(name, email, password);

      // Update state to authenticated
      state = {'status': AuthState.isRegistered, 'user': null, 'error': null};
    } catch (e) {
      // Extract error message from Exception
      String errorMessage;
      if (e is Exception) {
        // Get clean error message without 'Exception: ' prefix
        errorMessage = e.toString().replaceFirst('Exception: ', '');
      } else {
        errorMessage = e.toString();
      }

      // Update state with formatted error
      state = {'status': AuthState.error, 'user': null, 'error': errorMessage};
    }
  }

  // Logout user
  Future<void> logout() async {
    state = {...state, 'status': AuthState.loading};

    try {
      // Hapus data user dari storage
      await StorageHelper.clearUserData();

      // Update state ke unauthenticated
      state = {
        'status': AuthState.unauthenticated,
        'user': null,
        'error': null,
      };
    } catch (e) {
      state = {
        'status': AuthState.error,
        'user': state['user'],
        'error': 'Failed to logout',
      };
    }
  }

  void clearError() {
    // Clear error state
    state = {...state, 'error': null};
  }
}

// Provider that can be used throughout the app
final authProvider =
    StateNotifierProvider<AuthStateNotifier, Map<String, dynamic>>((ref) {
      return AuthStateNotifier();
    });
