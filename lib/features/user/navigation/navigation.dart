import 'package:crm_app/features/user/dashboard/screens/dashboard_screen.dart';
import 'package:crm_app/features/user/enquiries/screens/enquiri_screen.dart';
import 'package:crm_app/features/user/messages/screens/messages_screen.dart';
import 'package:crm_app/features/user/profile/screens/profile_screen.dart';
import 'package:crm_app/features/user/side_drawer_widget.dart';
import 'package:flutter/material.dart';

// Import the header widgets to be used as AppBars
import 'package:crm_app/features/user/dashboard/widgets/dashboardwidget.dart'; // MODIFIED: Import added
import 'package:crm_app/features/user/enquiries/widgets/enquiri_widget.dart';
import 'package:crm_app/features/user/messages/widgets/messages_widgets.dart';
import 'package:crm_app/features/user/profile/widgets/profile_widget.dart';

class UserNavigation extends StatefulWidget {
  const UserNavigation({super.key});

  @override
  State<UserNavigation> createState() => _UserNavigationState();
}

class _UserNavigationState extends State<UserNavigation> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const DashboardScreen(),
    const EnquiriScreen(),
    MessagesScreen(),
    const ProfileScreen(),
  ];

  // MODIFIED: Replaced 'null' with a new DashboardHeaderWidget for consistency.
  static final List<PreferredSizeWidget?> _appBars = <PreferredSizeWidget?>[
    const DashboardHeaderWidget(),
    const EnquiriesHeaderWidget(),
    const MessagesHeaderWidget(),
    const profileHearder(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars.elementAt(_selectedIndex),
      drawer: const SideDrawerWidget(),
      body: Center(
        child: _screens.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: _buildRoundedNavigationBar(),
    );
  }

  Widget _buildRoundedNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(Icons.list_alt),
              label: 'Enquiries',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xFF4A89F5),
          unselectedItemColor: Colors.grey.shade600,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
      ),
    );
  }
}