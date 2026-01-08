import 'package:crm_app/core/models/enquiry_model.dart';
import 'package:crm_app/core/models/enquiry_summary_model.dart';
import 'package:crm_app/core/services/api_service.dart';
import 'package:flutter/material.dart';
 

class EnquiryProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<EnquiryModel> _enquiries = [];
  EnquirySummaryModel _summary = EnquirySummaryModel(); // Default 0s

  // Filters
  String _selectedDateFilter = 'today'; // Default
  String _selectedEnquiryType = 'All Types';
  String _selectedStatus = 'All';

  // Pagination
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  // Getters
  List<EnquiryModel> get enquiries => _enquiries;
  EnquirySummaryModel get summary => _summary; // Expose summary
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMoreData => _currentPage < _totalPages;
  
  // Filter Getters
  String get currentDateFilter => _selectedDateFilter;
  String get currentEnquiryType => _selectedEnquiryType;

  // --- ACTIONS ---

  void setDateFilter(String uiLabel) {
    String apiValue = 'all';
    if (uiLabel == 'Today') apiValue = 'today';
    else if (uiLabel == 'This Week') apiValue = 'week';
    else if (uiLabel == 'This Month') apiValue = 'month';
    
    _selectedDateFilter = apiValue;
    fetchData(isRefresh: true);
  }

  void setEnquiryType(String type) {
    _selectedEnquiryType = type;
    fetchData(isRefresh: true);
  }

  // Unified Fetch Method
  Future<void> fetchData({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _enquiries.clear();
    } else {
      _isLoading = true;
    }
    _error = null;
    notifyListeners();

    try {
      // 1. Prepare Arguments
      final dateFilter = _selectedDateFilter;
      final typeFilter = _selectedEnquiryType == 'All Types' ? null : _selectedEnquiryType;
      final statusFilter = _selectedStatus == 'All' ? null : _selectedStatus;

      // 2. Call APIs in Parallel (List + Counts)
      // We perform both calls so the counters update when filters change
      final results = await Future.wait([
        _apiService.getEnquiries(
          page: _currentPage,
          dateFilter: dateFilter,
          enquiryType: typeFilter,
          status: statusFilter,
        ),
        _apiService.getDashboardCounts(
          dateFilter: dateFilter,
          enquiryType: typeFilter,
          status: statusFilter,
        )
      ]);

      // 3. Handle List Response (results[0])
      final listData = results[0];
      final List<dynamic> list = listData['data'];
      final newItems = list.map((json) => EnquiryModel.fromJson(json)).toList();

      if (listData['pagination'] != null) {
        final pag = EnquiryPagination.fromJson(listData['pagination']);
        _currentPage = pag.currentPage;
        _totalPages = pag.totalPages;
      }

      if (_currentPage == 1) {
        _enquiries = newItems;
      } else {
        _enquiries.addAll(newItems);
      }

      // 4. Handle Count Response (results[1])
      final countData = results[1];
      if (countData['summary'] != null) {
        _summary = EnquirySummaryModel.fromJson(countData['summary']);
      }

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // Load More (Pagination only needs list, but keeping logic simple)
  Future<void> loadMore() async {
    if (_isLoadingMore || !hasMoreData) return;
    _isLoadingMore = true;
    notifyListeners();
    _currentPage++;
    
    // For pagination, we technically only need getEnquiries, 
    // but calling fetchData reutilizes the logic. 
    // To optimize, you could split them, but this is cleaner for now.
    await fetchData(isRefresh: false); 
  }
}