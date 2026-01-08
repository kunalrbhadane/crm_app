import 'dart:async';
import 'package:crm_app/features/admin/dashboard/screens/dashboard.dart';
import 'package:crm_app/features/auth/role_selection/screens/role_selection_screen.dart';
import 'package:crm_app/features/user/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Artificial delay for branding (2 seconds)
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');
    
    // We need to decode the token to find the role. 
    // Ideally, you saved the role separately during login.
    // If not, we extract it from the JWT.
    
    if (token != null && token.isNotEmpty) {
      bool isExpired = JwtDecoder.isExpired(token);

      if (!isExpired) {
        // Token is valid, get the role
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        
        // Adjust key based on your backend JWT structure (usually 'role' or 'user' -> 'role')
        String role = decodedToken['role'] ?? 'USER'; 
        
        // Navigate based on Role
        if (role == 'ADMIN') {
          _navigateTo(const EnquiriesDashboardScreen());
        } else {
          _navigateTo(const UserNavigation());
        }
      } else {
        // Token Expired
        await prefs.clear(); // Clear old data
        _navigateTo(const RoleSelectionScreen());
      }
    } else {
      // No Token Found
      _navigateTo(const RoleSelectionScreen());
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1976D2), // Brand Blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Container
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: const Icon(
                Icons.grid_view_rounded,
                size: 50,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Enquiry CRM",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            const SizedBox(
              width: 20, 
              height: 20, 
              child: CircularProgressIndicator(
                color: Colors.white, 
                strokeWidth: 2,
              )
            ),
          ],
        ),
      ),
    );
  }
}