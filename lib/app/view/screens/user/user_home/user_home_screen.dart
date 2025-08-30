import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/common_home_app_bar/common_home_app_bar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/common_widgets/client_nav_bar/nav_bar.dart';

import '../../../common_widgets/profile_card/profile_card.dart';

class UserHomeScreen extends StatelessWidget {
  const UserHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar:  CustomNavBar(currentIndex: 0),
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
                              height: 80,
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
                              // Your Location field
                              TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hintText: 'Your Location',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                ),
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 12),
                              // Delivery Location field with pink background
                              TextField(
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: const Color(0xFFF4C6C6),
                                  // light pink
                                  hintText: 'Delivery Location',
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 16),
                                ),
                                style: const TextStyle(color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.h,
                    ),
                    CustomText(
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      text: "Custom Hub – Design Your Own Tee",
                      fontWeight: FontWeight.w600,
                      font: CustomFont.poppins,
                      fontSize: 20.sp,
                      color: AppColors.brightCyan,
                    ),
                    CustomText(
                      textAlign: TextAlign.start,
                      maxLines: 10,
                      text:
                          "Welcome to the Custom Hub! Upload your design, choose colors, and personalize your T-shirt exactly how you want.",
                      fontWeight: FontWeight.w400,
                      font: CustomFont.poppins,
                      fontSize: 14.sp,
                      color: AppColors.naturalGray,
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    CustomButton(
                      onTap: () {},
                      title: "Custom Hub",
                    ),
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
                    GestureDetector(
                      onTap: (){
                        context.pushNamed(
                          RoutePath.viewMapScreen,
                        );
                      },
                      child: CustomText(
                        top: 24.h,
                        decoration: TextDecoration.underline,
                        textAlign: TextAlign.start,
                        text: "View Map",
                        fontWeight: FontWeight.w400,
                        font: CustomFont.poppins,
                        fontSize: 16.sp,
                        color: AppColors.darkNaturalGray,
                      ),
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 8,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        return  ProfileCard(
                          onTap: (){
                            context.pushNamed(
                              RoutePath.shopDetailsScreen,
                            );
                          },
                          name: 'Alex Carter',
                          location: 'USA',
                          imageUrl:AppConstants.demoImage ,
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
