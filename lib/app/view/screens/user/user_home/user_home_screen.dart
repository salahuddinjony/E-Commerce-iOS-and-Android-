import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/common_home_app_bar/common_home_app_bar.dart';
import 'package:local/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/client_nav_bar/nav_bar.dart';
import 'package:local/app/view/common_widgets/map/widgets/location_field.dart';
import 'package:local/app/view/screens/user/user_home/controller/delivery_locations_controller.dart';
import 'package:local/app/view/screens/user/user_home/controller/user_home_controller.dart';
import 'package:local/app/view/screens/user/user_home/custom_hub/screen/custom_hub_screen.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/widgets/not_found.dart';
import 'package:local/app/view/screens/user/user_home/vendor_list/screen/nearest_vendor_list.dart';
import 'package:local/app/view/screens/user/user_home/widgets/view_map_button.dart';

class UserHomeScreen extends StatelessWidget {
  final UserHomeController controller = Get.find<UserHomeController>();
  final MixInDeliveryLocation mixInDelivery = Get.find<MixInDeliveryLocation>();

  UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: CustomNavBar(currentIndex: 0),
      body: Column(
        children: [
          CommonHomeAppBar(
            onTap: () {},
            scaffoldKey: GlobalKey<ScaffoldState>(),
            aboutUsOnTap: () {
              context.pushNamed(
                RoutePath.aboutUsScreen,
              );
            },
            privacyTap: () {
              context.pushNamed(
                RoutePath.privacyPolicyScreen,
              );
            },
            termsTap: () {
              context.pushNamed(
                RoutePath.termsConditionScreen,
              );
            },
            profileTap: () {
              context.pushNamed(
                RoutePath.userProfileScreen,
              );
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 30),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.teal[400],
                                shape: BoxShape.circle,
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 100,
                              color: Colors.teal[400],
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: Colors.teal[400],
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            children: [
                              // User Location field with cyan background
                              LocationField<UserHomeController>(
                                isUser: true,
                                controller: controller,
                              ),

                              const SizedBox(height: 12),

                              LocationField<MixInDeliveryLocation>(
                                isUser: false,
                                isDeliveryLocation: true,
                                controller: mixInDelivery,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.h,
                    ),

                    //-------------Custom Hub------------
                    CustomHubScreen(),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomText(
                      textAlign: TextAlign.start,
                      text: "Browse Stores",
                      fontWeight: FontWeight.w600,
                      font: CustomFont.poppins,
                      fontSize: 20.sp,
                      color: AppColors.brightCyan,
                    ),
                    CustomText(
                      textAlign: TextAlign.start,
                      text: "Discover Unique T-Shirt Stores on U TEE HUB!",
                      fontWeight: FontWeight.w400,
                      font: CustomFont.poppins,
                      fontSize: 14.sp,
                      color: AppColors.naturalGray,
                    ),

                    //-------------Mapwise show the nearest vendors------------
                    ViewMapButton(),
                    Obx(
                      () {
                        if (controller.nearestVendors.isEmpty &&
                            !controller.isLoadingVendorList.value) {
                          return NotFound(
                              message: 'No vendors found near you',
                              icon: Icons.storefront_outlined);
                        }
                        return controller.isLoadingVendorList.value
                            ? Center(
                                child: CustomLoader(),
                              )
                            : NearestVendorList(
                                vendorList: controller.nearestVendors,
                              );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
