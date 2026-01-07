import 'package:crm_app/core/services/api_service.dart';
import 'package:crm_app/core/utils/token_storage.dart';
import 'package:crm_app/features/user/enquiries/models/enquiry_model.dart';
import 'package:flutter/material.dart';

class DashboardProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Map<String, dynamic>? _dashboardSummary;
  Map<String, dynamic>? get dashboardSummary => _dashboardSummary;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _userName = 'User';
  String get userName => _userName;

  List<Enquiry> _enquiries = [];
  List<Enquiry> get enquiries => _enquiries;

  Future<void> fetchDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Get the authentication token
      final token = await TokenStorage.getToken();
      final name = await TokenStorage.getUserName();
      _userName = name ?? 'User';
      
      if (token == null) {
        throw Exception('Authentication token not found. Please log in again.');
      }

      // 2. Call the API service
      final summary = await _apiService.getDashboardCounts(token);
  
      _dashboardSummary = summary;

      // 3. Fetch Enquiries (Limit 5 for Dashboard)
      final enquiriesData = await _apiService.fetchEnquiries(token, limit: 5);
      _enquiries = enquiriesData.map((e) => Enquiry.fromJson(e)).toList();
      
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}