import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/services/category_services.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/add_product/services/create_product.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/model/product_response.dart';

class VendorProductController extends GetxController with CategoryServices,CreateProduct {
  var userIndex = "product".obs;

  void toggleUserIndex({required String selectedIndex}) {
    userIndex.value = selectedIndex;
  }

  RxList<ProductItem> productItems = <ProductItem>[].obs;
 final searchController = TextEditingController();
  final RxList<dynamic> filteredCategories = <dynamic>[].obs; 

  
  // final productNameController = TextEditingController();
  // final priceController = TextEditingController();

  // //For category selection
  // final searchController = TextEditingController();
  // final RxList<dynamic> filteredCategories = <dynamic>[].obs; 
  // RxString selectedCategory = ''.obs;

  // //For color, size, and customizable options
  // RxList<String> selectedColor = <String>[].obs; 
  // RxList<String> selectedSize = <String>[].obs; 
  // RxString selectedCustomizable = ''.obs;

  // RxString selectedImagePath = ''.obs;
  // RxString selectedProductId = ''.obs;

  // RxBool isLoading = false.obs;

  // final isNetworkImage = false.obs;
  // var imagePath = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    filteredCategories.assignAll(categoriesData);
  }

  // Method to filter categories based on search input
  void filterCategories(String query) {
    if (query.isEmpty) {
      filteredCategories.assignAll(categoriesData);
    } else {
      filteredCategories.assignAll(
        categoriesData
            .where((category) =>
                category.name.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }




//   final Map<String, String> colors = {
//     "Black": "#000000",
//     "White": "#FFFFFF",
//     "Red": "#FF0000",
//     "Green": "#00FF00",
//     "Blue": "#0000FF",
//     "Yellow": "#FFFF00",
//     "Pink": "#FFC0CB",
//     "Purple": "#800080",
//     "Orange": "#FFA500",
//   };
//   final List<String> sizes = [
//     "S",
//     "M",
//     "L",
//     "XL",
//     "XXL",
//   ];
//   final List<String> customizable = [
//     "Yes",
//     "No",
//   ];
//   Future<void> pickImage() async {
//     try {
//       final picker = ImagePicker();
//       final pickedFile = await picker.pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         print("New image picked: ${pickedFile.path}");
//         imagePath.value = pickedFile.path;
//         isNetworkImage.value = false;
//       } else {
//         print("No image selected");
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//       EasyLoading.showError('Failed to pick image: $e');
//     }
//   }


//   void setSelectedCategory(String category) {
//     selectedCategory.value = category;
//   }

//   void setSelectedColor(List<String> color) {
//     selectedColor.assignAll(color);
//   }

//   void setSelectedSize(List<String> size) {
//     selectedSize.assignAll(size);
//   }

//   void setSelectedCustomizable(String customizable) {
//     selectedCustomizable.value = customizable;
//   }

//   void getAllData(){
//     print("Selected Category: ${selectedCategory.value}");
//     print("Selected Colors: ${selectedColor.join(', ')}");
//     print("Selected Sizes: ${selectedSize.join(', ')}");
//     print("Selected Customizable: ${selectedCustomizable.value}");
//     print("Image Path: ${imagePath.value}");
//     print("Product Name: ${productNameController.text}");
//     print("Price: ${priceController.text}");
//   }
//   void clearImage() {
//   imagePath.value = '';
//   isNetworkImage.value = false;
// }



//   void clear() {
//     productNameController.clear();
//     priceController.clear();
//     selectedCategory.value = '';
//     selectedColor.clear();
//     selectedSize.clear();
//     selectedCustomizable.value = '';
//     imagePath.value = '';
//     isNetworkImage.value = false;
//   }

  @override
  void onClose() {
    productNameController.dispose();
    priceController.dispose();
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchProducts() async {
    EasyLoading.show(
      status: 'Loading products...',
      maskType: EasyLoadingMaskType.black,
    );
    try {
      final response = await http.get(
        Uri.parse(ApiUrl.productList),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Products loaded successfully');
        final responseData = json.decode(response.body);
        final productResponse = ProductResponse.fromJson(responseData['data']);
        print(responseData['message']);
        print(
            "Products fetched successfully: ${productResponse.data.length} items");
        print("Product Response: ${responseData['data']}");
        print("Product Items: ${productResponse.data}");
        print("Product Items Value: ${productItems.value}");

        productItems.value = productResponse.data;
      } else if (response.statusCode == 404) {
        EasyLoading.showError('Failed to load(Randomly picked an emoji to add some fun 😄) products');
        print("No products found");
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      EasyLoading.showError('Failed to load products: $e');
      print("Error fetching products: $e");
    } finally {
      EasyLoading.dismiss();
    }
  }
}