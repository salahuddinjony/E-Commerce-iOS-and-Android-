import 'dart:io';

import 'package:get/get.dart';
import '../../../../../../services/api_client.dart';


class ProfileEditService {
  static Future<Response> updateProfile({
    required String userId,
    required Map<String, dynamic> body,
    File? imageFile,
    List<File>? documentFiles,
  }) async {
    final multipart = <MultipartBody>[];
    if (imageFile != null) {
      multipart.add(MultipartBody('image', imageFile));
    }
    if (documentFiles != null && documentFiles.isNotEmpty) {
      for (final f in documentFiles) {
        multipart.add(MultipartBody('documents', f));
      }
    }

    // Updated endpoint: {{base-url}}/user/update/{userId}
    final String endpoint = 'user/update/$userId';
    return ApiClient.patchMultipart(
      endpoint,
      body,
      multipartBody: multipart.isEmpty ? null : multipart,
    );
  }
}


