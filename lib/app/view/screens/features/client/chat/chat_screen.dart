import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/screens/features/client/chat/controllers/chat_controller.dart';

class ChatScreen extends StatelessWidget {
  final String conversationId;
  final String userId;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    // Put controller to GetX dependency system
    final controller =
      Get.isRegistered<ChatController>(tag: conversationId)
        ? Get.find<ChatController>(tag: conversationId)
        : Get.put(ChatController(conversationId: conversationId, userId: userId), tag: conversationId);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        appBarBgColor: AppColors.white,
        appBarContent: "${conversationId}",
        iconData: Icons.arrow_back,
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Text( 'Conversation ID: $conversationId'),
            Text('User ID: $userId'),
            // Expanded chat area
            Expanded(
              child: Obx(() {
                final messages = controller.messages.toList();
                // If `user` is an Rx<T>, read .value; otherwise assume it's already the user object.
                final user = (controller.user is Rx)
                    ? (controller.user as Rx).value
                    : controller.user;

                return Chat(
                  messages: messages,
                  onSendPressed: controller.handleSendPressed,
                  showUserAvatars: true,
                  showUserNames: true,
                  user: user,
                  theme: const DefaultChatTheme(
                    inputBackgroundColor: AppColors.brightCyan,
                    inputTextColor: Colors.black,
                    primaryColor: AppColors.brightCyan,
                    secondaryColor: AppColors.borderColor,
                  ),
                );
              }),
            ),

            // Typing indicator UI (simple, shows when any remote user is typing)
            Obx(() {
              if (!controller.isTyping.value) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                color: Colors.transparent,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  children: const [
                    SizedBox(width: 8),
                    Text(
                      'Someone is typing...',
                      style: TextStyle(
                          fontStyle: FontStyle.italic, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
