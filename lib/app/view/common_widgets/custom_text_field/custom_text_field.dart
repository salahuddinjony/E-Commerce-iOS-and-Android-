import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart';
import 'custom_text_field_controller.dart';

class CustomTextField extends StatelessWidget {
  final CustomTextFieldController controller;

  CustomTextField({
    Key? key,
    this.inputFormatters,
    this.onFieldSubmitted,
    this.textEditingController,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.cursorColor = Colors.greenAccent,
    this.isColor = false,
    this.inputTextStyle,
    this.textAlignVertical = TextAlignVertical.center,
    this.textAlign = TextAlign.start,
    this.onChanged,
    this.maxLines = 1,
    this.validator,
    this.hintText,
    this.hintStyle,
    this.fillColor = Colors.white,
    this.suffixIcon,
    this.suffixIconColor,
    this.fieldBorderRadius = 8,
    this.fieldBorderColor = const Color(0xffB5D8EE),
    this.isPassword = false,
    this.isPrefixIcon = true,
    this.readOnly = false,
    this.maxLength,
    this.prefixIcon,
    this.onTap,
  }) : controller = CustomTextFieldController(),
       super(key: key);

  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Color cursorColor;
  final bool? isColor;
  final TextStyle? inputTextStyle;
  final TextAlignVertical? textAlignVertical;
  final TextAlign textAlign;
  final int? maxLines;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FormFieldValidator<String>? validator;
  final String? hintText;
  final TextStyle? hintStyle;
  final Color? fillColor;
  final Color? suffixIconColor;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double fieldBorderRadius;
  final Color fieldBorderColor;
  final bool isPassword;
  final bool isPrefixIcon;
  final bool readOnly;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = inputTextStyle ??
        TextStyle(
          color: isColor! ? Colors.white : Colors.red,
        );

    if (isPassword) {
      return Obx(() => TextFormField(
            onTap: onTap,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            inputFormatters: inputFormatters,
            onFieldSubmitted: onFieldSubmitted,
            readOnly: readOnly,
            controller: textEditingController,
            focusNode: focusNode,
            maxLength: maxLength,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            cursorColor: cursorColor,
            style: textStyle,
            onChanged: onChanged,
            maxLines: maxLines,
            obscureText: controller.obscureText.value,
            validator: validator,
            decoration: InputDecoration(
              errorMaxLines: 2,
              errorStyle: const TextStyle(
                color: Colors.red,
                fontSize: 16,
              ),
              hintText: hintText,
              hintStyle: hintStyle,
              fillColor: fillColor,
              filled: true,
              prefixIcon: prefixIcon,
              suffixIcon: GestureDetector(
                onTap: controller.toggle,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 16, bottom: 16),
                  child: controller.obscureText.value
                      ? Assets.icons.eyeOff.svg()
                      : Assets.icons.eye.svg(),
                ),
              ),
              suffixIconColor: suffixIconColor,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(fieldBorderRadius),
                  borderSide: BorderSide(color: fieldBorderColor, width: 1),
                  gapPadding: 0),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(fieldBorderRadius),
                  borderSide: BorderSide(color: fieldBorderColor, width: 1),
                  gapPadding: 0),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(fieldBorderRadius),
                  borderSide: BorderSide(color: fieldBorderColor, width: 1),
                  gapPadding: 0),
            ),
          ));
    }

    // Non-password field — no Obx required
    return TextFormField(
      onTap: onTap,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: inputFormatters,
      onFieldSubmitted: onFieldSubmitted,
      readOnly: readOnly,
      controller: textEditingController,
      focusNode: focusNode,
      maxLength: maxLength,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      cursorColor: cursorColor,
      style: textStyle,
      onChanged: onChanged,
      maxLines: maxLines,
      obscureText: false,
      validator: validator,
      decoration: InputDecoration(
        errorMaxLines: 2,
        errorStyle: const TextStyle(
          color: Colors.red,
          fontSize: 16,
        ),
        hintText: hintText,
        hintStyle: hintStyle,
        fillColor: fillColor,
        filled: true,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        suffixIconColor: suffixIconColor,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(fieldBorderRadius),
            borderSide: BorderSide(color: fieldBorderColor, width: 1),
            gapPadding: 0),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(fieldBorderRadius),
            borderSide: BorderSide(color: fieldBorderColor, width: 1),
            gapPadding: 0),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(fieldBorderRadius),
            borderSide: BorderSide(color: fieldBorderColor, width: 1),
            gapPadding: 0),
      ),
    );
   }
}
