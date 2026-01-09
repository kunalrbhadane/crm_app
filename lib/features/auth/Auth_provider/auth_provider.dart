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

      // 2. Save User Details (Optional but recommended)
      if (response['user'] != null) {
        // You can create a method in TokenStorage to save user name/role
        // await TokenStorage.saveUserData(jsonEncode(response['user']));
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
    await TokenStorage.clearToken();
    notifyListeners();
  }



  
}