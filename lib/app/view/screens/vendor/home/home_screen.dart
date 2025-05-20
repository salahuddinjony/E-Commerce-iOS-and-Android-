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
                    const SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StatsCard(
                            title: 'Total Orders',
                            value: '542',
                            tealColor: AppColors.brightCyan,
                            icon: Icons.shopping_cart,
                          ),
                          StatsCard(
                            title: 'Pending Orders',
                            value: '402',
                            tealColor: AppColors.brightCyan,
                            icon: Icons.access_time,
                          ),
                          StatsCard(
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
                     children: List.generate(5, (index){
                       return      Padding(
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
                    SizedBox(height: 32.h,),
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
                        children: List.generate(5, (index){
                          return      Padding(
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

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final Color tealColor;
  final IconData icon;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.tealColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: 100,
      margin: EdgeInsets.only(right: 10.r),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: tealColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.white),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('view order', style: TextStyle(color: Colors.white)),
                Icon(Icons.arrow_forward, color: Colors.white, size: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
