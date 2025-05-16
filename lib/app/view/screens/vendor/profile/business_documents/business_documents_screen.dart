import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';

class BusinessDocumentsScreen extends StatelessWidget {
  const BusinessDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        appBarContent: "Business Documents ",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.h,vertical: 10.w),
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
