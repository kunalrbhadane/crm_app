import 'dart:convert';
import 'dart:io';
import 'package:crm_app/core/utils/token_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  final String? baseUrl = dotenv.env['BASE_URL'];

  Future<Map<String, dynamic>> login(String email, String password, String role) async {
    // 1. Determine Endpoint based on Role
    String endpoint;
    if (role == 'Admin') {
      endpoint = '/auth/admin/login';
    } else {
      // Assuming the user endpoint follows the same pattern. 
      // If it is just '/auth/login', change this line.
      endpoint = '/auth/user/login'; 
    }

    final url = Uri.parse('$baseUrl$endpoint');
    
    try {
      

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      // 2. Handle Responses
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Login failed');
        }
      } else {
        // Handle 400, 401, 404 errors
        throw Exception(data['message'] ?? 'Error: ${response.statusCode}');
      }
    } catch (e) {
      // Clean up error message
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }

  Future<Map<String, dynamic>> getuserDashboardCounts(String token) async {
    final url = Uri.parse('$baseUrl/enquiries/dashboard-count');
    
    try {
      // Debug print

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Protected routes require a token
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == true && data['summary'] != null) {
          // Return only the summary object for the provider to use
          return data['summary'];
        } else {
          throw Exception(data['message'] ?? 'Failed to get dashboard summary');
        }
      } else {
        throw Exception(data['message'] ?? 'Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }

  Future<List<dynamic>> fetchEnquiries(String token, {String filter = '', int page = 1, int limit = 10}) async {
    final url = Uri.parse('$baseUrl/enquiries/contact-enquiries?${filter.isNotEmpty ? 'filter=$filter&' : ''}page=$page&limit=$limit');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == true && data['data'] != null) {
          return data['data'];
        } else {
          return [];
        }
      } else {
        throw Exception(data['message'] ?? 'Error fetching enquiries');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }
  
  Future<void> createEnquiry(String token, Map<String, dynamic> enquiryData) async {
    final url = Uri.parse('$baseUrl/enquiries/contact-enquiries');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(enquiryData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode != 201 && response.statusCode != 200) {
        throw Exception(data['message'] ?? 'Failed to create enquiry');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }
//...................................................
   
   Future<Map<String, dynamic>> getAllUsers({int page = 1 , int limit = 10}) async {
    final url = Uri.parse('$baseUrl/users?page=$page&limit=$limit');
    
    // 1. Get the saved token
    final token = await TokenStorage.getToken();
    if (token == null) {
      throw Exception('No authentication token found');
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Attach Token
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch users');
        }
      } else {
        throw Exception(data['message'] ?? 'Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }



Future<Map<String, dynamic>> createUser(String name, String email, String password) async {
    final url = Uri.parse('$baseUrl/users/');
    final token = await TokenStorage.getToken();
    
    if (token == null) throw Exception('No authentication token found');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Failed to create user');
        }
      } else {
        throw Exception(data['message'] ?? 'Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }




   Future<void> deleteUser(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    final token = await TokenStorage.getToken();
    
    if (token == null) throw Exception('No authentication token found');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == true) {
          return; // Success
        } else {
          throw Exception(data['message'] ?? 'Failed to delete user');
        }
      } else {
        throw Exception(data['message'] ?? 'Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }


   Future<Map<String, dynamic>> updateUser(String userId, String name, String email) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    final token = await TokenStorage.getToken();
    
    if (token == null) throw Exception('No authentication token found');


    try {
      final response = await http.patch( 
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
        }),
      );



      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Failed to update user');
        }
      } else {
        throw Exception(data['message'] ?? 'Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }

   Future<Map<String, dynamic>> updateUserProfile(String name, String email) async {
    final url = Uri.parse('$baseUrl/auth/user/profile');
    final token = await TokenStorage.getToken();
    
    if (token == null) throw Exception('No authentication token found');

    try {
      final response = await http.patch( 
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Failed to update profile');
        }
      } else {
        throw Exception(data['message'] ?? 'Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }



   Future<Map<String, dynamic>> toggleUserStatus(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId/toggle-status');
    final token = await TokenStorage.getToken();
    
    if (token == null) throw Exception('No authentication token found');

    try {
      
      final response = await http.patch( 
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Failed to update status');
        }
      } else {
        throw Exception(data['message'] ?? 'Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }




   Future<Map<String, dynamic>> getEnquiries({
    int page = 1,
    String dateFilter = 'all',   // 'today', 'week', 'month', 'all'
    String? enquiryType,         // 'student', 'client', 'other' (nullable)
    String? status,
  }) async {
    // Build Query String
    String queryString = 'page=$page&limit=10&dateFilter=$dateFilter';
    
    if (enquiryType != null && enquiryType != 'All Types') {
      queryString += '&enquiryType=${enquiryType.toLowerCase()}';
    }
    // If your API supports status filter:
    if (status != null && status != 'All') {
      queryString += '&status=$status';
    }

    final url = Uri.parse('$baseUrl/enquiries/contact-enquiries?$queryString');
    
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception('No token found');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch enquiries');
        }
      } else {
        throw Exception(data['message'] ?? 'Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }




  
  
  // NEW: Get Dashboard Counts
  Future<Map<String, dynamic>> getDashboardCounts({
    String dateFilter = 'all',
    String? enquiryType,
    String? status,
  }) async {
    // Build Query String (Same logic as getEnquiries)
    String queryString = 'dateFilter=$dateFilter';
    
    if (enquiryType != null && enquiryType != 'All Types') {
      queryString += '&enquiryType=${enquiryType.toLowerCase()}';
    }
    if (status != null && status != 'All') {
      queryString += '&status=$status';
    }

    final url = Uri.parse('$baseUrl/enquiries/dashboard-count?$queryString');
    
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception('No token found');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch counts');
        }
      } else {
        throw Exception(data['message'] ?? 'Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }
  Future<void> logout(String token) async {
    final url = Uri.parse('$baseUrl/auth/logout');
    try {
      await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
    } catch (e) {
      // Log error but verify client logout proceeds
    }
  }

  Future<void> uploadFile(File file) async {
    final url = Uri.parse('$baseUrl/files/upload');
    final token = await TokenStorage.getToken();
    if (token == null) throw Exception('No authentication token found');

    var request = http.MultipartRequest('POST', url);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    
    String? mediaType;
    if (file.path.toLowerCase().endsWith('.xlsx')) {
      mediaType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    } else if (file.path.toLowerCase().endsWith('.xls')) {
      mediaType = 'application/vnd.ms-excel';
    } else if (file.path.toLowerCase().endsWith('.csv')) {
      mediaType = 'text/csv';
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        contentType: mediaType != null ? MediaType.parse(mediaType) : null,
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data['success'] == true) {
          return;
        } else {
           throw Exception(data['message'] ?? 'File upload failed');
        }
      } else {
        throw Exception(data['message'] ?? 'Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception:', '').trim());
    }
  }

}