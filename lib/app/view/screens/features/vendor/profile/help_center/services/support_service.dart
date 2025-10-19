import 'dart:convert';

import 'package:get/get.dart';
import '../../../../../../../services/api_client.dart';
import '../../../../../../../services/api_url.dart';

class SupportService {
  /// Send a new support message by user
  static Future<Response> sendSupportMessage({
    required String userId,
    required String subject,
    required String message,
  }) async {
    final body = {
      "userId": userId,
      "subject": subject,
      "message": message,
    };

    return ApiClient.postData(
      ApiUrl.sendSupportMessage,
      jsonEncode(body),
    );
  }

  /// Retrieve support thread for a specific user
  static Future<Response> getAllSupportThreads({
    required String userId,
  }) async {
    final url = '${ApiUrl.baseUrl}support/retrieve/user/$userId';

    return ApiClient.getData(url);
  }
}
