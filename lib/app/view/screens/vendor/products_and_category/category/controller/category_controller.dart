import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/controller/mixin_create_category.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/controller/mixin_delete_category.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/model/category_response.dart';

class CategoryController extends GetxController with DeleteCategoryMixin,MixinCreateCategory {
  var name = ''.obs;
  var imagePath = ''.obs;
  final nameController = TextEditingController();
  final isNetworkImage = false.obs;

  RxList<CategoryData> categoriesData = <CategoryData>[].obs;

  void setName(String value) => name.value = value;
  void setImagePath(String value) => imagePath.value = value;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  void setInitialValues(String initialImagePath, String initialCategoryName) {
    print("Setting initial values: imagePath=$initialImagePath, categoryName=$initialCategoryName");
    imagePath.value = initialImagePath;
    isNetworkImage.value = initialImagePath.startsWith('http');
    nameController.text = initialCategoryName;
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print("New image picked: ${pickedFile.path}");
      imagePath.value = pickedFile.path;
      isNetworkImage.value = false; // New image is a local file
    }
  }

  void clearImage() {
    print("Clearing image");
    imagePath.value = '';
    isNetworkImage.value = false;
  }

  void clear() {
    print("Clearing all fields");
    nameController.clear();
    imagePath.value = '';
    isNetworkImage.value = false;
  }

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
        // EasyLoading.showSuccess('Categories loaded successfully');
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
  Future<void> createCategoryPost() async {
    String name = nameController.text.trim();
    String imagePath = this.imagePath.value.trim();
    print("Creating category with name: $name and imagePath: $imagePath");
    await super.createCategory(name, imagePath);
    fetchCategories();
    clear();
  }

  void reFresehData(){
    print("Refreshing data");
    fetchCategories();
    clear();
  }
}