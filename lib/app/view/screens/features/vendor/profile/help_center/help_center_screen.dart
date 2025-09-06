import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../utils/app_colors/app_colors.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  List<types.Message> messages = [];
  final _user = const types.User(id: 'user_1', firstName: "Me");

  @override
  void initState() {
    super.initState();
    // _loadMessages();
  }

  /// ✅ Add new text message to chat
  void _addMessage(types.Message message) {
    setState(() {
      messages.insert(0, message);
    });
  }

  /// ✅ Handle sending text messages only
  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: const Uuid().v4(),
      text: message.text,
    );

    _addMessage(textMessage);
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.white,
        title: Row(
          children: [
            const CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=3'),
            ),
            const SizedBox(width: 8),
            const Text('Online'),
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),

      ),

      body: Chat(
        messages: messages,
        onSendPressed: _handleSendPressed,
        showUserAvatars: true,
        showUserNames: true,
        user: _user,
        theme: const DefaultChatTheme(
          inputBackgroundColor: AppColors.brightCyan,
          inputTextColor: Colors.black,
          primaryColor: AppColors.brightCyan,
          secondaryColor: AppColors.borderColor,
        ),
      ),
    );
  }
}
