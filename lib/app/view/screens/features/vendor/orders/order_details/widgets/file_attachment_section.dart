import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/view/screens/features/vendor/orders/controller/order_controller.dart';
import 'package:local/app/view/screens/features/vendor/orders/order_details/widgets/file_picker_button.dart';
import 'package:local/app/view/screens/features/vendor/orders/order_details/widgets/selected_files_list.dart';

class FileAttachmentSection extends StatelessWidget {
  final OrdersController controller;

  const FileAttachmentSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 8),
        FilePickerButton(
          controller: controller,
          onFilesSelected: selectFiles,
        ),
        SelectedFilesList(controller: controller),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Attachments',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        Obx(() => controller.selectedFiles.isNotEmpty
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller.selectedFiles.length} file${controller.selectedFiles.length > 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade700,
                  ),
                ),
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Future<void> selectFiles() async {
    final Set<String> existingPaths =
        controller.selectedImages.map((file) => file.path).toSet();

    await controller.pickImages();

    if (controller.selectedImages.isNotEmpty) {
      final newFiles = controller.selectedImages.where((file) {
        return !existingPaths.contains(file.path);
      }).toList();

      if (newFiles.isEmpty) {
        toastMessage(message: 'Selected files already exist');
        return;
      }

      final newFileNames =
          newFiles.map((file) => file.path.split('/').last).toList();

      controller.selectedFiles.addAll(newFileNames);

      final duplicateCount = controller.selectedImages.length - newFiles.length;
      if (duplicateCount > 0) {
        toastMessage(
            message:
                '$duplicateCount duplicate file${duplicateCount > 1 ? 's' : ''} skipped');
      }
    }
  }
}