import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/api_url.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/category/model/category_response.dart';

mixin class CategoryServices {
  final RxList<CategoryData> categoriesData = <CategoryData>[].obs;

  // New loading & action state flags
  final RxBool isCategoryLoading = false.obs;
  final RxBool isCategoryMutating = false.obs;

  // ================= Fetch Categories =================
  Future<Map<String, dynamic>> fetchCategories(
      {String? vendorId, int page = 1, bool isRefresh = false, int itemsPerPage = 15}) async {
    try {
      print('fetchCategories called with page: $page, isRefresh: $isRefresh');

      // Only set isLoading for initial load (page 1) or refresh
      if (page == 1) {
        isCategoryLoading.value = true;
      }

      if (isRefresh) {
        categoriesData.clear();
      }

      final Map<String, String> queryParams = {
        'page': page.toString(),
        'limit': itemsPerPage.toString(),
      };

      vendorId ??= await SharePrefsHelper.getString(
          AppConstants.userId); //when userId is not passed
      if (vendorId.isEmpty) {
        Get.snackbar('Categories', 'User not found');
        if (page == 1 || isRefresh) {
          categoriesData.clear();
        }
        return {'success': false, 'hasMoreData': false, 'newItemsCount': 0};
      }

      final response = await ApiClient.getData(
          ApiUrl.categoryList(userId: vendorId),
          query: queryParams);

      if (response.statusCode == 200) {
        final body = response.body;
        final responseData = CategoryResponse.fromJson(body);
        final newCategories = responseData.wrapper?.items ?? [];
        final meta = responseData.wrapper?.meta;

        print(
            'Category API Response - page: ${meta?.page}, limit: ${meta?.limit}, total: ${meta?.total}, totalPages: ${meta?.totalPages}');
        print('New categories loaded: ${newCategories.length}');

        if (page == 1 || isRefresh) {
          // First page or refresh - replace all categories
          categoriesData.value = newCategories;
        } else {
          // Additional pages - append to existing categories
          categoriesData.addAll(newCategories);
        }

        print(
            'Loaded ${newCategories.length} categories for page $page. Total categories: ${categoriesData.length}');

        // Calculate if there's more data based on meta information
        bool hasMoreData = false;
        if (meta != null && meta.totalPages != null && meta.page != null) {
          hasMoreData = meta.page! < meta.totalPages!;
        } else {
          // Fallback: if we got fewer items than the limit, assume no more data
          hasMoreData = newCategories.length >= itemsPerPage;
        }

        print(
            'Pagination info - hasMoreData: $hasMoreData, currentPage: ${meta?.page}, totalPages: ${meta?.totalPages}');

        if (categoriesData.isEmpty && (page == 1 || isRefresh)) {
          debugPrint('No categories found');
        }

        return {
          'success': true,
          'hasMoreData': hasMoreData,
          'newItemsCount': newCategories.length,
          'meta': meta
        };
      } else if (response.statusCode == 404) {
        if (page == 1 || isRefresh) {
          categoriesData.clear();
        }
        debugPrint('No categories found (404)');
        return {'success': false, 'hasMoreData': false, 'newItemsCount': 0};
      } else {
        debugPrint('Fetch categories error: ${response.statusCode}');
        return {'success': false, 'hasMoreData': false, 'newItemsCount': 0};
      }
    } catch (e) {
      debugPrint('fetchCategories error: $e');
      return {'success': false, 'hasMoreData': false, 'newItemsCount': 0};
    } finally {
      // Always reset loading state for initial load or refresh
      if (page == 1) {
        isCategoryLoading.value = false;
      }
    }
  }

  // ================= Create / Update =================
  Future<bool> createUpdateCategory({
    required String name,
    required String method, // 'POST' or 'PATCH'
    String? imagePath,
    String? id,
  }) async {
    assert(
        method == 'POST' || method == 'PATCH', 'method must be POST or PATCH');

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
      EasyLoading.show(
          status: method == 'POST' ? 'Creating...' : 'Updating...');
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
            toastMessage(message: 'Image file not found');
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
        EasyLoading.showSuccess(
            method == 'POST' ? 'Category created' : 'Category updated');
        debugPrint("Category ${method == 'POST' ? 'created' : 'updated'}");
        await fetchCategories(isRefresh: true);
        return true;
      } else {
        EasyLoading.showError('Failed (${response.statusCode})');
        final msg = (response.body is Map &&
                response.body['message'] != null &&
                response.body['message'].toString().isNotEmpty)
            ? response.body['message'].toString()
            : 'Failed (${response.statusCode})';
        debugPrint('Create/Update category error: $msg');
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Failed: $e');
      // Get.snackbar('Category', 'Failed: $e');
      return false;
    } finally {
      EasyLoading.dismiss();
      isCategoryMutating.value = false;
    }
  }

  // ================= Delete =================
  Future<bool> deleteCategory(String categoryId) async {
    if (categoryId.isEmpty) {
      toastMessage(message: 'Invalid category id');
      return false;
    }
    isCategoryMutating.value = true;
    try {
      EasyLoading.show(status: 'Deleting...');
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
      EasyLoading.dismiss();
      isCategoryMutating.value = false;
    }
  }
}
