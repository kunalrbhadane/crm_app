import 'package:crm_app/features/user/enquiries/screens/new_enquiry_screen.dart';
import 'package:crm_app/features/user/help/screen/help_screen.dart';
import 'package:crm_app/features/user/settings/screen/settings_screen.dart';
import 'package:crm_app/features/auth/Auth_provider/auth_provider.dart';
import 'package:crm_app/features/auth/role_selection/screens/role_selection_screen.dart';
import 'package:crm_app/features/user/upload/file_upload.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SideDrawerWidget extends StatelessWidget {
  
  final ValueChanged<int> onNavItemTapped;

  const SideDrawerWidget({
    super.key,
    required this.onNavItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          // MODIFIED: Calls the callback for Home (index 0
          _buildDrawerItem(
            icon: Icons.home_outlined,
            text: 'Home',
            onTap: () => onNavItemTapped(0),
          ),
          
          _buildDrawerItem(
            icon: Icons.list_alt_outlined,
            text: 'My Enquiries',
            onTap: () => onNavItemTapped(1),
          ),
          // This item pushes a new screen, so its logic remains the same.
          _buildDrawerItem(
            icon: Icons.add_circle_outline,
            text: 'New Enquiry',
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NewEnquiryScreen()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.history,
            text: 'History',
            onTap: () {},
          ),

          _buildDrawerItem(
            icon: Icons.message_outlined,
            text: 'Messages',
            onTap: () => onNavItemTapped(2),
          ),
          _buildDrawerItem(
            icon: Icons.file_upload_outlined,
            text: 'File Upload',
            onTap: () {
              Navigator.of(context).pop(); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FileUploadScreen()),
              );}
          ),
          _buildDrawerItem(
            icon: Icons.settings_outlined,
            text: 'Settings',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const Divider(thickness: 1, indent: 16, endIndent: 16),
          _buildDrawerItem(
            icon: Icons.help_outline,
            text: 'Help & Support',
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
              );
            },
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            color: Colors.red,
            onTap: () {
              Navigator.of(context).pop();
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // --- Helper Methods (No changes below this line) ---

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          title: const Text('Logout',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: const Text('Logout', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog first

                // Call the logout method in provider
                await Provider.of<AuthProvider>(context, listen: false).logout();

                // Navigate to Role Selection Screen and remove all previous routes
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RoleSelectionScreen(),
                    ),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 60, 16, 24),
      decoration: const BoxDecoration(
        color: Color(0xFF4A89F5),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 40,
              color: Color(0xFF4A89F5),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'kunal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
    Color color = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }
}