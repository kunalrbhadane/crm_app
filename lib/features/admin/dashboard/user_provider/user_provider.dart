import 'package:crm_app/core/models/user_model.dart';
import 'package:crm_app/core/services/api_service.dart';
import 'package:flutter/material.dart';


class UserProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<UserModel> _users = [];
  UserSummary _summary = UserSummary(totalUsers: 0, activeUsers: 0);
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;

  List<UserModel> get users => _users;
  UserSummary get summary => _summary;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMoreData => _currentPage < _totalPages;

  Future<void> fetchUsers({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _users.clear(); // Clear list on refresh
      _isLoading = true;
    } else {
      _isLoading = true;
    }
    _error = null;
    notifyListeners();

    await _loadData(page: 1);
  }

  // 2. Load Next Page
  Future<void> loadMoreUsers() async {
    if (_isLoadingMore || !hasMoreData) return;

    _isLoadingMore = true;
    notifyListeners();

    await _loadData(page: _currentPage + 1);
  }

  // Internal helper to call API
  Future<void> _loadData({required int page}) async {
    try {
      final response = await _apiService.getAllUsers(page: page, limit: 10);
      
      // Parse Data
      final List<dynamic> userList = response['data'];
      final newUsers = userList.map((json) => UserModel.fromJson(json)).toList();

      // Parse Pagination
      if (response['pagination'] != null) {
        final pagination = PaginationModel.fromJson(response['pagination']);
        _currentPage = pagination.currentPage;
        _totalPages = pagination.totalPages;
      }

      // Parse Summary (Update it)
      if (response['summary'] != null) {
        _summary = UserSummary.fromJson(response['summary']);
      }

      // Add to list
      if (page == 1) {
        _users = newUsers;
      } else {
        _users.addAll(newUsers);
      }

    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  


  Future<bool> addUser(String name, String email, String password, BuildContext context) async {
    // We can use a local loading state variable inside the dialog, 
    // or use a separate isLoadingAction variable in provider to avoid full screen refresh.
    // Here I will just return success/fail and let the dialog handle the loading UI.
    
    try {
      await _apiService.createUser(name, email, password);
      
      // Success!
      _showSnack(context, "User created successfully", isError: false);
      
      // Refresh the list to show the new user
      fetchUsers(isRefresh: true); 
      
      return true;
    } catch (e) {
      _showSnack(context, e.toString(), isError: true);
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



    final Set<String> _deletingUserIds = {};
    bool isDeleting(String userId) => _deletingUserIds.contains(userId);


   Future<bool> deleteUser(String userId, BuildContext context) async {

     _deletingUserIds.add(userId);
    notifyListeners();

    try {
      await _apiService.deleteUser(userId);
      
      // 2. Remove from local list immediately
      _users.removeWhere((user) => user.id == userId);
      
      // Update summary counts
      if (_summary.totalUsers > 0) {
        _summary = UserSummary(
          totalUsers: _summary.totalUsers - 1, 
          activeUsers: _summary.activeUsers // Update this logic if needed
        );
      }
      
      _showSnack(context, "User deleted successfully", isError: false);
      return true;

    } catch (e) {
      _showSnack(context, e.toString(), isError: true);
      return false;

    } finally {
      // 3. Stop Loading for this specific ID
      _deletingUserIds.remove(userId);
      notifyListeners();
    }
  }




  Future<bool> updateUser(String userId, String name, String email, BuildContext context) async {
    try {
      final response = await _apiService.updateUser(userId, name, email);
      
      // Update local list directly
      final int index = _users.indexWhere((user) => user.id == userId);
      
      if (index != -1) {
        // We use the data returned from API to ensure we match the server
        final updatedData = response['data'];
        
        if (updatedData != null) {
          // Construct new model from response
          _users[index] = UserModel(
            id: updatedData['_id'] ?? userId,
            name: updatedData['name'] ?? name,
            email: updatedData['email'] ?? email,
            role: updatedData['role'] ?? _users[index].role,
            isActive: updatedData['isActive'] ?? _users[index].isActive,
            createdAt: updatedData['createdAt'] ?? _users[index].createdAt,
          );
        } else {
          // Fallback: If 'data' is null in response, update manually with input
           _users[index] = UserModel(
            id: userId,
            name: name,
            email: email,
            role: _users[index].role,
            isActive: _users[index].isActive,
            createdAt: _users[index].createdAt,
          );
        }
        
        notifyListeners(); // Refresh UI
      }
      
      _showSnack(context, "User updated successfully", isError: false);
      return true;
    } catch (e) {
      _showSnack(context, "Update Failed: $e", isError: true);
      return false;
    }
  }

 
  final Set<String> _togglingUserIds = {};

  bool isToggling(String userId) => _togglingUserIds.contains(userId);

  // NEW: Toggle Status Method
  Future<void> toggleUserStatus(String userId, BuildContext context) async {
    // 1. Set Loading
    _togglingUserIds.add(userId);
    notifyListeners();

    try {
      final response = await _apiService.toggleUserStatus(userId);
      
      // 2. Update Local User Data
      final int index = _users.indexWhere((user) => user.id == userId);
      if (index != -1) {
        final newStatus = response['data']['isActive'];
        
        // Update the user object in list
        // We copy the existing user but change only isActive
        _users[index] = UserModel(
          id: _users[index].id,
          name: _users[index].name,
          email: _users[index].email,
          role: _users[index].role,
          isActive: newStatus, // <--- Updated status
          createdAt: _users[index].createdAt,
        );

        // 3. Update Summary Count (Active Users)
        int currentActive = _summary.activeUsers;
        if (newStatus == true) {
          currentActive++; // Inactive -> Active
        } else {
          currentActive--; // Active -> Inactive
        }
        
        _summary = UserSummary(
          totalUsers: _summary.totalUsers, 
          activeUsers: currentActive
        );
      }

      _showSnack(context, response['message'] ?? "Status updated", isError: false);

    } catch (e) {
      _showSnack(context, e.toString(), isError: true);
    } finally {
      // 4. Stop Loading
      _togglingUserIds.remove(userId);
      notifyListeners();
    }
  }


}


