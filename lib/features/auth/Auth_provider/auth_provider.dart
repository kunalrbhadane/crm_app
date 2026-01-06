
import 'package:crm_app/core/services/api_service.dart';
import 'package:crm_app/core/utils/token_storage.dart';
import 'package:flutter/material.dart';


class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password, BuildContext context) async {
    _setLoading(true);

    try {
      final response = await _apiService.login(email, password);
      
      // 1. Save Token
      final token = response['token'];
      if (token != null) {
        await TokenStorage.saveToken(token);
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