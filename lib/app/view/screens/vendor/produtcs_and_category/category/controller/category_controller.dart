import 'dart:convert';
import 'dart:math';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/view/screens/vendor/produtcs_and_category/category/model/category_response.dart';

class CategoryController extends GetxController {
  var name = ''.obs;
  var imagePath = ''.obs;
  RxList<CategoryData> categoriesData = <CategoryData>[].obs;

  void setName(String value) => name.value = value;
  void setImagePath(String value) => imagePath.value = value;

  @override
  void onInit() {
    super.onInit();
    fetchCategoires();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setImagePath(pickedFile.path);
    }
  }

  Future<void> fetchCategoires() async {
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
        EasyLoading.showSuccess('Categories loaded successfully');
        final responseData = json.decode(response.body);
        final categoryResponse = CategoryResponse.fromJson(responseData);
        categoriesData.value = categoryResponse.data;

        print(responseData['message']);
        print(
            "Categories fetched successfully: ${categoryResponse.data.length} items");
        print(
            "Categories fetched successfully: ${categoryResponse.data} dataaa");

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

  // void addCategory() {
  //   if (name.value.isNotEmpty && imagePath.value.isNotEmpty) {
  //     categories.add(Category(name: name.value, imagePath: imagePath.value));
  //     clear();
  //   }
  // }

  void clear() {
    name.value = '';
    imagePath.value = '';
  }
}
