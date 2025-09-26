import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';

Widget twoButtons({
  required String leftTitle,
  String? rightTitle,
  bool leftButton = true,
  bool rightButton = true,
  required VoidCallback leftOnTap,
  VoidCallback? rightOnTap,
}) {
  return Row(
    children: [
      if (leftButton)
        Expanded(
          flex: 5,
          child: CustomButton(
            fillColor: Colors.green,
            onTap: leftOnTap,
            title: leftTitle,
            isRadius: true,
          ),
        ),
      if (rightButton) ...[
        SizedBox(width: 10.w),
        Expanded(
          flex: 5,
          child: CustomButton(
            fillColor: Colors.red,
            onTap: rightOnTap,
            title: rightTitle,
            isRadius: true,
          ),
        ),
      ]
    ],
  );
}
