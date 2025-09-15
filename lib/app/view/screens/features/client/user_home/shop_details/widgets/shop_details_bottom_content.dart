import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/screens/features/client/chat/inbox_screen/controller/mixin_create_or_retrive_conversation.dart';

class ShopDetailsBottomContent extends StatelessWidget {
  final controller;
  final String role;
  final String name;
  final String imageUrl;
  final String vendorId;
  const ShopDetailsBottomContent(
      {super.key,
      required this.controller,
      required this.vendorId,
      required this.role,
      required this.name,
      required this.imageUrl});

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
        Obx(
          () => CustomText(
            text:
                'Products Available: ${controller.productItems.length.toString().padLeft(2, '0')} ',
            fontWeight: FontWeight.w500,
            font: CustomFont.poppins,
            color: AppColors.naturalGray,
            fontSize: 16.sp,
          ),
        ),
        Obx(
          () => CustomText(
            text:
                'Total Categories:  ${controller.categoriesData.length.toString().padLeft(2, '0')}',
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
          onTap: () async {
            // room creation for chat
            // debugPrint('Vendor ID: $vendorId');
            final conversationId = await controller
                .createOrRetrieveConversation(receiverId: vendorId);

            final String loggedUserId =
                await SharePrefsHelper.getString(AppConstants.userId);
            final String loggedUserRole =
                await SharePrefsHelper.getString(AppConstants.role);

            if (conversationId != null) {
              context.pushNamed(
                RoutePath.chatScreen,
                extra: {
                  'receiverRole': role,
                  'receiverName': name,
                  'receiverImage': imageUrl,
                  'userId': loggedUserId,
                  'conversationId': conversationId,
                  'userRole': loggedUserRole,
                },
              );
            } else {
              toastMessage(message: "Please Click Again!");
            }
          },
          title: "Chat",
          icon: Icons.message,
        ),
      ],
    );
  }
}
