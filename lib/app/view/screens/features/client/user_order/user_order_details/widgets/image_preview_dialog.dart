import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/screens/features/client/user_order/controller/image_preview_controller.dart';

class ImagePreviewDialog extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const ImagePreviewDialog({
    super.key,
    required this.images,
    this.initialIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ImagePreviewController>(
      init: ImagePreviewController()..initializeController(initialIndex),
      builder: (controller) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Header with close button and image counter
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Text(
                            'Design Images (${controller.currentIndex.value + 1}/${images.length})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Image viewer
                Expanded(
                  child: PageView.builder(
                    controller: controller.pageController,
                    onPageChanged: controller.onPageChanged,
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        child: InteractiveViewer(
                          panEnabled: true,
                          scaleEnabled: true,
                          minScale: 0.5,
                          maxScale: 3.0,
                          child: Center(
                            child: CustomNetworkImage(
                              imageUrl: images[index],
                              height: double.infinity,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Thumbnail strip (if more than one image)
                if (images.length > 1)
                  Container(
                    height: 80,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final isSelected =
                              index == controller.currentIndex.value;
                          return GestureDetector(
                            onTap: () => controller.animateToPage(index),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                border: isSelected
                                    ? Border.all(color: Colors.blue, width: 2)
                                    : null,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: CustomNetworkImage(
                                imageUrl: images[index],
                                height: 64,
                                width: 64,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }
}
