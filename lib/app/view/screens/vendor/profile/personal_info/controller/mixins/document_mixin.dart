import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../../../../data/local/shared_prefs.dart';
import '../../../../../../../utils/app_constants/app_constants.dart';
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

    const oldHost = '10.10.20.19:5007';
    const newBase = 'https://gmosley-uteehub-backend.onrender.com';
    String finalUrl = url.trim();
    if (finalUrl.contains(oldHost)) {
      final u = Uri.parse(finalUrl);
      finalUrl = '$newBase${u.path}${u.query.isNotEmpty ? '?${u.query}' : ''}';
    }
    if (!finalUrl.startsWith('http')) {
      finalUrl = '$newBase${finalUrl.startsWith('/') ? '' : '/'}$finalUrl';
    }

    if (finalUrl.startsWith('file://') || finalUrl.startsWith('/')) {
      await OpenFilex.open(finalUrl.replaceFirst('file://', ''));
      return;
    }

    try {
      // Reset progress state
      isDownloading.value = true;
      downloadProgress.value = 0.0;
      downloadingFileName.value = '';

      final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
      final headers = {
        'Accept': '*/*',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };
      final uri = Uri.parse(finalUrl);
      final request = http.Request('GET', uri);
      request.headers.addAll(headers);
      final streamed = await request.send();
      if (streamed.statusCode != 200) {
        EasyLoading.showError('Download failed (${streamed.statusCode})');
        isDownloading.value = false;
        return;
      }

      String fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : 'document';
      if (!fileName.contains('.')) {
        final ct = streamed.headers['content-type'] ?? '';
        if (ct.contains('pdf')) fileName += '.pdf';
        else if (ct.contains('png')) fileName += '.png';
        else if (ct.contains('jpeg') || ct.contains('jpg')) fileName += '.jpg';
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
    } catch (_) {
      isDownloading.value = false;
      EasyLoading.showError('Open failed');
    }
  }
}