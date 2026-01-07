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
  
}