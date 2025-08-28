
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomFont { inter, poppins }

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.maxLines,
    this.textAlign = TextAlign.center,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w300,
    this.color = Colors.green,
    this.overflow = TextOverflow.ellipsis,
    this.decoration,
    this.font = CustomFont.inter, // Default is Inter
  });

  final double left;
  final double right;
  final double top;
  final double bottom;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final TextDecoration? decoration;
  final CustomFont font; // New parameter for font selection

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: Text(
        text,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
        style: _getTextStyle(),
      ),
    );
  }

  TextStyle _getTextStyle() {
    switch (font) {
      case CustomFont.poppins:
        return GoogleFonts.poppins(
          fontSize: fontSize.sp,
          fontWeight: text.contains('Price') ? FontWeight.bold : fontWeight,
          color: color,
          decoration: decoration,
        );
      case CustomFont.inter:
      return GoogleFonts.inter(
          fontSize: fontSize.sp,
          fontWeight: fontWeight,
          color: color,
          decoration: decoration,
        );
    }
  }
}
