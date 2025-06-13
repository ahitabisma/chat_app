import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static final _storage = FlutterSecureStorage();

  // Save user token
  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Get saved token
  static Future<String?> getToken() async {
    final token = await _storage.read(key: 'auth_token');
    return token;
  }

  // Save user refresh token
  static Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: 'auth_refresh_token', value: token);
  }

  // Get saved refresh token
  static Future<String?> getRefreshToken() async {
    final token = await _storage.read(key: 'auth_refresh_token');
    return token;
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email');
  }

  static Future<void> saveUserData(int id, String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', id);
    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      // Get token first
      final token = await getToken();
      print("Checking token: ${token != null ? 'exists' : 'null'}");
      
      if (token == null || token.isEmpty) {
        print("No valid token found");
        return false;
      }
      
      // Also check if we have user data
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');
      final userName = prefs.getString('user_name');
      final userEmail = prefs.getString('user_email');
      
      print("User data in storage - ID: $userId, Name: $userName, Email: $userEmail");
      
      // Only return true if we have all necessary data
      return userId != null && userName != null && userEmail != null;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  // Clear user data (logout)
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _storage.deleteAll();
  }
}
