import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A89F5),
        elevation: 0,
        title: const Text('Settings',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Notifications'),
            _buildSettingsCard(
              child: _buildSwitchTile(
                title: 'Push Notifications',
                subtitle: 'Receive push notifications',
                value: _pushNotifications,
                onChanged: (val) => setState(() => _pushNotifications = val),
              ),
            ),
            const SizedBox(height: 8),
            _buildSettingsCard(
              child: _buildSwitchTile(
                title: 'Email Notifications',
                subtitle: 'Receive email updates',
                value: _emailNotifications,
                onChanged: (val) => setState(() => _emailNotifications = val),
              ),
            ),
            _buildSectionHeader('Appearance'),
            _buildSettingsCard(
              child: _buildSwitchTile(
                title: 'Dark Mode',
                subtitle: 'Enable dark theme',
                value: _darkMode,
                onChanged: (val) => setState(() => _darkMode = val),
              ),
            ),
            _buildSectionHeader('Account'),
            // MODIFIED: Each item is now in its own separate card.
            _buildSettingsCard(
              child: _buildNavigationTile(
                  title: 'Change Password', subtitle: 'Update your password'),
            ),
            const SizedBox(height: 8),
            _buildSettingsCard(
              child: _buildNavigationTile(
                  title: 'Privacy Policy', subtitle: 'Read our privacy policy'),
            ),
            const SizedBox(height: 8),
            _buildSettingsCard(
              child: _buildNavigationTile(
                  title: 'Terms of Service',
                  subtitle: 'Read terms and conditions'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0, left: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // MODIFIED: Simplified to take a single child widget.
  Widget _buildSettingsCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: child, // The child (e.g., ListTile) is placed directly inside.
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF4A89F5),
      ),
    );
  }

  Widget _buildNavigationTile(
      {required String title, required String subtitle}) {
    return ListTile(
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}