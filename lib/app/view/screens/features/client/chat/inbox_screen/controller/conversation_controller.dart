import 'package:flutter/widgets.dart';
import 'package:local/app/view/screens/features/client/chat/inbox_screen/controller/mixin_conversation.dart';
import 'package:get/get.dart';

class ConversationController extends GetxController
    with MixinChatConversation {

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadConversations();
  }


  DateTime? parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        final ms = int.tryParse(value);
        if (ms != null) return DateTime.fromMillisecondsSinceEpoch(ms);
      }
    }
    return null;
  }
  Future<void> loadConversations() async {
    isLoading.value = true;
    try {
      await fetchConversationsList();
    } catch (e) {
      debugPrint('Error loading conversations: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

}
