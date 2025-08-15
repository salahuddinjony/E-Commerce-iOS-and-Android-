import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/owner_appbar/owner_appbar.dart'
    show OwnerAppbar;
import 'package:local/app/view/screens/vendor/home/controller/home_page_controller.dart';
import 'package:local/app/view/screens/vendor/home/widgets/best_selling_products.dart';
import 'package:local/app/view/screens/vendor/home/widgets/stock_alert.dart';
import 'package:local/app/view/screens/vendor/home/widgets/vendor_total_earnings.dart';

import '../../../common_widgets/custom_text/custom_text.dart';
import '../../../common_widgets/owner_nav/owner_nav.dart';
import '../../../common_widgets/status_card/status_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomePageController controller = Get.find<HomePageController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar: const OwnerNav(
        currentIndex: 0,
      ),
      body: Column(
        children: [
          //===============Top Appbar===========
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
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //=================Total Earnings==========
                    VendorTotalEarnings(
                      controller: controller,
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

                    //==========Best Selling Product==============
                    const BestSellingProducts(),
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

                    //===========Stock Alert=============
                    const StockAlert(),
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
