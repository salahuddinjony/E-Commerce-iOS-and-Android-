import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import '../../controller/profile_controller.dart';

class ContactAddressSection extends StatelessWidget {
  final ProfileController controller;
  final dynamic id;
  const ContactAddressSection({
    super.key,
    required this.controller,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomFromCard(
          hinText: id?.name ?? "",
          title: AppStrings.fullName,
          controller: controller.fullNameController,
          validator: (v) => null,
        ),
        SizedBox(height: 12.h),
        CustomFromCard(
          hinText: 'Write your phone number here',
            title: AppStrings.phone,
          controller: controller.phoneController,
          validator: (v) => null,
        ),
        SizedBox(height: 12.h),
        CustomFromCard(
          hinText: 'Write your address here',
          title: 'Address',
          controller: TextEditingController(text: id?.address ?? ''),
          validator: (v) => null,
        ),
        SizedBox(height: 12.h),
        CustomFromCard(
          hinText: 'Write your description here',
          title: 'Description',
          controller: TextEditingController(text: id?.description ?? ''),
          validator: (v) => null,
          maxLine: 3,
        ),
      ],
    );
  }
}