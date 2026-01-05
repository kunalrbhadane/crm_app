import 'package:crm_app/features/auth/role_selection/screens/role_selection_screen.dart';
import 'package:crm_app/features/user/dashboard/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard UI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'sans-serif',
      ),
      home: RoleSelectionScreen(),
    );
  }
}

   
      home: const DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
