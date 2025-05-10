import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/utils/app_strings/app_strings.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/message_card/message_card.dart';
import 'package:local/app/view/common_widgets/nav_bar/nav_bar.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const CustomNavBar(currentIndex: 2),
      appBar: const CustomAppBar(
        appBarContent: AppStrings.chatList,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'All Message',
              font: CustomFont.inter,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.darkNaturalGray,
            ),
            SizedBox(
              height: 16.h,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return // Reusable message card widget
                      Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: MessageCard(
                          imageUrl: AppConstants.demoImage,
                          senderName: 'Geopart Etdsien',
                          message: 'Your Order Just Arrived!',
                          onTap: () {
                            print('object');
                            context.pushNamed(
                              RoutePath.chatScreen,
                            );
                          },
                        ),
                      );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
