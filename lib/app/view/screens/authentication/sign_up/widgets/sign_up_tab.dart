import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../controller/auth_controller.dart';

class SIgnUpTab extends StatelessWidget {
  const SIgnUpTab({
    super.key,
    required this.controller,
  });

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ChoiceChip(
          avatar: controller.isClientSelected.value
              ? null
              : Icon(Icons.person, color: Colors.black),
          checkmarkColor: Colors.white,
          backgroundColor: Colors.white,
          label: const Text('Client'),
          selected: controller.isClientSelected.value,
          onSelected: (_) => controller.toggleClientVendor(true),
          selectedColor: Colors.teal,
          labelStyle: TextStyle(
            color:
                controller.isClientSelected.value ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(width: 16.w),
        ChoiceChip(
          label: const Text('Business Vendor'),
          avatar: controller.isClientSelected.value
              ? Icon(Icons.business, color: Colors.black)
              : null,
          checkmarkColor: Colors.white,
          backgroundColor: Colors.white,
          selected: !controller.isClientSelected.value,
          onSelected: (_) => controller.toggleClientVendor(false),
          selectedColor: Colors.teal,
          labelStyle: TextStyle(
            color:
                controller.isClientSelected.value ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
