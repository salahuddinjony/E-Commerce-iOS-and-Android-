import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local/app/core/routes.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/services/category_services.dart';

class CategoryController extends GetxController
    with CategoryServices {
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



// Image Picker
  Future<void> pickImage({required String source}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
       source: source == "camera"
          ? ImageSource.camera
          : ImageSource.gallery,
        );
        
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

  

  void reFresehData() async{
    print("Refreshing data");
    await fetchCategories();
    clear();
  }

// Create or Update Category
  Future<void> createCategoryPost(String method, String id, String passedImage, String passedName) async {
    String name = nameController.text.trim();
    String imagePath = this.imagePath.value.trim();

   
    if (method == 'PATCH') {
      if (name == passedName && imagePath == passedImage) {
        EasyLoading.showInfo('No changes detected');
        print("Validation failed: No changes detected (name=$name, imagePath=$imagePath)");
        return;
      }
    }

   
    if (name.isEmpty) {
      EasyLoading.showInfo('Name cannot be empty');
      print("Validation failed: name is empty");
      return;
    }
    if (method == 'POST' && imagePath.isEmpty) {
      EasyLoading.showInfo('Image cannot be empty');
      print("Validation failed: imagePath is empty for POST");
      return;
    }
    if (method == 'PATCH' && (id.isEmpty || id == 'null')) {
      EasyLoading.showInfo('Category ID is required for updating');
      print("Validation failed: categoryId is empty for PATCH");
      return;
    }

    print("Creating/Updating category: method=$method, id=$id, name=$name, imagePath=$imagePath, isNetworkImage=${isNetworkImage.value}");
    await createUpdateCategory(
      name: name,
      imagePath: imagePath,
      method: method,
      id: id,
    );
    
    reFresehData();
    AppRouter.route.pop();
  }
}