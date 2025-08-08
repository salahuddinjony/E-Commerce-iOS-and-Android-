import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:local/app/services/app_url.dart';
import 'dart:io';
import 'dart:convert';

mixin class MixinCreateCategory {
  Future<void> createCategory(String name, String imagePath) async {
    EasyLoading.show(status: 'Creating category...');

    try {
      // Validate name
      if (name.trim().isEmpty) {
        throw Exception('Category name cannot be empty');
      }

      final url = ApiUrl.createCategory;
      print('Constructed URL: $url');

      final request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['name'] = name.trim();

      // Validate and add image if provided
      if (imagePath.isNotEmpty) {
        final file = File(imagePath);
        if (!await file.exists()) {
          throw Exception('Image file does not exist: $imagePath');
        }
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imagePath,
        ));
      }

      // Log request details
      print('Request fields: ${request.fields}');
      print('Request files: ${request.files.map((f) => f.filename).toList()}');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Category created successfully');
        print('Category created successfully: $responseBody');
      } else {
        final jsonResponse = jsonDecode(responseBody);
        final errorMessage = jsonResponse['error'] ?? 'Unknown error';
        EasyLoading.showError('Failed to create category: $errorMessage');
        print('Failed to create category: ${response.statusCode}, Body: $responseBody');
      }
    } catch (error) {
      print('Failed to create category: $error');
      if (error is http.ClientException) {
        print('Network error: $error');
      } else if (error is FileSystemException) {
        print('File error: $error');
      } else if (error is FormatException) {
        print('URL format error: $error');
      }
      EasyLoading.showError('Failed to create category: $error');
    } finally {
      EasyLoading.dismiss();
    }
  }
}