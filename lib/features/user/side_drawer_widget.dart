import 'package:flutter/material.dart';

class SideDrawerWidget extends StatelessWidget {
  const SideDrawerWidget({super.key});

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
          _buildDrawerItem(
            icon: Icons.home_outlined,
            text: 'Home',
            onTap: () => Navigator.of(context).pop(),
          ),
          _buildDrawerItem(
            icon: Icons.list_alt_outlined,
            text: 'My Enquiries',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.add_circle_outline,
            text: 'New Enquiry',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.history,
            text: 'History',
            onTap: () {},
          ),
          _buildDrawerItem(
            icon: Icons.message_outlined,
            text: 'Messages',
            onTap: () {},
          ),
           _buildDrawerItem(
            icon: Icons.file_upload_outlined,
            text: 'File Upload',
            onTap: () {},
          ),
           _buildDrawerItem(
            icon: Icons.settings_outlined,
            text: 'Settings',
            onTap: () {},
          ),
          const Divider(thickness: 1, indent: 16, endIndent: 16),
           _buildDrawerItem(
            icon: Icons.help_outline,
            text: 'Help & Support',
            onTap: () {},
          ),
           _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            color: Colors.red, 
            onTap: () {},
          ),
        ],
      ),
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