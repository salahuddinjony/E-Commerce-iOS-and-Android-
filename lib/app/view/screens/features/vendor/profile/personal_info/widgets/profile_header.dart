
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../../common_widgets/custom_network_image/custom_network_image.dart';
import '../../../../../../common_widgets/custom_text/custom_text.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key, required this.image, required this.name,
  });

  final String image;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          CustomNetworkImage(
              boxShape: BoxShape.circle,
              imageUrl: image,
              height: 125.h,
              width: 126.w),
          CustomText(
            text: name,
            fontWeight: FontWeight.w800,
            font: CustomFont.poppins,
            fontSize: 24.sp,
            color: AppColors.black,
          ),

        ],
      ),
    );
  }
}
