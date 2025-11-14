import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:gal/gal.dart';
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
              debugPrint('customMessageBuilder called for message type: ${message.runtimeType}');
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

              // Handle text messages with long press to copy
              if (message is types.TextMessage) {
                final textMessage = message as types.TextMessage;
                final isCurrentUser = textMessage.author.id == controller.userId;
                return Align(
                  alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onLongPressStart: (_) {
                      debugPrint('Text long press started: ${textMessage.text}');
                    },
                    onLongPress: () {
                      debugPrint('Text long pressed: ${textMessage.text}');
                      _showTextOptions(context, textMessage.text);
                    },
                    onLongPressEnd: (_) {
                      debugPrint('Text long press ended: ${textMessage.text}');
                    },
                    child: Material(
                      color: Colors.transparent,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isCurrentUser ? AppColors.brightCyan : Colors.grey[200],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        constraints: BoxConstraints(
                          maxWidth: messageWidth * 0.75,
                        ),
                        child: Text(
                          textMessage.text,
                          style: TextStyle(
                            color: isCurrentUser ? Colors.white : Colors.black87,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink(); // fallback to default renderer for other message types
            },
            onMessageTap: (context, message) {
              // Handle tap on messages - show save option for images
              if (message is types.ImageMessage) {
                _showImageOptions(context, message.uri);
              }
            },
            onMessageLongPress: (context, message) {
              // Handle long press on messages - copy text
              if (message is types.TextMessage) {
                _showTextOptions(context, message.text);
              } else if (message is types.ImageMessage) {
                _showImageOptions(context, message.uri);
              }
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
          if (controller.isLoading.value) const LoaderOverlay(),
        ],
      );
    });
  }

  /// Show options dialog for image messages (Save Image)
  void _showImageOptions(BuildContext context, String imageUrl) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download, color: AppColors.brightCyan),
              title: const Text('Save Image'),
              onTap: () {
                Navigator.of(ctx).pop();
                _saveImageToGallery(context, imageUrl);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.grey),
              title: const Text('Cancel'),
              onTap: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  /// Save image to gallery
  Future<void> _saveImageToGallery(BuildContext context, String imageUrl) async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              ),
              SizedBox(width: 16),
              Text('Saving image...'),
            ],
          ),
          duration: Duration(seconds: 2),
        ),
      );

      Uint8List bytes;
      
      // Check if it's a local file or network URL
      if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
        // Network URL - download the image
        final response = await http.get(Uri.parse(imageUrl));
        if (response.statusCode == 200) {
          bytes = response.bodyBytes;
        } else {
          throw Exception('Failed to download image: ${response.statusCode}');
        }
      } else {
        // Local file path - read the file
        final file = File(imageUrl);
        if (await file.exists()) {
          bytes = await file.readAsBytes();
        } else {
          throw Exception('Local file not found: $imageUrl');
        }
      }
      
      // Save to gallery using gal package
      await Gal.putImageBytes(bytes, name: 'chat_image_${DateTime.now().millisecondsSinceEpoch}.png');
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Image saved to gallery'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving image: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(child: Text('Failed to save image: ${e.toString()}')),
              ],
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  /// Show options dialog for text messages (Copy)
  void _showTextOptions(BuildContext context, String text) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy, color: AppColors.brightCyan),
              title: const Text('Copy Text'),
              onTap: () {
                Navigator.of(ctx).pop();
                _copyTextToClipboard(context, text);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel, color: Colors.grey),
              title: const Text('Cancel'),
              onTap: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  /// Copy text to clipboard
  void _copyTextToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Text copied to clipboard'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
