import 'package:get/get_utils/src/get_utils/get_utils.dart';

class Validators {
  //>>>>>>>✅✅ EmailValidator ✅✅ <<<<<<<<=============
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!GetUtils.isEmail(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  //>>>>>>>✅✅ PasswordValidator ✅✅ <<<<<<<<=============
  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  //>>>>>>>✅✅ Confirm PasswordValidator ✅✅ <<<<<<<<=============
  static String? confirmPasswordValidator(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    } else if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  //>>>>>>>✅✅ NameValidator ✅✅ <<<<<<<<=============
  static String? nameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Only alphabetic characters and spaces are allowed';
    }
    return null;
  }

  //>>>>>>>✅✅ PhoneNumberValidator ✅✅ <<<<<<<<=============
  // Supports Bangladeshi and U.S. formats (e.g. 561-850-3557, (561) 850-3557, +1 5618503557).
  static String? phoneNumberValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    final v = value.trim();

    // Bangladesh (as before)
    final bdRegex = RegExp(r'^(?:\+88|88)?01[1-9]\d{8}$');

    // U.S. formats: optional +1 or 1 prefix, parentheses, dashes, dots or spaces
    final usRegex = RegExp(
      r'^(?:\+1[-.\s]?|1[-.\s]?)?(?:\([2-9]\d{2}\)|[2-9]\d{2})[-.\s]?\d{3}[-.\s]?\d{4}$',
    );

    if (bdRegex.hasMatch(v) || usRegex.hasMatch(v)) {
      return null;
    }
    return 'Enter a valid phone number';
  }

  // Helper: formats U.S. phone number to the standard 123-456-7890 form when possible.
  // If input isn't a 10-digit (or leading 1 + 10 digits) U.S. number, returns original input.
  static String formatUSPhoneNumber(String input) {
    final digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11 && digits.startsWith('1')) {
      final d = digits.substring(1);
      return '${d.substring(0, 3)}-${d.substring(3, 6)}-${d.substring(6)}';
    } else if (digits.length == 10) {
      return '${digits.substring(0, 3)}-${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    return input;
  }
}
