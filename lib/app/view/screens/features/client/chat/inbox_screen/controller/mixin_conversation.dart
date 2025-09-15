
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/api_url.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/screens/features/client/chat/inbox_screen/model/conversations_model.dart';

mixin MixinChatConversation {
  final RxList<Conversation> conversationList = <Conversation>[].obs;

  Future<void> fetchConversationsList({String? userId}) async {
    final loggedUserId =
        userId ?? await SharePrefsHelper.getString(AppConstants.userId);
    try {
      final response = await ApiClient.getData(
          ApiUrl.getConversationList(userId: loggedUserId));

      if (response.statusCode == 200) {
        final dynamic rawBody = response.body;
        final dataModel = ConversationResponse.fromJson(rawBody);
        final data = dataModel.data;
        conversationList.value = data;

        debugPrint('Response data: ${response.body}');
        debugPrint('Conversations fetched: ${conversationList.length}');
      } else {
        debugPrint('Failed to load conversations: ${response.statusText}');
        throw Exception('Failed to load conversations: ${response.statusText}');
      }
    } catch (e) {
      debugPrint('e fetchConversationsList error: $e');
    } finally {}
  }
}
