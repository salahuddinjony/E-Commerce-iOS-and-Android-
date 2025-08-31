import 'package:get/get.dart';

mixin PasswordConstraintController on GetxController {
  final RxBool minchar = false.obs;
  final RxBool upper = false.obs;
  final RxBool special = false.obs;
  final RxBool number = false.obs;
  final RxBool areTrue = false.obs;

  void getBool(String value) {
    final v = value;
    minchar.value = v.length >= 8 && v.length <= 12;
    upper.value = v.contains(RegExp(r'[A-Z]'));
    special.value = v.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    number.value = v.contains(RegExp(r'[0-9]'));
    areTrue.value = minchar.value && upper.value && special.value && number.value;
  }

  void reset() {
    minchar.value = false;
    upper.value = false;
    special.value = false;
    number.value = false;
    areTrue.value = false;
  }

  @override
  void onClose() {
    // clear if needed
    super.onClose();
  }
}