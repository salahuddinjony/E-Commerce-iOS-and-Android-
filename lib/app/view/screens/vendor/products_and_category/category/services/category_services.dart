import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:http/http.dart' as http;
import 'package:local/app/services/app_url.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/model/category_response.dart';

mixin class CategoryServices {
 RxList<CategoryData> categoriesData = <CategoryData>[].obs;
 
    Future<void> fetchCategories() async {
    EasyLoading.show(
      status: 'Loading categories...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      final response = await http.get(
        Uri.parse(ApiUrl.categoryList),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final categoryResponse = CategoryResponse.fromJson(responseData);
        categoriesData.value = categoryResponse.data;

        print(responseData['message']);
        print("Categories fetched successfully: ${categoryResponse.data.length} items");
        print("Categories fetched successfully: ${categoryResponse.data} dataaa");
        print("Category Response: ${responseData['data']}");
      } else if (response.statusCode == 404) {
        EasyLoading.showError('No categories found');
        print("No categories found");
      } else {
        EasyLoading.showError('Error: ${response.statusCode}');
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      EasyLoading.showError('Failed to load categories: $e');
      print("Error fetching categories: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }
}