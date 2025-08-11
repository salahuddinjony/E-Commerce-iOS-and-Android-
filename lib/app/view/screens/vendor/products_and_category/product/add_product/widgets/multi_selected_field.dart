import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class MultiSelectField extends StatelessWidget {
  final String title;
  final List<MultiSelectItem<String>> items;
  final RxList<String> selectedValues;
  final String hintText;
  final String searchHint;
  final Function(List<String>) onConfirm;

  const MultiSelectField({
    super.key,
    required this.title,
    required this.items,
    required this.selectedValues,
    required this.hintText,
    required this.searchHint,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
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
          () => MultiSelectDialogField<String>(
            items: items,
            initialValue: selectedValues.toList(),
            title: Text("Select $title"),
            selectedColor: Colors.black,
            backgroundColor: AppColors.white,
            dialogHeight: 300.h,
            searchable: true,
            searchHint: searchHint,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
              border: Border.all(color: Colors.grey.shade300),
            ),
            buttonText: Text(
              selectedValues.isEmpty
                  ? hintText
                  : selectedValues
                      .map((hex) => items
                          .firstWhere(
                            (item) => item.value == hex,
                            orElse: () => items.first,
                          )
                          .label)
                      .join(", "),
              style: TextStyle(
                color: AppColors.darkNaturalGray,
                fontSize: 16.sp,
              ),
            ),
            chipDisplay: MultiSelectChipDisplay.none(),
            buttonIcon: const Icon(
              Icons.arrow_drop_down,
              color: AppColors.darkNaturalGray,
            ),
            onConfirm: onConfirm,
          ),
        ),
      ],
    );
  }
}