import 'package:crm_app/core/services/api_service.dart';
import 'package:crm_app/core/utils/token_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Added 'role' parameter
  Future<bool> login(String email, String password, String role, BuildContext context) async {
    _setLoading(true);

    try {
      // Pass role to API Service
      final response = await _apiService.login(email, password, role);
      
      // 1. Save Token
      final token = response['token'];




      if (token != null) {
        await TokenStorage.saveToken(token); 
        
        final prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_role', role);
             }

      // 2. Save User Details
      if (response['user'] != null && response['user'] is Map) {
         final user = response['user'];
         debugPrint("Login Response User Keys: ${user.keys.toList()}"); // DEBUG
         
         if (user.containsKey('name')) {
             await TokenStorage.saveUserName(user['name']);
         }
         if (user.containsKey('email')) {
             await TokenStorage.saveUserEmail(user['email']);
         }
         // Save ID (check both 'id' and '_id')
         if (user.containsKey('id')) {
             await TokenStorage.saveUserId(user['id']);
         } else if (user.containsKey('_id')) {
             await TokenStorage.saveUserId(user['_id']);
         } else {
             debugPrint("WARNING: User ID not found in response!");
         }
      }

      _setLoading(false);
      return true; // Login Successful

    } catch (e) {
      _setLoading(false);
      _showErrorDialog(context, e.toString());
      return false; // Login Failed
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _showErrorDialog(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  
  Future<void> logout() async {
    final token = await TokenStorage.getToken();
    if (token != null) {
      // Fire and forget - don't wait for server response
      _apiService.logout(token).ignore(); 
    }
    await TokenStorage.clearToken();
    notifyListeners();
  }
}