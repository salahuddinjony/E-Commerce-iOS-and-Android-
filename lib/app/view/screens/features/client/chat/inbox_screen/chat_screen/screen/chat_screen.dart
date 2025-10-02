import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/features/client/chat/controllers/chat_controller.dart';
import 'package:local/app/view/screens/features/client/chat/inbox_screen/chat_screen/widgets/chat_header.dart';
import 'package:local/app/view/screens/features/client/chat/inbox_screen/chat_screen/widgets/make_an_offer.dart';
import '../widgets/chat_body.dart';
import '../widgets/typing_indicator.dart';

class ChatScreen extends StatelessWidget {
  final String conversationId;
  final String userId;
  final String receiverRole;
  final String receiverName;
  final String receiverImage;
  final String userRole;
  final String receiverId;
  final bool isVendor;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.userId,
    required this.receiverRole,
    required this.receiverId,
    required this.receiverName,
    required this.receiverImage,
    required this.userRole,
    required this.isVendor,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.isRegistered<ChatController>(tag: conversationId)
        ? Get.find<ChatController>(tag: conversationId)
        : Get.put(
            ChatController(
                conversationId: conversationId,
                userRole: userRole,
                userId: userId),
            tag: conversationId);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: ChatHeader(
        id: userId,
        receiverName: receiverName,
        receiverImage: receiverImage,
        isVendor: isVendor,
        onBack: () => context.pop(),
        onMore: () {
          if (isVendor)
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              isScrollControlled: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) {
                return MakeAnOffer(
                  controller: controller,
                  receiverImage: receiverImage,
                  receiverName: receiverName,
                  userId: userId,
                  receiverId: receiverId,
                );
              },
            );
          return;
        },
      ),
      body: SafeArea(
        bottom: false,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white,
                AppColors.brightCyan.withValues(alpha: .03),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              const Divider(height: 1),
              Expanded(
                child: ChatBody(
                    controller: controller, receiverImage: receiverImage),
              ),
              Obx(() => TypingIndicator(visible: controller.isTyping.value)),
             
            ],
          ),
        ),
      ),
    );
  }
}
