import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_constants/app_constants.dart';
import '../../../../common_widgets/custom_network_image/custom_network_image.dart';
import '../../../../common_widgets/custom_text/custom_text.dart';

class BestSellingProducts extends StatelessWidget {
  const BestSellingProducts({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(5, (index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNetworkImage(
                    imageUrl: AppConstants.teeShirt,
                    height: 119,
                    width: 119),
                CustomText(
                  font: CustomFont.poppins,
                  color: AppColors.darkNaturalGray,
                  text: 'Guitar Soul Tee',
                  fontWeight: FontWeight.w500,
                  fontSize: 14.sp,
                ),
                CustomText(
                  font: CustomFont.poppins,
                  color: AppColors.darkNaturalGray,
                  text: 'Price: \$22.20 ',
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                  bottom: 10.h,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}