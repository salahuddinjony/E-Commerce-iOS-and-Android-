import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/screens/features/client/chat/controllers/chat_controller.dart';
import 'loader_overlay.dart';

class ChatBody extends StatelessWidget {
  final ChatController controller;
  final String receiverImage;

  const ChatBody({
    super.key,
    required this.controller,
    required this.receiverImage,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final messages = controller.messages.toList();
      final user = (controller.user is Rx)
          ? (controller.user as Rx).value
          : controller.user;

      return Stack(
        children: [
          Chat(
            messages: messages,
            onSendPressed: controller.handleSendPressed,
            showUserAvatars: true,
            showUserNames: true,
            dateFormat: DateFormat('dd/MM/yyyy'),
            dateIsUtc: true,
            customDateHeaderText: (date) {
              final now = DateTime.now();
              final difference = now.difference(date);
              if (difference.inDays == 0) return 'Today';
              if (difference.inDays == 1) return 'Yesterday';
              return DateFormat('dd/MM/yyyy').format(date);
            },
            timeFormat: DateFormat('HH:mm'),
            dateHeaderThreshold: 60000 * 60 * 24,
            avatarBuilder: (userId) {
              return Container(
                margin: const EdgeInsets.only(right: 8),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: CustomNetworkImage(
                    imageUrl: receiverImage,
                    height: 40,
                    width: 40,
                  ),
                ),
              );
            },
            user: user,
            theme: const DefaultChatTheme(
              // subtle messenger-like colors
              inputBackgroundColor: AppColors.brightCyan,
              inputTextColor: Colors.black,
              primaryColor: AppColors.brightCyan,
              secondaryColor: AppColors.borderColor,
              // you can tune more fields here if your package version supports them
            ),
          ),
          Positioned.fill(
            bottom: 88,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onLongPress: () {},
            ),
          ),
          if (controller.isLoading.value) const LoaderOverlay(),
        ],
      );
    });
  }
}
