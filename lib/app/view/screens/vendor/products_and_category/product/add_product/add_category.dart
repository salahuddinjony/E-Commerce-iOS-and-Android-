import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/vendor/produtcs_and_category/category/controller/category_controller.dart';
import 'package:get/get.dart';

class AddCategory extends StatelessWidget {
  AddCategory({super.key});

  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Add Category'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Image Area
              Center(
                child: Obx(() => GestureDetector(
                      onTap: () async {
                        await categoryController.pickImage();
                      },
                      child: Container(
                        width: 160.w,
                        height: 120.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: categoryController.imagePath.value.isEmpty
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud_upload,
                                      size: 48, color: Colors.cyan[400]),
                                  SizedBox(height: 8),
                                  Text('Upload Image',
                                      style: TextStyle(
                                          color: Colors.grey[600], fontSize: 16)),
                                ],
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.file(
                                  File(categoryController.imagePath.value),
                                  width: 160.w,
                                  height: 120.w,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    )),
              ),
              SizedBox(height: 28.h),
              // Category Name
              const Text('Category Name', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter category name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onChanged: categoryController.setName,
              ),
              const SizedBox(height: 32),
              // Add Button
               CustomButton(
            onTap: (){

        
            },
            title: "Add",
            isRadius: true,
          ),
            ],
          ),
        ),
      ),
    );
  }
}