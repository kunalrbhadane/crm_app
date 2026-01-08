import 'package:crm_app/core/services/api_service.dart';
import 'package:crm_app/core/utils/token_storage.dart';
import 'package:crm_app/features/user/enquiries/models/enquiry_model.dart';
import 'package:flutter/material.dart';

class EnquiriProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Enquiry> _enquiries = [];
  List<Enquiry> get enquiries => _enquiries;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isMoreLoading = false;
  bool get isMoreLoading => _isMoreLoading;

  int _page = 1;
  final int _limit = 10;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Initial Fetch (Pull to Refresh calls this)
  Future<void> fetchEnquiries({bool refresh = false, String filter = ''}) async {
    if (refresh) {
      _page = 1;
      _hasMore = true;
      _enquiries.clear();
      _isLoading = true;
    } else {
       // If no more data or already loading more, ignore
       if (!_hasMore || _isMoreLoading) return;
       _isMoreLoading = true;
    }
    
    notifyListeners();

    try {
      final token = await TokenStorage.getToken();
      if (token == null) throw Exception("Token not found");

      final newEnquiriesData = await _apiService.fetchEnquiries(
        token, 
        page: _page, 
        limit: _limit,
        filter: filter // Pass the filter here
      );
      
      final newEnquiries = newEnquiriesData.map((e) => Enquiry.fromJson(e)).toList();

      if (newEnquiries.length < _limit) {
        _hasMore = false;
      }

      _enquiries.addAll(newEnquiries);
      _page++;
      _errorMessage = null;

    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      _isMoreLoading = false;
      notifyListeners();
    }
  }

  Future<void> createEnquiry(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final token = await TokenStorage.getToken();
      if (token == null) throw Exception("Token not found");
      
      await _apiService.createEnquiry(token, data);
      
      // Refresh list after successful creation
      await fetchEnquiries(refresh: true);
      
    } catch (e) {
      // Propagate error to UI
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
