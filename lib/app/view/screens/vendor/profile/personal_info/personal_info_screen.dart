import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

import '../../../../../core/route_path.dart';

class PersonalInfoScreen extends StatelessWidget {
  const PersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        isIcon: true,
        onTap: () {
          context.pushNamed(
            RoutePath.editProfileScreen,
          );
        },
        appBarContent: AppStrings.profile,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            Center(
              child: Column(
                children: [
                  CustomNetworkImage(
                      boxShape: BoxShape.circle,
                      imageUrl: AppConstants.demoImage,
                      height: 125,
                      width: 126),
                  CustomText(
                    text: 'Gwen Stacy',
                    fontWeight: FontWeight.w800,
                    font: CustomFont.poppins,
                    fontSize: 24.sp,
                    color: AppColors.black,
                  ),
                  CustomText(
                    text: '@GwenStacy31',
                    fontWeight: FontWeight.w400,
                    font: CustomFont.poppins,
                    fontSize: 16.sp,
                    color: AppColors.black,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            CustomFromCard(
                 isRead: true,
              hinText: "Albert Stevano Bajefski",
                title: AppStrings.fullName,
                controller: TextEditingController(),
                validator: (v) {}),

            CustomFromCard(
                 isRead: true,
              hinText: "Male",
                title: AppStrings.gender,
                controller: TextEditingController(),
                validator: (v) {}),

            CustomFromCard(
                 isRead: true,
              hinText: "+01722983926",
                title: AppStrings.phone,
                controller: TextEditingController(),
                validator: (v) {}),

            CustomFromCard(
                 isRead: true,
              hinText: "masu@gmail.com",
                title: AppStrings.email,
                controller: TextEditingController(),
                validator: (v) {}),
          ],
        ),
      ),
    );
  }
}
