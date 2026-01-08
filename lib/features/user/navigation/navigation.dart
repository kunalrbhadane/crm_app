import 'package:crm_app/core/providers/navigation_provider.dart';
import 'package:crm_app/features/user/dashboard/screens/dashboard_screen.dart';
import 'package:crm_app/features/user/dashboard/widgets/dashboardwidget.dart';
import 'package:crm_app/features/user/enquiries/screens/enquiri_screen.dart';
import 'package:crm_app/features/user/enquiries/widgets/enquiri_widget.dart';
import 'package:crm_app/features/user/messages/screens/messages_screen.dart';
import 'package:crm_app/features/user/messages/widgets/messages_widgets.dart';
import 'package:crm_app/features/user/profile/screens/profile_screen.dart';
import 'package:crm_app/features/user/profile/widgets/profile_widget.dart';
import 'package:crm_app/features/user/side_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class UserNavigation extends StatelessWidget {
  const UserNavigation({super.key});

  static final List<Widget> _screens = <Widget>[
    const DashboardScreen(),
    const EnquiriScreen(),
    MessagesScreen(),
    const ProfileScreen(),
  ];

  static final List<PreferredSizeWidget?> _appBars = <PreferredSizeWidget?>[
    const DashboardHeaderWidget(),
    const EnquiriesHeaderWidget(),
    const MessagesHeaderWidget(),
    const profileHearder(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          appBar: _appBars.elementAt(provider.currentIndex),
          drawer: SideDrawerWidget(
            onNavItemTapped: (index) {
              provider.setIndex(index);
              Navigator.of(context).pop();
            },
          ),
          body: Center(
            child: _screens.elementAt(provider.currentIndex),
          ),
          bottomNavigationBar: _buildRoundedNavigationBar(context, provider.currentIndex),
        );
      },
    );
  }

  Widget _buildRoundedNavigationBar(BuildContext context, int currentIndex) {
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
          currentIndex: currentIndex,
          onTap: (index) {
            Provider.of<NavigationProvider>(context, listen: false).setIndex(index);
          },
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