import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';

class CustomFromCard extends StatefulWidget {
  final String title;
  final String? hinText;
  final TextEditingController? controller; // now optional
  final String? Function(String?) validator;
  final bool isPassword;
  final bool isRead;
  final bool? isBgColor;
  final int? maxLine;

  const CustomFromCard({
    super.key,
    required this.title,
    required this.validator,
    this.controller,
    this.isPassword = false,
    this.isRead = false,
    this.hinText,
    this.maxLine,
    this.isBgColor = false,
  });

  @override
  State<CustomFromCard> createState() => _CustomFromCardState();
}

class _CustomFromCardState extends State<CustomFromCard> {
  TextEditingController? _ownedController;

  TextEditingController get _effectiveController =>
      widget.controller ?? (_ownedController ??= TextEditingController());

  bool get _ownsController => widget.controller == null;

  @override
  void dispose() {
    if (_ownsController) {
      _ownedController?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          font: CustomFont.inter,
          color: AppColors.darkNaturalGray,
          text: widget.title,
            fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          bottom: 8.h,
        ),
        CustomTextField(
          maxLines: widget.isPassword ? 1 : (widget.maxLine ?? 1),
          hintStyle: const TextStyle(color: AppColors.black),
          readOnly: widget.isRead,
          validator: widget.validator,
          isPassword: widget.isPassword,
          textEditingController: _effectiveController,
          hintText: widget.hinText,
          inputTextStyle: const TextStyle(color: AppColors.black),
          fillColor: widget.isBgColor == true ? AppColors.black : AppColors.white,
          fieldBorderColor: AppColors.borderColor,
          keyboardType: widget.isPassword
              ? TextInputType.visiblePassword
              : TextInputType.text,
        ),
        SizedBox(height: 14.h),
      ],
    );
  }
}
