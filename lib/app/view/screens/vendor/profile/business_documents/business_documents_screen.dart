import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class BusinessDocumentsScreen extends StatelessWidget {
  const BusinessDocumentsScreen({super.key});

  List<Map<String, String>> get _items => [
        {
          'title': 'Upload Business License & Tax Info',
          'route': '/businessLicense',
        },
        {
          'title': 'Bank Account Details for Payouts',
          'route': '/bankAccountDetails',
        },
        {
          'title': 'Withdrawal History & Earnings Report',
          'route': '/withdrawalHistory',
        },
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "Business Documents",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: ListView.separated(
          itemCount: _items.length,
          separatorBuilder: (_, __) => SizedBox(height: 14.h),
          itemBuilder: (context, index) {
            final item = _items[index];
            return InkWell(
              borderRadius: BorderRadius.circular(12.r),
              onTap: () {
                if (item['route'] != null) {
                  Get.toNamed(item['route']!);
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.04),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 34.r,
                      height: 34.r,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(.12),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      
                      child: CustomText(
                        text: "${index + 1}",
                        font: CustomFont.poppins,
                        fontWeight: FontWeight.w600,
                        fontSize: 16.sp,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: CustomText(
                        text: item['title'] ?? '',
                        font: CustomFont.poppins,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        color: AppColors.darkNaturalGray,
                        maxLines: 2,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16.sp,
                      color: AppColors.darkNaturalGray.withOpacity(.6),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
