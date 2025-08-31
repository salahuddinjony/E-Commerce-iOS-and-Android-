import 'package:get/get.dart';

class CustomTextFieldController extends GetxController {
  /// Controls whether the text is obscured (for password fields).
  final RxBool obscureText = false.obs;

  void toggle() => obscureText.value = !obscureText.value;
}