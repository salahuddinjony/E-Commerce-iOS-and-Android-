import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class SingleSelectDropdown extends StatelessWidget {
  final String title;
  final List<String> options;
  final RxString selectedValue;
  final String hintText;
  final Function(String) onChanged;

  const SingleSelectDropdown({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValue,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure options are unique to prevent dropdown errors
    final uniqueOptions = options.toSet().toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          font: CustomFont.inter,
          color: AppColors.darkNaturalGray,
          text: title,
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          bottom: 8.h,
        ),
        Obx(
          () => DropdownButtonFormField<String>(
            initialValue: selectedValue.value.isEmpty || !uniqueOptions.contains(selectedValue.value)
                ? null
                : selectedValue.value,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: AppColors.darkNaturalGray),
              ),
            ),
            dropdownColor: AppColors.white,
            hint: Text(hintText),
            items: uniqueOptions.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                onChanged(value);
              }
            },
          ),
        ),
      ],
    );
  }
}