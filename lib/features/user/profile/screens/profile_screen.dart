import 'package:crm_app/features/user/profile/widgets/profile_widget.dart';
import 'package:crm_app/features/user/profile/widgets/edit_profile_dialog.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/token_storage.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isDarkMode = false;
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final name = await TokenStorage.getUserName();
    final email = await TokenStorage.getUserEmail();
    setState(() {
      _userName = name;
      _userEmail = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    // MODIFIED: The Scaffold and AppBar are removed.
    return SingleChildScrollView(
      child: Column(
        children: [
          profileInfo(
            userName: _userName,
            userEmail: _userEmail,
          ),
          profileMenu(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () async {
              final result = await showDialog(
                context: context,
                builder: (context) => EditProfileDialog(
                  currentName: _userName ?? '',
                  currentEmail: _userEmail ?? '',
                ),
              );
              
              if (result == true) {
                _loadUserData();
              }
            },
          ),
          profileMenu(
            icon: Icons.lock_outline,
            title: 'Change Password',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          profileMenu(
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          profileMenu(
            icon: Icons.language_outlined,
            title: 'Language',
            trailing: const Text(
              'English',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            onTap: () {},
          ),
          profileMenu(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            trailing: Switch(
              value: _isDarkMode,
              onChanged: (value) {
                setState(() {
                  _isDarkMode = value;
                });
              },
              activeTrackColor: const Color(0xFF4A89F5).withOpacity(0.5),
              activeColor: const Color(0xFF4A89F5),
            ),
          ),
        ],
      ),
    );
  }
}