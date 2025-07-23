import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart'
    show AppConstants;
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/message_card/message_card.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "Notification",
        iconData: Icons.arrow_back,
      ),
      body: ListView.builder(
          itemCount: 4,
          itemBuilder: (context, index) {
            return // Reusable message card widget
                Padding(
              padding: EdgeInsets.only(top: 10.h),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,),
                child: MessageCard(
                  imageUrl: AppConstants.demoImage,
                  senderName: 'Geopart Etdsien',
                  message: 'Your Order Just Arrived!',
                  onTap: () {},
                ),
              ),
            );
          }),
    );
  }
}
