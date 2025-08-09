import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local/app/core/routes.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/controller/mixin_create_and_update_category.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/controller/mixin_delete_category.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/services/category_services.dart';

class CategoryController extends GetxController
    with DeleteCategoryMixin, MixinCreateAndUpdateCategory,CategoryServices {
  var name = ''.obs;
  var imagePath = ''.obs;
  final nameController = TextEditingController();
  final isNetworkImage = false.obs;

 

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
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        print("New image picked: ${pickedFile.path}");
        imagePath.value = pickedFile.path;
        isNetworkImage.value = false;
      } else {
        print("No image selected");
      }
    } catch (e) {
      print("Error picking image: $e");
      EasyLoading.showError('Failed to pick image: $e');
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

  // Future<void> fetchCategories() async {
  //   EasyLoading.show(
  //     status: 'Loading categories...',
  //     maskType: EasyLoadingMaskType.black,
  //   );
  //   try {
  //     final response = await http.get(
  //       Uri.parse(ApiUrl.categoryList),
  //       headers: {'Content-Type': 'application/json'},
  //     );

  //     if (response.statusCode == 200) {
  //       final responseData = json.decode(response.body);
  //       final categoryResponse = CategoryResponse.fromJson(responseData);
  //       categoriesData.value = categoryResponse.data;

  //       print(responseData['message']);
  //       print("Categories fetched successfully: ${categoryResponse.data.length} items");
  //       print("Categories fetched successfully: ${categoryResponse.data} dataaa");
  //       print("Category Response: ${responseData['data']}");
  //     } else if (response.statusCode == 404) {
  //       EasyLoading.showError('No categories found');
  //       print("No categories found");
  //     } else {
  //       EasyLoading.showError('Error: ${response.statusCode}');
  //       print("Error: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     EasyLoading.showError('Failed to load categories: $e');
  //     print("Error fetching categories: $e");
  //   } finally {
  //     EasyLoading.dismiss();
  //   }
  // }

  void reFresehData() async{
    print("Refreshing data");
    await fetchCategories();
    clear();
  }

  Future<void> createCategoryPost(String method, String id, String passedImage, String passedName) async {
    String name = nameController.text.trim();
    String imagePath = this.imagePath.value.trim();

   
    if (method == 'PATCH') {
      if (name == passedName && imagePath == passedImage) {
        EasyLoading.showError('No changes detected');
        print("Validation failed: No changes detected (name=$name, imagePath=$imagePath)");
        return;
      }
    }

   
    if (name.isEmpty) {
      EasyLoading.showError('Category name cannot be empty');
      print("Validation failed: name is empty");
      return;
    }
    if (method == 'POST' && imagePath.isEmpty) {
      EasyLoading.showError('Please select an image for the category');
      print("Validation failed: imagePath is empty for POST");
      return;
    }
    if (method == 'PATCH' && (id.isEmpty || id == 'null')) {
      EasyLoading.showError('Category ID is required for updating');
      print("Validation failed: categoryId is empty for PATCH");
      return;
    }

    print("Creating/Updating category: method=$method, id=$id, name=$name, imagePath=$imagePath, isNetworkImage=${isNetworkImage.value}");
    await createUpdateCategory(name, imagePath, method, id);
    reFresehData();
    AppRouter.route.pop();
  }
}