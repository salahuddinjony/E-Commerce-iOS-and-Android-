import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class TextSection extends StatelessWidget {
  final String title;
  final String content;

  const TextSection({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          textAlign: TextAlign.start,
          text: title,
          fontWeight: FontWeight.w500,
          fontSize: 16.sp,
          font: CustomFont.poppins, // Assuming you're using custom font here
          color: AppColors.black,
          maxLines: 3,
        ),
        SizedBox(height: 8.h), // Spacing between title and content
        CustomText(
          textAlign: TextAlign.start,
          text: content,
          fontWeight: FontWeight.w400,
          fontSize: 12.sp,
          font: CustomFont.poppins,
          color: AppColors.naturalGray,
          maxLines: 10,
        ),
        SizedBox(height: 30.h), // Spacing between sections
      ],
    );
  }
}
