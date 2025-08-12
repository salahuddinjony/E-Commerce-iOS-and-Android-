import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/controller/vendor_product_controller.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';

class ImageUploadWidget extends StatelessWidget {
  final VendorProductController controller;

  const ImageUploadWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(() => Stack(
            children: [
              GestureDetector(
                onTap: () async {
                  await controller.pickImage();
                },
                child: Container(
                  width: 160.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: controller.imagePath.value.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_upload, size: 48, color: Colors.cyan[400]),
                            const SizedBox(height: 8),
                            Text(
                              'Upload Image',
                              style: TextStyle(color: Colors.grey[600], fontSize: 16),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: controller.isNetworkImage.value
                              ? CustomNetworkImage(
                                  imageUrl: controller.imagePath.value,
                                  width: 160.w,
                                  height: 120.w,
                                  boxShape: BoxShape.rectangle,
                                )
                              : Image.file(
                                  File(controller.imagePath.value),
                                  width: 160.w,
                                  height: 120.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print("File image error: $error");
                                    return _buildErrorWidget();
                                  },
                                ),
                        ),
                ),
              ),
              // Clear Button (shown only when an image is selected)
              if (controller.imagePath.value.isNotEmpty)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      controller.clearImage();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
            ],
          )),
    );
  }

  // Widget to display when image loading fails
  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 48, color: Colors.red[400]),
          SizedBox(height: 8),
          Text(
            'Failed to load image',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}