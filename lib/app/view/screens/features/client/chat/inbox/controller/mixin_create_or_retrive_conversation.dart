import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/api_url.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';

mixin class MixinCreateOrRetrieveConversation {
  Future<String?> createOrRetrieveConversation({
    String? senderId, // logged in user
    required String receiverId, // other user
  }) async {
    final userId = senderId ??
        await SharePrefsHelper.getString(
            AppConstants.userId); // here set sernder as logged user

    try {
      final body = {
        'members': [userId, receiverId],
      };

      debugPrint('Request Body: $body');

      final response = await ApiClient.postData(
        ApiUrl.createOrRetrieveConversation,
        jsonEncode(body),
      );

      debugPrint('Response: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic rawBody = response.body;
        final conversationId = rawBody['data']['_id'] as String?;

        debugPrint('Conversation ID: $conversationId');
        debugPrint('Successfully created/retrieved conversation.');
        debugPrint('Members: ${rawBody['data']}');

        return conversationId;
      } else {
        debugPrint(
            'Failed to create/retrieve conversation: ${response.statusText}');
        throw Exception(
            'Failed to create/retrieve conversation: ${response.statusText}');
      }
    } catch (e) {
      debugPrint('Error in createOrRetrieveConversation: $e');
      return null;
    } finally {}
  }
}
