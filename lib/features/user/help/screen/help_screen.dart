import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A89F5),
        elevation: 0,
        title: const Text('Help & Support', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            _buildHeader(),
            const SizedBox(height: 6),

            _buildSectionHeader('Contact Us'),
            _buildContactCard(
              icon: Icons.email_outlined,
              title: 'Email',
              subtitle: 'support@example.com',
            ),
            _buildContactCard(
              icon: Icons.phone_outlined,
              title: 'Phone',
              subtitle: '+1 (555) 123-4567',
            ),
            _buildContactCard(
              icon: Icons.chat_bubble_outline,
              title: 'Live Chat',
              subtitle: 'Start a conversation',
            ),
            const SizedBox(height: 4),
            _buildSectionHeader('FAQs'),
            _buildFaqCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: const Color(0xFFE3F2FD),
            child: Icon(Icons.headset_mic_outlined,
                size: 36, color: const Color(0xFF4A89F5)),
          ),
          const SizedBox(height: 10),
          const Text(
            "We're here to help!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Get in touch with our support team',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }


  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0, left: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
      ),
    );
  }


  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE3F2FD),
          child: Icon(icon, color: const Color(0xFF4A89F5)),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.grey)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {},
      ),
    );
  }

  Widget _buildFaqCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          _buildExpansionTile('How do I submit an enquiry?'),
          _buildExpansionTile('How long does it take to get a response?'),
          _buildExpansionTile('Can I track my enquiry status?'),
        ],
      ),
    );
  }
  Widget _buildExpansionTile(String title) {
    return ExpansionTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      children: const [
        Padding(
          padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: Text(
              'This is the answer to the frequently asked question. You can add more detailed information here to help your users.',
              style: TextStyle(color: Colors.grey, height: 1.5)),
        )
      ],
    );
  }
}