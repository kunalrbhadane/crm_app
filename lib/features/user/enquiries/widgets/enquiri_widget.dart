import 'package:flutter/material.dart';

class EnquiriesHeaderWidget extends StatelessWidget implements PreferredSizeWidget {
  const EnquiriesHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF4A89F5),
      elevation: 0,
      title: const Text(
        'My Enquiries',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white, size: 28),
        onPressed: () {
          // This will open the drawer from the main UserNavigation Scaffold.
          Scaffold.of(context).openDrawer();
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// ... The EnquiryItemWidget remains unchanged
class EnquiryItemWidget extends StatelessWidget {
  final String title;
  final String id;
  final String date;
  final String status;

  const EnquiryItemWidget({
    super.key,
    required this.title,
    required this.id,
    required this.date,
    required this.status,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'resolved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'closed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Color(0xFFE3F2FD),
            child: Icon(Icons.description_outlined, color: Color(0xFF4A89F5)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ID: $id',
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: _getStatusColor().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: _getStatusColor(),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}