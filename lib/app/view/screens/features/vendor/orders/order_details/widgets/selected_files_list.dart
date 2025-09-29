import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/view/screens/features/vendor/orders/controller/order_controller.dart';
import 'package:local/app/view/screens/features/vendor/orders/order_details/widgets/file_item_widget.dart';

class SelectedFilesList extends StatelessWidget {
  final OrdersController controller;

  const SelectedFilesList({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.selectedFiles.isNotEmpty
        ? Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                const SizedBox(height: 8),
                _buildFilesList(),
              ],
            ),
          )
        : const SizedBox.shrink());
  }

  Widget _buildHeader() {
    return Text(
      'Selected Files:',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.blue.shade700,
      ),
    );
  }

  Widget _buildFilesList() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: controller.selectedFiles.length <= 3
          ? _buildStaticList()
          : _buildScrollableList(),
    );
  }

  Widget _buildStaticList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: controller.selectedFiles.asMap().entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: FileItemWidget(
            index: entry.key,
            fileName: entry.value,
            onRemove: () => _removeFileAt(entry.key),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildScrollableList() {
    return Scrollbar(
      thumbVisibility: true,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: controller.selectedFiles.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: FileItemWidget(
              index: index,
              fileName: controller.selectedFiles[index],
              onRemove: () => _removeFileAt(index),
            ),
          );
        },
      ),
    );
  }

  void _removeFileAt(int index) {
    if (index < controller.selectedFiles.length) {
      controller.selectedFiles.removeAt(index);
    }
    if (index < controller.selectedImages.length) {
      controller.selectedImages.removeAt(index);
    }
  }
}