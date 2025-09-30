import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/api_url.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/screens/features/client/chat/controllers/chat_controller.dart';
import 'package:local/app/global/controller/genarel_controller.dart';
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
            customMessageBuilder: (message, {required int messageWidth}) {
              // Render image messages with our CustomNetworkImage which already
              // provides a shimmer placeholder and error widget.
              if (message is types.ImageMessage) {
                final types.ImageMessage img = message as types.ImageMessage;
                // choose a reasonable display size based on available width
                final double imgWidth = (messageWidth * 0.7).clamp(120.0, 320.0);
                final double imgHeight = imgWidth * 0.66;

                return Container(
                  constraints: BoxConstraints(
                    maxWidth: imgWidth,
                    maxHeight: imgHeight,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CustomNetworkImage(
                      imageUrl: img.uri,
                      height: imgHeight,
                      width: imgWidth,
                      boxShape: BoxShape.rectangle,
                    ),
                  ),
                );
              }

              return const SizedBox.shrink(); // fallback to default renderer for non-image messages
            },
            // Provide attachment handler so users can pick images/files
            onAttachmentPressed: () async {
              try {
                final gen = Get.find<GeneralController>();
                await gen.selectImage();
                if (gen.image.value.isEmpty) return;

                final pickedPath = gen.image.value;

                // optimistic UI: add an image message locally with local uri
                final tempId = const Uuid().v4();
                final imgMsg = types.ImageMessage(
                  author: controller.user,
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                  id: tempId,
                  name: pickedPath.split('/').last,
                  size: 0,
                  uri: pickedPath,
                  metadata: {'role': controller.userRole},
                );

                controller.messages.insert(0, imgMsg);

                // Upload file to server using ApiClient multipart helper
                try {
                  // prepare multipart body
                  final multipart = [
                    MultipartBody("file", gen.imageFile.value),
                  ];

                  final body = <String, dynamic>{};

                  final resp = await ApiClient.postMultipartData(
                    ApiUrl.uploadImage,
                    body,
                    multipartBody: multipart,
                  );

                  if (resp.statusCode == 200 || resp.statusCode == 201) {
                    // parse response (ApiClient returns body as raw string sometimes)
                    dynamic data;
                    try {
                      data = resp.body is String ? jsonDecode(resp.body) : resp.body;
                    } catch (_) {
                      data = resp.body;
                    }

                    // Expect uploaded file url to be in data['data'] or similar
                    String? fileUrl;
                    if (data is Map) {
                      if (data['data'] is String) fileUrl = data['data'];
                      else if (data['data'] is Map && data['data']['url'] != null) fileUrl = data['data']['url'];
                      else if (data['data'] is List && data['data'].isNotEmpty) fileUrl = data['data'][0]['url'] ?? data['data'][0]['path'];
                      else if (data['url'] != null) fileUrl = data['url'];
                    }

                    if (fileUrl != null && fileUrl.isNotEmpty) {
                      // replace optimistic message uri with server url
                      final idx = controller.messages.indexWhere((m) => m.id == tempId);
                      if (idx != -1) {
                        final newMsg = types.ImageMessage(
                          author: controller.user,
                          createdAt: imgMsg.createdAt,
                          id: tempId,
                          name: imgMsg.name,
                          size: imgMsg.size,
                          uri: fileUrl,
                          metadata: imgMsg.metadata,
                        );
                        controller.messages[idx] = newMsg;
                      }

                      // send chat message via socket with attachment list containing the file url
                      controller.repo.sendMessage(
                        conversationId: controller.conversationId,
                        senderId: controller.userId,
                        text: '',
                        attachment: [fileUrl],
                      );
                    } else {
                      debugPrint('Upload succeeded but no file URL returned: ${resp.body}');
                    }
                  } else {
                    debugPrint('Upload failed: ${resp.statusCode} ${resp.body}');
                  }
                } catch (e) {
                  debugPrint('File upload error: $e');
                } finally {
                  // clear selected image file regardless
                  gen.clearImage();
                }
              } catch (e) {
                debugPrint('Attachment error: $e');
              }
            },
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
