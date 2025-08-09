import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:local/app/services/app_url.dart';
import 'dart:io';
import 'dart:convert';

mixin class MixinProductCreateAndUpdateCategory {
  Future<void> createUpdateCategory(String name, String imagePath, String method, String id) async {
    EasyLoading.show(status: method == 'POST' ? 'Creating category...' : 'Updating category...');

    try {
     
      final url = (method == 'POST' ? ApiUrl.createCategory : ApiUrl.updateCategory(categoryId: id));
      print('Constructed URL: $url');

      final request = http.MultipartRequest(method, Uri.parse(url))
        ..fields['name'] = name.trim();

      // Handle image for POST and PATCH
      if (imagePath.isNotEmpty && !imagePath.startsWith('http')) {
        // Local file (new image for POST or PATCH)
        final file = File(imagePath);
        if (!await file.exists()) {
          throw Exception('Image file does not exist: $imagePath');
        }
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          imagePath,
        ));
      } else if (imagePath.isNotEmpty && method == 'PATCH') {
        // Network image for PATCH
        request.fields['image'] = imagePath; 
      } else if (method == 'POST' && imagePath.isEmpty) {
        throw Exception('Image is required for creating a category');
      }

    

      print('Request fields: ${request.fields}');
      print('Request files: ${request.files.map((f) => f.filename).toList()}');
      print('Request headers: ${request.headers}');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        // EasyLoading.showSuccess(method == 'POST' ? 'Category created successfully' : 'Category updated successfully');
        print('Success: Status ${response.statusCode}, Body: $responseBody');
      } else {
        final jsonResponse = jsonDecode(responseBody);
        final errorMessage = jsonResponse['error'] ?? jsonResponse['message'] ?? 'Unknown error';
        EasyLoading.showError('Failed to ${method == 'POST' ? 'create' : 'update'} category: $errorMessage');
        print('Failed: Status ${response.statusCode}, Body: $responseBody');
      }
    } catch (error) {
      print('Error: $error');
      if (error is http.ClientException) {
        print('Network error: $error');
      } else if (error is FileSystemException) {
        print('File error: $error');
      } else if (error is FormatException) {
        print('URL format error: $error');
      }
      EasyLoading.showError('Failed to ${method == 'POST' ? 'create' : 'update'} category: $error');
    } finally {
      EasyLoading.dismiss();
    }
  }
}