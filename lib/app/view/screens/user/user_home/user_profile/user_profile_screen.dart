import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';

import '../../../../../core/route_path.dart';
import '../../../../../data/local/shared_prefs.dart';
import '../../../../../services/app_url.dart';
import '../../../../../utils/app_colors/app_colors.dart';
import '../../../../../utils/app_constants/app_constants.dart';
import '../../../../../utils/enums/status.dart';
import '../../../../common_widgets/custom_loader/custom_loader.dart';
import '../../../../common_widgets/custom_log_out_button/custom_log_out_button.dart';
import '../../../../common_widgets/custom_network_image/custom_network_image.dart';
import '../../../../common_widgets/custom_text/custom_text.dart';
import '../../../../common_widgets/genarel_screen/genarel_screen.dart';
import '../../../../common_widgets/no_internet/no_internet.dart';
import '../../../vendor/profile/personal_info/controller/profile_controller.dart';

class UserProfileScreen extends StatelessWidget {
  UserProfileScreen({super.key});

  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        appBarContent: AppStrings.profile,
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
        child: Column(
          children: [
            Obx(() {
              switch (profileController.rxRequestStatus.value) {
                case Status.loading:
                  return const CustomLoader();
                case Status.internetError:
                  return GestureDetector(
                    onTap: () {
                      profileController.getUserId();
                    },
                    child: CustomText(
                      text: 'No Internet',
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: AppColors.black,
                    ),
                  );
                case Status.error:
                  return GestureDetector(
                    onTap: () {
                      profileController.getUserId();
                    },
                    child: CustomText(
                      text: 'Error',
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: AppColors.black,
                    ),
                  );
                case Status.completed:
                  return Column(
                    children: [
                      CustomNetworkImage(
                        imageUrl:
                            profileController.profileModel.value.profile?.id?.image ?? "",
                        height: 125.h,
                        width: 126.w,
                        boxShape: BoxShape.circle,
                      ),
                      CustomText(
                        text: profileController
                                .profileModel.value.profile?.id?.name ??
                            "",
                        font: CustomFont.inter,
                        color: AppColors.darkNaturalGray,
                        fontWeight: FontWeight.w800,
                        fontSize: 24.sp,
                      ),
                      CustomText(
                        text: profileController.profileModel.value.email ?? "",
                        font: CustomFont.inter,
                        color: AppColors.darkNaturalGray,
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        bottom: 10,
                      ),
                    ],
                  );
              }
            }),
            SizedBox(height: 25.h),
            Expanded(
              child: ListView(
                children: [
                  _buildListItem(
                    icon: Icons.person,
                    label: "Personal Information",
                    onTap: () {
                      context.pushNamed(RoutePath.personalInfoScreen);
                    },
                  ),
                  _buildListItem(
                    icon: Icons.payment,
                    label: "Payment Methods",
                    onTap: () {
                      context.pushNamed(RoutePath.paymentMethodsScreen);
                    },
                  ),
                  _buildListItem(
                    icon: Icons.history,
                    label: "Order History",
                    onTap: () {
                      context.pushNamed(RoutePath.orderHistoryScreen);
                    },
                  ),
                  _buildListItem(
                    icon: Icons.support_agent,
                    label: "Support",
                    onTap: () {
                      context.pushNamed(RoutePath.helpCenterScreen);
                    },
                  ),
                  _buildListItem(
                    icon: Icons.help_outline,
                    label: "FAQ",
                    onTap: () {
                      context.pushNamed(RoutePath.faqScreen);
                    },
                  ),
                  _buildListItem(
                    icon: Icons.lock_outline,
                    label: "Change password",
                    onTap: () {
                      context.pushNamed(RoutePath.changePasswordScreen);
                    },
                  ),
                ],
              ),
            ),
            CustomLogoutButton(
              onTap: () async {
                await SharePrefsHelper.remove(AppConstants.id);
                Get.delete<ProfileController>();

                context.goNamed(RoutePath.signInScreen);
              },
            ),
            // Logout button
            SizedBox(
              height: 20.h,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 28),
      title: Text(
        label,
        style: const TextStyle(fontSize: 18),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 0),
    );
  }
}
