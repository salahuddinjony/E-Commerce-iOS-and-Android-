import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../../../data/local/shared_prefs.dart';
import '../../../../../../../../utils/app_constants/app_constants.dart';
import 'profile_state_mixin.dart';

mixin DocumentMixin on ProfileStateMixin {
  Future<void> pickImage({required String source}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source == "camera" ? ImageSource.camera : ImageSource.gallery,
      );
      if (pickedFile != null) pickedImage.value = pickedFile.path;
    } catch (e) {
      EasyLoading.showError('Image pick failed');
    }
  }

  Future<void> pickDocuments() async {
    final picker = ImagePicker();
    final files = await picker.pickMultipleMedia();
    if (files.isNotEmpty) {
      pickedDocuments.assignAll(files.map((e) => File(e.path)));
    }
  }

  Future<void> openDocument(String url) async {
    if (url.isEmpty) {
      EasyLoading.showInfo('Invalid document');
      return;
    }

    String finalUrl = url.trim();
    // If local file, open directly
    if (finalUrl.startsWith('file://') || finalUrl.startsWith('/')) {
      await OpenFilex.open(finalUrl.replaceFirst('file://', ''));
      return;
    }

    try {
      // Debug log for troubleshooting
      debugPrint('[Document Download] URL: $finalUrl');
      final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
      debugPrint('[Document Download] Token: $token');

      // Reset progress state
      isDownloading.value = true;
      downloadProgress.value = 0.0;

      final uri = Uri.parse(finalUrl);
      // If S3 URL (any region/host), skip Authorization header
      final hostLower = uri.host.toLowerCase();
      final isS3 = hostLower.contains('.s3.');
      Map<String, String> headers = {'Accept': '*/*'};
      if (!isS3 && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
      debugPrint('[Document Download] Headers (final): $headers');
      final request = http.Request('GET', uri);
      request.headers.clear();
      request.headers.addAll(headers);
      final streamed = await request.send();
      if (streamed.statusCode != 200) {
        // Try to read error body for more info
        String errorMsg = 'Download failed (${streamed.statusCode})';
        try {
          final errorBody = await streamed.stream.bytesToString();
          if (errorBody.isNotEmpty) {
            errorMsg += '\nServer response: $errorBody';
          }
        } catch (e) {
          debugPrint('[Document Download] Error reading error body: $e');
        }
        EasyLoading.showError(errorMsg);
        isDownloading.value = false;
        return;
      }

      String fileName =
          uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'document';
      if (!fileName.contains('.')) {
        final ct = streamed.headers['content-type'] ?? '';
        if (ct.contains('pdf'))
          fileName += '.pdf';
        else if (ct.contains('png'))
          fileName += '.png';
        else if (ct.contains('jpeg') || ct.contains('jpg'))
          fileName += '.jpg';
        else if (ct.contains('plain')) fileName += '.txt';
      }
      downloadingFileName.value = fileName;

      final contentLength = streamed.contentLength ?? 0;
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/$fileName';
      final file = File(path).openWrite();
      int received = 0;
      await for (final chunk in streamed.stream) {
        received += chunk.length;
        file.add(chunk);
        if (contentLength > 0) {
          downloadProgress.value = received / contentLength;
        }
      }
      await file.flush();
      await file.close();
      downloadProgress.value = 1.0;
      isDownloading.value = false;

      final result = await OpenFilex.open(path);
      if (result.type != ResultType.done) {
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          EasyLoading.showError('Cannot open file');
        }
      }
    } catch (e) {
      isDownloading.value = false;
      EasyLoading.showError('Open failed: ${e.toString()}');
      debugPrint('[Document Download] Exception: $e');
    }
  }
}
