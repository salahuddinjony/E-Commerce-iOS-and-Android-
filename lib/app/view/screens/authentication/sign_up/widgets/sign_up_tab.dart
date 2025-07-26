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
          label: const Text('Client'),
          selected: controller.isClientSelected.value,
          onSelected: (_) => controller.toggleClientVendor(true),
          selectedColor: Colors.teal,
        ),
        SizedBox(width: 16.w),
        ChoiceChip(
          label: const Text('Business Vendor'),
          selected: !controller.isClientSelected.value,
          onSelected: (_) => controller.toggleClientVendor(false),
          selectedColor: Colors.teal,
        ),
      ],
    );
  }
}