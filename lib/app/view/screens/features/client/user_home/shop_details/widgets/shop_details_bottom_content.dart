import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';

class ShopDetailsBottomContent extends StatelessWidget {
  final controller;
  const ShopDetailsBottomContent({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // CustomText(
        //   text: 'Our Top Tee-Shirt Designer',
        //   fontWeight: FontWeight.w600,
        //   font: CustomFont.poppins,
        //   color: AppColors.brightCyan,
        //   fontSize: 20.sp,
        // ),
        // const SizedBox(height: 40),


        // DesignerCard(
        //   imageUrl: 'https://i.pravatar.cc/150?img=2',
        //   name: 'UrbanTee Lab',
        //   subtitle: 'T-Shirt Designs',
        //   rating: 4.4,
        //   reviews: '1.5K+ reviews',
        //   onTap: () {
        //     context.pushNamed(RoutePath.productDetailsScreen);
        //   },
        // ),
        // const SizedBox(height: 12),
        // DesignerCard(
        //   imageUrl: 'https://i.pravatar.cc/150?img=2',
        //   name: 'UrbanTee Lab',
        //   subtitle: 'T-Shirt Designs',
        //   rating: 4.4,
        //   reviews: '1.5K+ reviews',
        //   onTap: () {
        //     context.pushNamed(RoutePath.productDetailsScreen);
        //   },
        // ),


        const SizedBox(height: 12),
        CustomText(
          text: 'Shop Details',
          fontWeight: FontWeight.w600,
          font: CustomFont.poppins,
          color: AppColors.darkNaturalGray,
          fontSize: 18.sp,
        ),
        SizedBox(height: 12.h),
       Obx(()=>
        CustomText(
          text: 'Products Available: ${controller.productItems.length.toString().padLeft(2, '0')} ',
          fontWeight: FontWeight.w500,
          font: CustomFont.poppins,
          color: AppColors.naturalGray,
          fontSize: 16.sp,
        ),
       
       ),
       Obx(()=>
         CustomText(
          text: 'Total Categories:  ${controller.categoriesData.length.toString().padLeft(2, '0')}',
          fontWeight: FontWeight.w500,
          font: CustomFont.poppins,
          color: AppColors.naturalGray,
          fontSize: 16.sp,
        ),
       ),
       
  
        // CustomText(
        //   text: 'Average Rating: ⭐4.8',
        //   fontWeight: FontWeight.w500,
        //   font: CustomFont.poppins,
        //   color: AppColors.naturalGray,
        //   fontSize: 16.sp,
        // ),
        // CustomText(
        //   text: '2.5K+ reviews',
        //   fontWeight: FontWeight.w500,
        //   font: CustomFont.poppins,
        //   color: AppColors.brightCyan,
        //   fontSize: 16.sp,
        // ),
        const SizedBox(height: 20),
        CustomText(
          text: 'Shipping Time',
          fontWeight: FontWeight.w600,
          font: CustomFont.poppins,
          color: AppColors.darkNaturalGray,
          fontSize: 18.sp,
        ),
        CustomText(
          text: '(3-5 business days)',
          fontWeight: FontWeight.w500,
          font: CustomFont.poppins,
          color: AppColors.naturalGray,
          fontSize: 16.sp,
        ),
        CustomText(
          text: ' 100% Cotton & Eco-Friendly Printing',
          fontWeight: FontWeight.w500,
          font: CustomFont.poppins,
          color: AppColors.naturalGray,
          fontSize: 16.sp,
        ),
        CustomText(
          text: 'Custom Orders Available',
          fontWeight: FontWeight.w500,
          font: CustomFont.poppins,
          color: AppColors.naturalGray,
          fontSize: 16.sp,
        ),
        CustomText(
          text: ' Best Seller on UTEE HUB',
          fontWeight: FontWeight.w500,
          font: CustomFont.poppins,
          color: AppColors.naturalGray,
          fontSize: 16.sp,
        ),
        const SizedBox(height: 40),
        CustomButton(
          onTap: () {
            context.pushNamed(RoutePath.customDesignScreen);
          },
          title: "Make A Custom",
        ),
        const SizedBox(height: 12),
        CustomButton(
          onTap: () {
            context.pushNamed(RoutePath.chatScreen);
          },
          title: "Chat",
        ),
      ],
    );
  }
}
