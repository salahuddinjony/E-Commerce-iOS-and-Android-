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
      EasyLoading.show(status: 'Downloading...');
      final token =
          await SharePrefsHelper.getString(AppConstants.bearerToken);
      final headers = {
        'Accept': '*/*',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      };
      final uri = Uri.parse(finalUrl);
      final resp = await http.get(uri, headers: headers);
      if (resp.statusCode != 200) {
        EasyLoading.showError('Download failed (${resp.statusCode})');
        return;
      }

      String fileName = uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last
          : 'document';
      if (!fileName.contains('.')) {
        final ct = resp.headers['content-type'] ?? '';
        if (ct.contains('pdf')) fileName += '.pdf';
        else if (ct.contains('png')) fileName += '.png';
        else if (ct.contains('jpeg') || ct.contains('jpg')) fileName += '.jpg';
        else if (ct.contains('plain')) fileName += '.txt';
      }

      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/$fileName';
      await File(path).writeAsBytes(resp.bodyBytes);
      EasyLoading.dismiss();

      final result = await OpenFilex.open(path);
      if (result.type != ResultType.done) {
        if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
          EasyLoading.showError('Cannot open file');
        }
      }
    } catch (_) {
      EasyLoading.dismiss();
      EasyLoading.showError('Open failed');
    }
  }
}