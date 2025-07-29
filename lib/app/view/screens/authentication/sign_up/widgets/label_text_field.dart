import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';

class LabeledTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final IconData icon;
  final bool readOnly;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool isDropdown;
  final List<String>? dropdownOptions;
  final bool isDocumentPicker;
  final ValueChanged<File>? onFilePicked;


  const LabeledTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.icon,
    this.readOnly = false,
    this.validator,
    this.keyboardType,
    this.onTap,
    this.isDropdown = false,
    this.dropdownOptions,
    this.isDocumentPicker = false, this.onFilePicked,
  });

  @override
  State<LabeledTextField> createState() => _LabeledTextFieldState();
}

class _LabeledTextFieldState extends State<LabeledTextField> {
  File? selectedImage;

  void _showDropdownOptions(BuildContext context) async {
    if (widget.dropdownOptions == null || widget.dropdownOptions!.isEmpty) return;

    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: widget.dropdownOptions!
              .map((option) => ListTile(
            title: Text(option),
            onTap: () {
              Navigator.pop(context, option);
            },
          ))
              .toList(),
        );
      },
    );

    if (selected != null) {
      widget.controller.text = selected;
    }
  }

  Future<void> _pickDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        widget.controller.text = pickedFile.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          top: 8.h,
          text: widget.label,
          fontSize: 16.sp,
          bottom: 8.h,
          fontWeight: FontWeight.w500,
          color: AppColors.darkNaturalGray,
        ),
        CustomTextField(
          readOnly: widget.readOnly || widget.isDropdown || widget.isDocumentPicker,
          inputTextStyle: const TextStyle(color: AppColors.black),
          fieldBorderColor: AppColors.borderColor,
          textEditingController: widget.controller,
          prefixIcon: Icon(widget.icon),
          suffixIcon: widget.isDropdown
              ? GestureDetector(
            onTap: () => _showDropdownOptions(context),
            child: const Icon(Icons.arrow_drop_down),
          )
              : null,
          hintText: widget.hintText,
          validator: widget.validator,
          onTap: widget.isDocumentPicker
              ? _pickDocument
              : (widget.isDropdown ? () => _showDropdownOptions(context) : widget.onTap),
        ),
        if (selectedImage != null) ...[
          SizedBox(height: 10.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Image.file(
              selectedImage!,
              height: 120.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ],
    );
  }
}
