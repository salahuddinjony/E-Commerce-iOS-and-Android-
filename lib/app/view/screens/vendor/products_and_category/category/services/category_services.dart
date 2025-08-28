import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/model/category_response.dart';

mixin class CategoryServices {
  final RxList<CategoryData> categoriesData = <CategoryData>[].obs;

  // New loading & action state flags
  final RxBool isCategoryLoading = false.obs;
  final RxBool isCategoryMutating = false.obs;

  // ================= Fetch =================
  Future<void> fetchCategories() async {
    isCategoryLoading.value = true;
    try {
      final userId = await SharePrefsHelper.getString(AppConstants.userId);
      if (userId.isEmpty) {
        Get.snackbar('Categories', 'User not found');
        categoriesData.clear();
        return;
      }

      final response =
          await ApiClient.getData(ApiUrl.categoryList(userId: userId));

      if (response.statusCode == 200) {
        final body = response.body;
        final responseData = CategoryResponse.fromJson(body);
        categoriesData.value = responseData.wrapper?.items ?? [];
        debugPrint('Categories fetched: ${categoriesData.length}');
        if (categoriesData.isEmpty) {
          debugPrint('No categories found');
        }
      } else if (response.statusCode == 404) {
        categoriesData.clear();
        debugPrint('No categories found (404)');
      } else {
        debugPrint('Fetch categories error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('fetchCategories error: $e');
    } finally {
      isCategoryLoading.value = false;
    }
  }

  // ================= Create / Update =================
  Future<bool> createUpdateCategory({
    required String name,
    required String method, // 'POST' or 'PATCH'
    String? imagePath,
    String? id,
  }) async {
    assert(method == 'POST' || method == 'PATCH', 'method must be POST or PATCH');

    if (name.trim().isEmpty) {
      Get.snackbar('Category', 'Name required');
      return false;
    }
    if (method == 'PATCH' && (id == null || id.isEmpty)) {
      Get.snackbar('Category', 'Category id missing');
      return false;
    }
    if (method == 'POST' && (imagePath == null || imagePath.isEmpty)) {
      Get.snackbar('Category', 'Image required');
      return false;
    }

    isCategoryMutating.value = true;
    try {
      final fullUrl = method == 'POST'
          ? ApiUrl.createCategory
          : ApiUrl.updateCategory(categoryId: id!);

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
              Get.snackbar('Category', 'Image file not found');
              return false;
            }
        } else if (method == 'PATCH') {
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
        debugPrint("Category ${method == 'POST' ? 'created' : 'updated'}");
        await fetchCategories();
        return true;
      } else {
        final msg = (response.body is Map &&
                response.body['message'] != null &&
                response.body['message'].toString().isNotEmpty)
            ? response.body['message'].toString()
            : 'Failed (${response.statusCode})';
        Get.snackbar('Category', msg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Category', 'Failed: $e');
      return false;
    } finally {
      isCategoryMutating.value = false;
    }
  }

  // ================= Delete =================
  Future<bool> deleteCategory(String categoryId) async {
    if (categoryId.isEmpty) {
      Get.snackbar('Category', 'Invalid category id');
      return false;
    }
    isCategoryMutating.value = true;
    try {
      final url = ApiUrl.categoryDelete(categoryId: categoryId);
      final response = await ApiClient.deleteData(url);
      if (response.statusCode == 200) {
        debugPrint('Category deleted');
        // Optionally refresh list
        categoriesData.removeWhere((c) => c.id == categoryId);
        return true;
      } else {
        final msg = (response.body is Map &&
                response.body['message'] != null &&
                response.body['message'].toString().isNotEmpty)
            ? response.body['message'].toString()
            : 'Delete failed (${response.statusCode})';
        Get.snackbar('Category', msg);
        return false;
      }
    } catch (e) {
      Get.snackbar('Category', 'Delete failed: $e');
      return false;
    } finally {
      isCategoryMutating.value = false;
    }
  }
}
