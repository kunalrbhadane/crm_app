import 'dart:convert';
import 'package:crm_app/core/utils/token_storage.dart';
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

}