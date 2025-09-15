import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/features/client/chat/controllers/chat_controller.dart';
import 'package:local/app/view/screens/features/client/chat/inbox/chat_screen/widgets/chat_header.dart';
import 'inbox/chat_screen/widgets/chat_body.dart';
import 'inbox/chat_screen/widgets/typing_indicator.dart';

class ChatScreen extends StatelessWidget {
  final String conversationId;
  final String userId;
  final String receiverRole;
  final String receiverName;
  final String receiverImage;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.userId,
    required this.receiverRole,
    required this.receiverName,
    required this.receiverImage,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ChatController>(tag: conversationId)
        ? Get.find<ChatController>(tag: conversationId)
        : Get.put(
            ChatController(conversationId: conversationId, userId: userId),
            tag: conversationId);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ChatHeader(
        receiverName: receiverName,
        receiverImage: receiverImage,
        onBack: () => context.pop(),
        onMore: () {}, // TODO: implement
      ),
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                AppColors.brightCyan.withOpacity(.03),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              const Divider(height: 1),
              Expanded(
                child: ChatBody(controller: controller, receiverImage: receiverImage),
              ),
              Obx(() => TypingIndicator(visible: controller.isTyping.value)),
            ],
          ),
        ),
      ),
    );
  }
}
