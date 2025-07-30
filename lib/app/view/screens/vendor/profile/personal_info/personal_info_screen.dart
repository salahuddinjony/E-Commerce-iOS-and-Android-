import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/view/screens/vendor/profile/personal_info/widgets/profile_header.dart';

import '../../../../../core/route_path.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_strings/app_strings.dart';
import '../../../../../utils/enums/status.dart';
import '../../../../common_widgets/custom_appbar/custom_appbar.dart';
import '../../../../common_widgets/custom_from_card/custom_from_card.dart';
import '../../../../common_widgets/custom_loader/custom_loader.dart';
import '../../../../common_widgets/genarel_screen/genarel_screen.dart';
import '../../../../common_widgets/no_internet/no_internet.dart';
import 'controller/profile_controller.dart';

class PersonalInfoScreen extends StatelessWidget {
   PersonalInfoScreen({super.key});

  final ProfileController controller = Get.find<ProfileController>();

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
      body: Obx(() {
        switch (controller.rxRequestStatus.value) {
          case Status.loading:
            return const CustomLoader();
          case Status.internetError:
            return NoInternetScreen(
              onTap: () {
                controller.getUserId();
              },
            );
          case Status.error:
            return GeneralErrorScreen(
              onTap: () {
                controller.getUserId();
              },
            );
          case Status.completed:
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  ProfileHeader(
                    image: "${ApiUrl.networkUrl}${controller.profileModel.value.profile?.id?.image??""}",
                    name: controller.profileModel.value.profile?.id?.name??""
                        ""
                  ),
                  SizedBox(height: 20.h),
                  CustomFromCard(
                    isRead: true,
                    hinText: controller.profileModel.value.profile?.id?.name??"",
                    title: AppStrings.fullName,
                    controller: TextEditingController(),
                    validator: (v) => null,
                  ),
                  CustomFromCard(
                    isRead: true,
                    hinText: controller.profileModel.value.phone??"",
                    title: AppStrings.phone,
                    controller: TextEditingController(),
                    validator: (v) => null,
                  ),
                  CustomFromCard(
                    isRead: true,
                    hinText: controller.profileModel.value.email??"",
                    title: AppStrings.email,
                    controller: TextEditingController(),
                    validator: (v) => null,
                  ),
                ],
              ),
            );
        }
      }),
    );
  }
}
