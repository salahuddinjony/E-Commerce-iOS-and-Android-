import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';

class LabeledTextField extends StatelessWidget {
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
  final Rx<File?>? fileRx;

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
    this.isDocumentPicker = false,
    this.onFilePicked,
    this.fileRx,
  });

  Future<void> showDropdownOptions(BuildContext context) async {
    if (dropdownOptions == null || dropdownOptions!.isEmpty) return;

    final selected = await showModalBottomSheet<String>(
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: dropdownOptions!.length,
              itemBuilder: (context, index) {
                final option = dropdownOptions![index];
                return ListTile(
                  leading: Text("${index + 1}."),
                  trailing: controller.text.trim().toLowerCase() == option.toLowerCase()
                      ? const Icon(Icons.check, color: AppColors.brightCyan, size: 25)
                      : null,
                  title: Text(option),
                  onTap: () {
                    Navigator.pop(context, option);
                  },
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
          ),
        );
      },
    );

    if (selected != null) {
      controller.text = selected;
    }
  }

  Future<void> pickDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      controller.text = pickedFile.name;
      if (fileRx != null) fileRx!.value = file;
      if (onFilePicked != null) onFilePicked!(file);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          top: 8.h,
          text: label,
          fontSize: 16.sp,
          bottom: 8.h,
          fontWeight: FontWeight.w500,
          color: AppColors.darkNaturalGray,
        ),
        CustomTextField(
          readOnly: readOnly || isDropdown || isDocumentPicker,
          inputTextStyle: const TextStyle(color: AppColors.black),
          fieldBorderColor: AppColors.borderColor,
          textEditingController: controller,
          prefixIcon: Icon(icon),
          suffixIcon: isDropdown
              ? GestureDetector(
                  onTap: () => showDropdownOptions(context),
                  child: const Icon(Icons.arrow_drop_down),
                )
              : null,
          hintText: hintText,
          validator: validator,
          onTap: isDocumentPicker
              ? pickDocument
              : (isDropdown ? () => showDropdownOptions(context) : onTap),
        ),
        if (fileRx != null) ...[
          SizedBox(height: 10.h),
          Obx(() {
            final file = fileRx!.value;
            if (file == null) return const SizedBox.shrink();
            return ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.file(
                file,
                height: 120.h,
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
