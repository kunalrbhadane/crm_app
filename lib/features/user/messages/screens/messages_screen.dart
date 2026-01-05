import 'package:flutter/material.dart';
import '../widgets/messages_widgets.dart';

class Message {
  final String sender;
  final String messagePreview;
  final String time;
  final IconData icon;
  final bool isUnread;

  Message({
    required this.sender,
    required this.messagePreview,
    required this.time,
    required this.icon,
    required this.isUnread,
  });
}

class MessagesScreen extends StatelessWidget {
  MessagesScreen({super.key});

  final List<Message> messages = [
    Message(
      sender: 'Support Team',
      messagePreview: 'Your enquiry has be...',
      time: '2 hours ago',
      icon: Icons.headset_mic_outlined,
      isUnread: true,
    ),
    Message(
      sender: 'Admin',
      messagePreview: 'Welcome to our platf...',
      time: '1 day ago',
      icon: Icons.shield_outlined,
      isUnread: false,
    ),
    Message(
      sender: 'Course Instructor',
      messagePreview: 'New lesson uploaded',
      time: '2 days ago',
      icon: Icons.school_outlined,
      isUnread: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // MODIFIED: The Scaffold and AppBar are removed.
    return Container(
      color: const Color(0xFFF4F7FC),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return MessageItemWidget(
            sender: message.sender,
            messagePreview: message.messagePreview,
            time: message.time,
            icon: message.icon,
            isUnread: message.isUnread,
          );
        },
      ),
    );
  }
}