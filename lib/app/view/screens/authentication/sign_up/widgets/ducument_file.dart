
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DocumentPickerField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Function(File)? onFilePicked;

  const DocumentPickerField({
    super.key,
    required this.label,
    required this.controller,
    this.onFilePicked,
  });

  @override
  State<DocumentPickerField> createState() => _DocumentPickerFieldState();
}

class _DocumentPickerFieldState extends State<DocumentPickerField> {
  File? selectedFile;

  Future<void> _pickDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        selectedFile = file;
        widget.controller.text = pickedFile.name;
      });
      if (widget.onFilePicked != null) {
        widget.onFilePicked!(file);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDocument,
          child: AbsorbPointer(
            child: TextField(
              controller: widget.controller,
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
      ],
    );
  }
}
