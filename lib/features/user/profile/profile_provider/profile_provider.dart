import 'package:crm_app/core/services/api_service.dart';
import 'package:crm_app/core/utils/token_storage.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> updateProfile(String name, String email, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = await TokenStorage.getUserId();
      if (userId == null) {
        throw Exception("User ID not found. Please logout and login again.");
      }

      await _apiService.updateUser(userId, name, email);

      // Update Local Storage
      await TokenStorage.saveUserName(name);
      await TokenStorage.saveUserEmail(email);

      _showSnack(context, "Profile updated successfully.", isError: false);
      _isLoading = false;
      notifyListeners();
      return true;

    } catch (e) {
      _showSnack(context, e.toString(), isError: true);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void _showSnack(BuildContext context, String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
