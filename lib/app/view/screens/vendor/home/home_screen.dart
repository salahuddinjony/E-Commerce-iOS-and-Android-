import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/common_widgets/owner_appbar/owner_appbar.dart'
    show OwnerAppbar;

import '../../../common_widgets/custom_text/custom_text.dart';
import '../../../common_widgets/owner_nav/owner_nav.dart';
import '../../../common_widgets/status_card/status_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const OwnerNav(
        currentIndex: 0,
      ),
      body: Column(
        children: [
          OwnerAppbar(
            scaffoldKey: GlobalKey<ScaffoldState>(),
            notificationOnTap: () {
              context.pushNamed(
                RoutePath.notificationScreen,
              );
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 87.w, vertical: 30.h),
                      decoration: BoxDecoration(
                          color: AppColors.brightCyan,
                          borderRadius:
                              BorderRadius.all(Radius.circular(21.r))),
                      child: Column(
                        children: [
                          CustomText(
                            font: CustomFont.poppins,
                            color: AppColors.white,
                            text: 'Total Earnings',
                            fontWeight: FontWeight.w600,
                            fontSize: 24.sp,
                          ),
                          CustomText(
                            font: CustomFont.poppins,
                            color: AppColors.white,
                            text: '\$5,484.25',
                            fontWeight: FontWeight.w600,
                            fontSize: 30.sp,
                            bottom: 10.h,
                          ),
                          CustomButton(
                            borderColor: AppColors.white,
                            onTap: () {},
                            title: "Withdraw",
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 32.h,
                    ),
                    CustomText(
                      font: CustomFont.poppins,
                      color: AppColors.darkNaturalGray,
                      text: ' Business Performance Overview',
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                      bottom: 10.h,
                    ),
                    // Cards Row
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatsCard(
                            onTap: () {
                              context.pushNamed(
                                RoutePath.viewOrderScreen,
                              );
                            },
                            title: 'Total Orders',
                            value: '542',
                            tealColor: AppColors.brightCyan,
                            icon: Icons.shopping_cart,
                          ),
                          StatsCard(
                            onTap: () {
                              context.pushNamed(
                                RoutePath.viewOrderScreen,
                              );
                            },
                            title: 'Pending Orders',
                            value: '402',
                            tealColor: AppColors.brightCyan,
                            icon: Icons.access_time,
                          ),
                          StatsCard(
                            onTap: () {
                              context.pushNamed(
                                RoutePath.viewOrderScreen,
                              );
                            },
                            title: 'Completed Orders',
                            value: '625',
                            tealColor: AppColors.brightCyan,
                            icon: Icons.check_circle,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    CustomText(
                      font: CustomFont.poppins,
                      color: AppColors.darkNaturalGray,
                      text: 'Best-Selling T-Shirts',
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                      bottom: 10.h,
                    ),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(5, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomNetworkImage(
                                    imageUrl: AppConstants.teeShirt,
                                    height: 119,
                                    width: 119),
                                CustomText(
                                  font: CustomFont.poppins,
                                  color: AppColors.darkNaturalGray,
                                  text: 'Guitar Soul Tee',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                                CustomText(
                                  font: CustomFont.poppins,
                                  color: AppColors.darkNaturalGray,
                                  text: 'Price: \$22.20 ',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  bottom: 10.h,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(
                      height: 32.h,
                    ),
                    CustomText(
                      font: CustomFont.poppins,
                      color: AppColors.darkNaturalGray,
                      text: 'Stock Alert Badge (Low Stock 🔴)',
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                      bottom: 10.h,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(5, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomNetworkImage(
                                    imageUrl: AppConstants.teeShirt,
                                    height: 119,
                                    width: 119),
                                CustomText(
                                  font: CustomFont.poppins,
                                  color: AppColors.darkNaturalGray,
                                  text: 'Guitar Soul Tee',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.sp,
                                ),
                                CustomText(
                                  font: CustomFont.poppins,
                                  color: AppColors.darkNaturalGray,
                                  text: 'Price: \$22.20 ',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.sp,
                                  bottom: 10.h,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
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
