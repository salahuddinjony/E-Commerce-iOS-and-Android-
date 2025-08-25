import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/model/category_response.dart';

mixin class CategoryServices {
  final RxList<CategoryData> categoriesData = <CategoryData>[].obs;

  // ================= Fetch =================
  Future<void> fetchCategories() async {
    EasyLoading.show(
        status: 'Loading categories...', maskType: EasyLoadingMaskType.black);
    try {
      final userId = await SharePrefsHelper.getString(AppConstants.userId);
      if (userId.isEmpty) {
        EasyLoading.showInfo('User not found');
        return;
      }
      final response =
          await ApiClient.getData(ApiUrl.categoryList(userId: userId));

      if (response.statusCode == 200) {
        final body = response.body;
     
        final responseData = CategoryResponse.fromJson(body);
        categoriesData.value = responseData.wrapper?.items ?? [];
        if (categoriesData.isEmpty) {
          EasyLoading.showInfo('No categories found, Create First');
        } else {
          EasyLoading.showSuccess('Categories loaded successfully');
        }

        debugPrint('Categories fetched: ${categoriesData.length}');
      } else if (response.statusCode == 404) {
        categoriesData.value = [];
        EasyLoading.showInfo('No categories found');
      } else {
        EasyLoading.showError('Error ${response.statusCode}');
      }
    } catch (e) {
      EasyLoading.showError('Load failed');
      debugPrint('fetchCategories error: $e');
    } finally {
      EasyLoading.dismiss();
    }
  }

  // ================= Create / Update =================
  Future<bool> createUpdateCategory({
    required String name,
    required String method, // 'POST' or 'PATCH'
    String? imagePath,
    String? id, // required if PATCH
  }) async {
    assert(
        method == 'POST' || method == 'PATCH', 'method must be POST or PATCH');

    if (name.trim().isEmpty) {
      EasyLoading.showInfo('Name required');
      return false;
    }
    if (method == 'PATCH' && (id == null || id.isEmpty)) {
      EasyLoading.showInfo('Category id missing');
      return false;
    }
    if (method == 'POST' && (imagePath == null || imagePath.isEmpty)) {
      EasyLoading.showInfo('Image required');
      return false;
    }

    EasyLoading.show(
      status:
          method == 'POST' ? 'Creating category...' : 'Updating category...',
      maskType: EasyLoadingMaskType.black,
    );

    try {
      final fullUrl = method == 'POST'
          ? ApiUrl.createCategory
          : ApiUrl.updateCategory(categoryId: id!);

      // Convert to endpoint (strip base) for multipart helper
      String endpoint = fullUrl;
      if (endpoint.startsWith(ApiUrl.baseUrl)) {
        endpoint = endpoint.substring(ApiUrl.baseUrl.length);
      }
      if (endpoint.startsWith('/')) endpoint = endpoint.substring(1);

      final body = <String, dynamic>{
        'name': name.trim(),
      };

      final List<MultipartBody> multipart = [];
      if (imagePath != null && imagePath.isNotEmpty) {
        final isRemote = imagePath.startsWith('http');
        if (!isRemote) {
          final file = File(imagePath);
          if (await file.exists()) {
            multipart.add(MultipartBody('image', file));
          } else {
            EasyLoading.showError('Image file not found');
            return false;
          }
        } else if (method == 'PATCH') {
          // keep existing remote image
          body['image'] = imagePath;
        }
      }

      final response = method == 'POST'
          ? await ApiClient.postMultipartData(
              endpoint,
              body,
              multipartBody: multipart.isEmpty ? null : multipart,
            )
          : await ApiClient.patchMultipart(
              endpoint,
              body,
              multipartBody: multipart.isEmpty ? null : multipart,
            );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // EasyLoading.showSuccess(method == 'POST' ? 'Created' : 'Updated');
        print("Category ${method == 'POST' ? 'created' : 'updated'} successfully");
        // Refresh list after successful change
        await fetchCategories();
        return true;
      } else {
        final msg = (response.body is Map &&
                response.body['message'] != null &&
                response.body['message'].toString().isNotEmpty)
            ? response.body['message'].toString()
            : 'Failed (${response.statusCode})';
        EasyLoading.showError(msg);
        return false;
      }
    } catch (e) {
      EasyLoading.showError(
          'Failed to ${method == 'POST' ? 'create' : 'update'}: $e');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }

  // ================= Delete =================
  Future<bool> deleteCategory(String categoryId) async {
    if (categoryId.isEmpty) {
      EasyLoading.showInfo('Invalid category id');
      return false;
    }
    EasyLoading.show(
        status: 'Deleting category...', maskType: EasyLoadingMaskType.black);
    try {
      final url = ApiUrl.categoryDelete(categoryId: categoryId);

      final response = await ApiClient.deleteData(url);
      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Deleted');
        

        return true;
      } else {
        final msg = (response.body is Map &&
                response.body['message'] != null &&
                response.body['message'].toString().isNotEmpty)
            ? response.body['message'].toString()
            : 'Delete failed (${response.statusCode})';
        EasyLoading.showError(msg);
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Delete failed: $e');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
