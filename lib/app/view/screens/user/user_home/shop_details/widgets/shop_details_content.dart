import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/controller/shop_details_controller.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/widgets/our_top_t_shirt_designer.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/widgets/vendor_categories.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/widgets/vendor_product_list.dart';

class ShopDetailsContent extends StatelessWidget {
  final ShopDetailsController controller;
  final String vendorId;

  ShopDetailsContent({super.key, required this.controller, required this.vendorId});
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 250,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'TeeVibe Creations',
                fontWeight: FontWeight.w700,
                font: CustomFont.poppins,
                color: AppColors.darkNaturalGray,
                fontSize: 18.sp,
              ),
              CustomText(
                textAlign: TextAlign.start,
                maxLines: 10,
                text:
                    'At TeeVibe Creations, we bring unique and stylish T-shirt designs to life. From trendy graphic tees to fully customizable options, we craft high-quality prints tailored to your style!',
                fontWeight: FontWeight.w400,
                font: CustomFont.poppins,
                color: AppColors.naturalGray,
                fontSize: 14.sp,
              ),

              SizedBox(height: 20.h),

              CustomText(
                text: 'Category',
                fontWeight: FontWeight.w600,
                font: CustomFont.poppins,
                color: AppColors.brightCyan,
                fontSize: 20.sp,
              ),
              SizedBox(height: 12.h),

              // Categories horizontal list
             VendorCategories(controller: controller),
              SizedBox(height: 12.h),

              CustomText(
                text: 'Popular T-Shirt Designs',
                fontWeight: FontWeight.w600,
                font: CustomFont.poppins,
                color: AppColors.brightCyan,
                fontSize: 20.sp,
              ),
              const SizedBox(height: 20),

              // Product list grid
              VendorProductList(controller: controller, vendorId: vendorId),
              
              const SizedBox(height: 20),

             OurTopTShirtDesigner(),
            ],
          ),
        ),
      ),
    );
  }
}
