import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/controller/category_controller.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/widgets/category_name_input.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/widgets/image_upload_widget.dart';

class AddCategory extends StatelessWidget {
  final String imagePath;
  final String categoryName;
  final String method;
  final String? categoryId;

  AddCategory({
    super.key,
    required this.imagePath,
    required this.categoryName,
    required this.method,
    this.categoryId,
  });

  final CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    // Set initial values for the controller
    categoryController.setInitialValues(imagePath, categoryName);

    return Scaffold(
     backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(method == 'POST' ? 'Add Category' : 'Edit Category'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageUploadWidget(categoryController: categoryController),
              SizedBox(height: 28.h),
              CategoryNameInputWidget(categoryController: categoryController),
              SizedBox(height: 32.h),
              CustomButton(
                onTap: () async {
                  print("Category Name: ${categoryController.nameController.text}");
                  print("Image Path: ${categoryController.imagePath.value}");
                  print("Is Network Image: ${categoryController.isNetworkImage.value}");
                  await categoryController.createCategoryPost(method, categoryId ?? '',imagePath, categoryName );
                },
                title: method == 'POST' ? 'Add' : 'Update',
                isRadius: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}