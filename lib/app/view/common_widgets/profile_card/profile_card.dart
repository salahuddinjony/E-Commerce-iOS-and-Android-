
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/app_colors/app_colors.dart';
import '../custom_network_image/custom_network_image.dart';
import '../custom_text/custom_text.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  final String location;
  final String imageUrl;
  final VoidCallback onTap;

  const ProfileCard(
      {super.key,
        required this.name,
        required this.location,
        required this.imageUrl, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomNetworkImage(
                imageUrl: imageUrl.replaceFirst(
                          'http://10.10.20.19:5007',
                          'https://gmosley-uteehub-backend.onrender.com',
                ),
                height: 40,
                width: 40,
                boxShape: BoxShape.circle,
              ),
              const SizedBox(height: 5),
              CustomText(
                text: name,
                fontSize: 16.sp,
                font: CustomFont.poppins,
                color: AppColors.darkNaturalGray,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 16),
              CustomText(
                text: "Location: $location",
                fontSize: 14.sp,
                font: CustomFont.poppins,
                color: AppColors.naturalGray,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
