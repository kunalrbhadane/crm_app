import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
      print("Logging in to: $url"); // Debug print

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

  Future<Map<String, dynamic>> getDashboardCounts(String token) async {
    final url = Uri.parse('$baseUrl/enquiries/dashboard-count');
    
    try {
      print("Fetching dashboard counts from: $url"); // Debug print

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


  
  
  Future<List<dynamic>> fetchEnquiries(String token, {String filter = 'week', int page = 1, int limit = 10}) async {
    final url = Uri.parse('$baseUrl/enquiries/contact-enquiries?filter=$filter&page=$page&limit=$limit');
    try {
      print("Fetching enquiries from: $url");
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
      print("Logout API error: $e");
    }
  }
}