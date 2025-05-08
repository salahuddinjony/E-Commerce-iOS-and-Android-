import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';


class CustomRichText extends StatelessWidget {
  final String firstText;
  final String secondText;
  final VoidCallback onTapAction;
  final TextStyle? firstTextStyle;
  final TextStyle? secondTextStyle;
  final int? maxLines;
  final TextAlign textAlign;

  const  CustomRichText({
    super.key,
    required this.firstText,
    required this.secondText,
    required this.onTapAction,
    this.firstTextStyle,
    this.secondTextStyle,
    this.maxLines = 1,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: textAlign,
        maxLines: maxLines,
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
              text: firstText,
              style: firstTextStyle ??
                  const TextStyle(
                    color: AppColors.naturalGray,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
            ),
            TextSpan(
              text: secondText,
              style: secondTextStyle ??
                  const TextStyle(
                    color: AppColors.brightCyan,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
              recognizer: TapGestureRecognizer()..onTap = onTapAction,
            ),
          ],
        ),
      ),
    );
  }
}
