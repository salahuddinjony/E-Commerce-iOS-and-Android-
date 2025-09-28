import 'package:flutter/material.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/image_preview_dialog.dart';

class DesignFilesGallery extends StatelessWidget {
  final List<dynamic> designFiles;
  final double height;
  final double width;

  const DesignFilesGallery({
    super.key,
    required this.designFiles,
    this.height = 100,
    this.width = 100,
  });

  List<dynamic> get safeDesignFiles {
    if (designFiles.isEmpty) return [];
    return designFiles
        .where((file) => file != null && file.toString().isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final safeFiles = safeDesignFiles;

    if (safeFiles.isEmpty) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
    }

    // if (safeFiles.length == 1) {
    //   return GestureDetector(
    //     onTap: () => showImagePreview(context, 0),
    //     child: CustomNetworkImage(
    //       imageUrl: safeFiles[0].toString().replaceFirst(
    //             'http://10.10.20.19:5007',
    //             'https://gmosley-uteehub-backend.onrender.com',
    //           ),
    //       height: height,
    //       width: width,
    //       borderRadius: BorderRadius.circular(8),
    //     ),
    //   );
    // }

    return SizedBox(
      height: height,
      width: width,
      child: Stack(
        children: [
          // Main image
          GestureDetector(
            onTap: () => showImagePreview(context, 0),
            child: CustomNetworkImage(
              imageUrl: safeFiles[0].toString().replaceFirst(
                    'http://10.10.20.19:5007',
                    'https://gmosley-uteehub-backend.onrender.com',
                  ),
              height: height,
              width: width,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          // Overlay for additional images count
          if (safeFiles.length >= 1)
            Positioned(
              bottom: 4,
              right: 4,
              child: GestureDetector(
                onTap: () => showGalleryPreview(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: .7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    safeFiles.length == 1
                        ? 'Preview'
                        : '+${safeFiles.length - 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void showImagePreview(BuildContext context, int initialIndex) {
    final safeFiles = safeDesignFiles;
    showDialog(
      context: context,
      builder: (context) => ImagePreviewDialog(
        images: safeFiles.map((file) => file.toString()).toList(),
        initialIndex: initialIndex,
      ),
    );
  }

  void showGalleryPreview(BuildContext context) {
    final safeFiles = safeDesignFiles;
    showDialog(
      context: context,
      builder: (context) => ImagePreviewDialog(
        images: safeFiles.map((file) => file.toString()).toList(),
        initialIndex: 0,
      ),
    );
  }
}
