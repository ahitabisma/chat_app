import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/utils/storage_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    state = {...state, 'status': AuthState.loading};

    try {
      final isLoggedIn = await StorageHelper.isLoggedIn();
      final token = await StorageHelper.getToken();

      if (isLoggedIn && token != null) {
        // Get user data from storage
        final id = await StorageHelper.getUserId();
        final name = await StorageHelper.getUserName();
        final email = await StorageHelper.getUserEmail();

        // Jika data user berhasil diambil
        if (id != null && name != null && email != null) {
          // Set state ke authenticated dan masukkan data user
          state = {
            'status': AuthState.authenticated,
            'user': {'id': id, 'name': name, 'email': email},
            'error': null,
          };
          return;
        }
      }

      // Jika tidak berhasil login atau data tidak lengkap
      state = {
        'status': AuthState.unauthenticated,
        'user': null,
        'error': null,
      };
    } catch (e) {
      // Jika error, set state ke unauthenticated
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

      // Save user data to local storage
      if (data['token'] != null) {
        await StorageHelper.saveToken(data['token']);
      }

      await StorageHelper.saveUserData(
        data['user']['id'],
        data['user']['name'],
        data['user']['email'],
      );

      // Update state to authenticated
      state = {
        'status': AuthState.authenticated,
        'user': data['user'],
        'error': null,
      };
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
