import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/view/screens/features/vendor/orders/controller/order_controller.dart';

class FilePickerButton extends StatelessWidget {
  final OrdersController controller;
  final VoidCallback onFilesSelected;

  const FilePickerButton({
    super.key,
    required this.controller,
    required this.onFilesSelected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onFilesSelected,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: controller.selectedFiles.isEmpty
                ? Colors.grey.shade300
                : Colors.blue.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Obx(() => Row(
              children: [
                _buildIcon(),
                const SizedBox(width: 12),
                Expanded(child: _buildContent()),
                if (controller.selectedFiles.isNotEmpty) _buildClearButton(),
              ],
            )),
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: controller.selectedFiles.isEmpty
            ? Colors.grey.shade100
            : Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        controller.selectedFiles.isEmpty
            ? Icons.attach_file_outlined
            : Icons.folder_open_outlined,
        color: controller.selectedFiles.isEmpty
            ? Colors.grey.shade600
            : Colors.blue.shade700,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          controller.selectedFiles.isEmpty ? 'Tap to select files' : 'Files selected',
          style: TextStyle(
            color: controller.selectedFiles.isEmpty
                ? Colors.grey.shade600
                : Colors.grey.shade800,
            fontWeight: controller.selectedFiles.isEmpty
                ? FontWeight.normal
                : FontWeight.w600,
          ),
        ),
        Text(
          controller.selectedFiles.isEmpty
              ? 'PDF, DOC, or Image files'
              : 'Tap to change selection',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade500,
          ),
        ),
      ],
    );
  }

  Widget _buildClearButton() {
    return IconButton(
      onPressed: () {
        controller.selectedFiles.clear();
        controller.selectedImages.clear();
      },
      icon: Icon(
        Icons.close,
        color: Colors.grey.shade600,
        size: 20,
      ),
    );
  }
}