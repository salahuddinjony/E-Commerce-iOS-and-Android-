import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/category/controller/category_controller.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/category/widgets/category_name_input.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/common_widgets/image_upload_widget/image_upload_widget.dart';

class AddCategory extends StatefulWidget {
  final String imagePath;
  final String categoryName;
  final String method;
  final String? categoryId;

  const AddCategory({
    super.key,
    required this.imagePath,
    required this.categoryName,
    required this.method,
    this.categoryId,
  });

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final CategoryController categoryController = Get.find<CategoryController>();
  bool _initialValuesSet = false;

  @override
  void initState() {
    super.initState();
    // Set initial values only once when the widget is first created
    if (!_initialValuesSet) {
      categoryController.setInitialValues(widget.imagePath, widget.categoryName);
      _initialValuesSet = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.method == 'POST' ? 'Add Category' : 'Edit Category'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ImageUploadWidget(categoryController: categoryController),
              ImageUploadWidget<CategoryController>(
                controller: categoryController,
                imagePath: categoryController.imagePath,
                isNetworkImage: categoryController.isNetworkImage,
                onPickImage: (ctrl, source) => ctrl.pickImage(source: source),
                onClearImage: () => categoryController.clearImage(),
              ),

              SizedBox(height: 28.h),
              CategoryNameInputWidget(categoryController: categoryController),
              SizedBox(height: 32.h),
              CustomButton(
                onTap: () async {
                  print(
                      "Category Name: ${categoryController.nameController.text}");
                  print("Image Path: ${categoryController.imagePath.value}");
                  print(
                      "Is Network Image: ${categoryController.isNetworkImage.value}");
                  await categoryController.createCategoryPost(
                      widget.method, widget.categoryId ?? '', widget.imagePath, widget.categoryName);
                },
                title: widget.method == 'POST' ? 'Add' : 'Update',
                isRadius: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
