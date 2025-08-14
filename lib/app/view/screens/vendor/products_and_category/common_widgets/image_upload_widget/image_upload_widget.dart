import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/screens/vendor/products_and_category/common_widgets/image_upload_widget/image_picker_option.dart';

class ImageUploadWidget<T> extends StatelessWidget {
  final T controller;
  final RxString imagePath; 
  final RxBool isNetworkImage; 
  final Future<void> Function(T controller, String source) onPickImage;
  final VoidCallback onClearImage;

  const ImageUploadWidget({
    super.key,
    required this.controller,
    required this.imagePath,
    required this.isNetworkImage,
    required this.onPickImage,
    required this.onClearImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Obx(
        () => Stack(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (_) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.3,
                      minChildSize: 0.3,
                      maxChildSize: 0.9,
                      expand: false,
                      builder: (context, scrollController) {
                        return ImagePickerOption<T>(
                          controller: controller,
                          scrollController: scrollController,
                          onPickImage: onPickImage,
                        );
                      },
                    );
                  },
                );
              },
              child: Container(
                width: 160.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: imagePath.value.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.cloud_upload,
                              size: 48, color: Colors.cyan[400]),
                          const SizedBox(height: 8),
                          Text(
                            'Upload Image',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: isNetworkImage.value
                            ? CustomNetworkImage(
                                imageUrl: imagePath.value,
                                width: 160.w,
                                height: 120.w,
                                boxShape: BoxShape.rectangle,
                              )
                            : Image.file(
                                File(imagePath.value),
                                width: 160.w,
                                height: 120.w,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildErrorWidget();
                                },
                              ),
                      ),
              ),
            ),
            if (imagePath.value.isNotEmpty)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onClearImage,
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
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error, size: 48, color: Colors.red[400]),
          const SizedBox(height: 8),
          Text(
            'Failed to load image',
            style: TextStyle(color: Colors.grey[600], fontSize: 16),
          ),
        ],
      ),
    );
  }
}
