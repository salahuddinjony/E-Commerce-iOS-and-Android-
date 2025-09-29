import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class DeliveryDropdown extends StatelessWidget {
  final dynamic controller;
  const DeliveryDropdown({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Delivery',
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          color: AppColors.darkNaturalGray,
          bottom: 8.h,
        ),
        DropdownButtonFormField<String>(
          dropdownColor: Colors.white,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            filled: true,
            fillColor: Colors.white,
          ),
            // ignore: deprecated_member_use
            value: controller.selectedDelivery.value.isEmpty
              ? null
              : controller.selectedDelivery.value,
          items: const [
            DropdownMenuItem(value: 'pickup', child: Text('pickup')),
            DropdownMenuItem(value: 'courier', child: Text('courier')),
            DropdownMenuItem(
              value: 'pickupAndCourier',
              child: Text('Pickup & Courier'),
            ),
          ],
          hint: const Text('Select'),
          onChanged: (val) {
            if (val != null) controller.selectedDelivery.value = val;
          },
        ),
      ],
    );
  }
}