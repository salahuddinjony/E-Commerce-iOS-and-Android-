import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart' show Assets;
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_log_out_button/custom_log_out_button.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/bottom_navigation_bar/vendor_nav/vendor_nav.dart';
import 'package:local/app/view/screens/features/vendor/profile/personal_info/controller/profile_controller.dart';
import '../../../../../core/route_path.dart';
import '../../../../../data/local/shared_prefs.dart';
import '../../../../../utils/enums/status.dart';
import '../../../../common_widgets/custom_loader/custom_loader.dart';
import '../../../../common_widgets/profile_card_row/profile_card_row.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController profileController = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar:  OwnerNav(currentIndex: 4),
      appBar: const CustomAppBar(appBarContent: AppStrings.profile),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
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
                        GestureDetector(
                          onTap:(){
                            debugPrint(profileController.profileModel.value.profile?.id?.image ?? "");
                          },
                          child: CustomNetworkImage(
                            imageUrl:
                                profileController.profileModel.value.profile?.id!.image?? "",
                            height: 125.h,
                            width: 126.w,
                            boxShape: BoxShape.circle,
                          ),
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
                          text:
                              profileController.profileModel.value.email ?? "",
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

              GestureDetector(
                onTap: () {
                  context.pushNamed(
                    RoutePath.personalInfoScreen,
                  );
                },
                child: Container(
                  width: 135,
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                      color: AppColors.black,
                      borderRadius: BorderRadius.all(Radius.circular(10.r))),
                  child: CustomText(
                    text: AppStrings.profile,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.white,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),

              ProfileCardRow(
                icon: Assets.icons.business.svg(),
                label: 'Business Documents  ',
                onTap: () {
                  context.pushNamed(
                    RoutePath.businessDocumentsScreen,
                  );
                },
              ),

              ProfileCardRow(
                icon: Assets.icons.wallet.svg(),
                label: 'Wallet',
                onTap: () {
                  context.pushNamed(
                    RoutePath.walletScreen,
                  );
                },
              ),

              ProfileCardRow(
                icon: Assets.icons.transection.svg(),
                label: 'Transactions  History ',
                onTap: () {
                  context.pushNamed(
                    RoutePath.transactionScreen,
                  );
                },
              ),
              ProfileCardRow(
                icon: Assets.icons.transection.svg(),
                label: 'About Us',
                onTap: () {
                  context.pushNamed(
                    RoutePath.aboutUsScreen,
                  );
                },
              ),

              ProfileCardRow(
                icon: Assets.icons.transection.svg(),
                label: 'Privacy policy',
                onTap: () {
                  context.pushNamed(
                    RoutePath.privacyPolicyScreen,
                  );
                },
              ),

              ProfileCardRow(
                icon: Assets.icons.help.svg(),
                label: 'Help Center',
                onTap: () {
                  context.pushNamed(
                    RoutePath.helpCenterScreen,
                  );
                },
              ),

              ProfileCardRow(
                icon: Assets.icons.transection.svg(),
                label: ' Terms & Conditions',
                onTap: () {
                  context.pushNamed(
                    RoutePath.termsConditionScreen,
                  );
                },
              ),

              ProfileCardRow(
                icon: Assets.icons.lock.svg(),
                label: 'Change password',
                onTap: () {
                  context.pushNamed(
                    RoutePath.changePasswordScreen,
                  );
                },
              ),

              //===================Log Out ==================
              CustomLogoutButton(
                onTap: () async{
                    // final tokenBefore =await SharePrefsHelper.getString(AppConstants.bearerToken);
                   await SharePrefsHelper.remove();
                  //  final tokenAfter =await SharePrefsHelper.getString(AppConstants.bearerToken);
                  //  print("Before logout-->token:$tokenBefore");
                  //  print("After logout-->token :$tokenAfter");

                   Get.deleteAll(force: true); //its indicates to clear all controllers before navigating
                   context.goNamed(RoutePath.signInScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
