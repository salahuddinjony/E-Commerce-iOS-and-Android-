import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class DocumentPickerField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Function(File)? onFilePicked;
  final Rx<File?>? selectedFileRx;

  const DocumentPickerField({
    super.key,
    required this.label,
    required this.controller,
    this.onFilePicked,
    this.selectedFileRx,
  });

  Future<void> _pickDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      controller.text = pickedFile.name;
      if (selectedFileRx != null) selectedFileRx!.value = file;
      if (onFilePicked != null) onFilePicked!(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDocument,
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Choose file',
                suffixIcon: const Icon(Icons.attach_file),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
        if (selectedFileRx != null) ...[
          const SizedBox(height: 8),
          Obx(() {
            final file = selectedFileRx!.value;
            if (file == null) return const SizedBox.shrink();
            return ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                file,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            );
          }),
        ],
      ],
    );
  }
}
