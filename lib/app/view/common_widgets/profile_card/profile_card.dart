import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/controller/shop_details_controller.dart';
import 'package:local/app/view/screens/user/user_home/vendor_list/model/nearest_vendor_response.dart';

import '../../../utils/app_colors/app_colors.dart';
import '../custom_network_image/custom_network_image.dart';
import '../custom_text/custom_text.dart';

class ProfileCard extends StatelessWidget {
  final String imageUrl;
  final UserItem vendorItems;

  ProfileCard({super.key, required this.imageUrl, required this.vendorItems});

  final ShopDetailsController shopDetailsController = Get.find<ShopDetailsController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RoutePath.shopDetailsScreen,
          extra: {
            'image': vendorItems.profile?.id?.image ?? '',
            'location': vendorItems.profile?.id?.address ?? '',
            'name': vendorItems.profile?.id?.name ?? '',
            'vendorId': vendorItems.id,
          },
        );
        shopDetailsController.fetchCategories(vendorId: vendorItems.id);
        shopDetailsController.fetchProducts(vendorId: vendorItems.id);
      },
      child: Card(
        color: AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  CustomNetworkImage(
                    imageUrl: imageUrl.replaceFirst(
                      'http://10.10.20.19:5007',
                      'https://gmosley-uteehub-backend.onrender.com',
                    ),
                    height: 40,
                    width: 40,
                    boxShape: BoxShape.circle,
                  ),
                  if (vendorItems.isOnline == false)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Icon(
                          Icons.circle,
                          color: Colors.green,
                          size: 10,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 5),
              CustomText(
                text: vendorItems.profile?.id?.name?.toString() ?? '',
                fontSize: 16.sp,
                font: CustomFont.poppins,
                color: AppColors.darkNaturalGray,
                fontWeight: FontWeight.w500,
              ),
              const SizedBox(height: 16),
              CustomText(
                text:
                    vendorItems.profile?.id?.address?.split(',').last.trim() ??
                        '',
                fontSize: 14.sp,
                font: CustomFont.poppins,
                color: AppColors.naturalGray,
                fontWeight: FontWeight.w400,
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}
