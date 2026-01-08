import 'package:crm_app/core/providers/navigation_provider.dart';
import 'package:crm_app/core/theme/app_theme.dart';
import 'package:crm_app/features/admin/dashboard/enquiry_provider/enquiry_provider.dart';
import 'package:crm_app/features/admin/dashboard/user_provider/user_provider.dart';
import 'package:crm_app/features/auth/Auth_provider/auth_provider.dart';
import 'package:crm_app/features/splash_screen/splash_screen.dart';
import 'package:crm_app/features/user/dashboard/provider/dashboard_provider.dart';
import 'package:crm_app/features/user/enquiries/provider/enquiri_provider.dart';
import 'package:crm_app/features/user/profile/profile_provider/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => EnquiriProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
         ChangeNotifierProvider(create: (_) => UserProvider()),
         ChangeNotifierProvider(create: (_) => EnquiryProvider()),
         ChangeNotifierProvider(create: (_) => ProfileProvider()),

      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
     
      home: const SplashScreen(), 
    );
  }
}