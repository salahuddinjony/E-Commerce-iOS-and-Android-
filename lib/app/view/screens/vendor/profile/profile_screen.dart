import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart' show Assets;
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_log_out_button/custom_log_out_button.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/owner_nav/owner_nav.dart';

import '../../../../core/route_path.dart';
import '../../../common_widgets/profile_card_row/profile_card_row.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const OwnerNav(currentIndex: 4),
      appBar: const CustomAppBar(appBarContent: AppStrings.profile),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomNetworkImage(
                imageUrl: AppConstants.demoImage,
                height: 125,
                width: 126,
                boxShape: BoxShape.circle,
              ),

              CustomText(
                text: "Gwen Stacy",
                font: CustomFont.inter,
                color: AppColors.darkNaturalGray,
                fontWeight: FontWeight.w800,
                fontSize: 24.sp,
              ),

              CustomText(
                text: "masum@gmail.com",
                font: CustomFont.inter,
                color: AppColors.darkNaturalGray,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                bottom: 10,
              ),

              GestureDetector(
                onTap: (){
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
                icon: Assets.icons.mail.svg(),
                label: 'chat',
                onTap: () {
                  context.pushNamed(
                    RoutePath.chatScreen,
                  );
                },
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
                    RoutePath.chatScreen,
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
                onTap: () {
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




