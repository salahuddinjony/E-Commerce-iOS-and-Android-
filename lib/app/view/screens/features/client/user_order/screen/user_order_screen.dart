import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/bottom_navigation_bar/client_nav_bar/nav_bar.dart';
import 'package:local/app/view/screens/features/client/user_order/widgets/tab_bar_view_content.dart';
import '../controller/user_order_controller.dart';

class UserOrderScreen extends StatelessWidget {
  UserOrderScreen({super.key});

  final UserOrderController controller = Get.find<UserOrderController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: const CustomAppBar(
          appBarContent: "Order",
        ),
        bottomNavigationBar: CustomNavBar(currentIndex: 1),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TabBar(
                indicatorColor: AppColors.brightCyan,
                labelColor: AppColors.brightCyan,
                unselectedLabelColor: Colors.grey,
                labelStyle:
                    TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
                tabs: const [
                  Tab(text: 'Orders'),
                  Tab(text: 'Date Extn Req'),
                ],
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: TabBarView(
                  children: [
                    // Orders tab with custom segmented control
                    Column(
                      children: [
                        // ChoiceChips for order types
                        Obx(() => Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical:3),
                              child: Container(
                                margin: EdgeInsets.only(bottom: 8.h),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 8.w,
                                  children: [
                                    // Custom Order ChoiceChip
                                    ChoiceChip(
                                      checkmarkColor: Colors.white,
                                      label: Text(
                                        'Custom Order',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                      selected:
                                          controller.selectedOrderType.value ==
                                              0,
                                      onSelected: (selected) {
                                        if (selected) {
                                          controller.selectedOrderType.value =
                                              0;
                                        }
                                      },
                                      selectedColor: AppColors.brightCyan,
                                      backgroundColor: Colors.grey[100],
                                      labelStyle: TextStyle(
                                        color: controller
                                                    .selectedOrderType.value ==
                                                0
                                            ? Colors.white
                                            : Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11.sp,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        side: BorderSide.none,
                                      ),
                                    ),
                                    // General Order ChoiceChip
                                    ChoiceChip(
                                      checkmarkColor: Colors.white,
                                      label: Text(
                                        'General Order',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                      selected:
                                          controller.selectedOrderType.value ==
                                              1,
                                      onSelected: (selected) {
                                        if (selected) {
                                          controller.selectedOrderType.value =
                                              1;
                                        }
                                      },
                                      selectedColor: AppColors.brightCyan,
                                      backgroundColor: Colors.grey[100],
                                      labelStyle: TextStyle(
                                        color: controller
                                                    .selectedOrderType.value ==
                                                1
                                            ? Colors.white
                                            : Colors.grey[600],
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11.sp,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.r),
                                        side: BorderSide.none,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        // Content based on selected order type
                        Expanded(
                          child:
                              Obx(() => controller.selectedOrderType.value == 0
                                  ? RefreshIndicator(
                                      backgroundColor: Colors.white,
                                      color: AppColors.brightCyan,
                                      onRefresh: controller.fetchCustomOrders,
                                      child: buildCustomOrdersList(
                                          context, controller),
                                    )
                                  : RefreshIndicator(
                                      backgroundColor: Colors.white,
                                      color: AppColors.brightCyan,
                                      onRefresh: controller.fetchGeneralOrders,
                                      child: buildGeneralOrdersList(
                                          context, controller),
                                    )),
                        ),
                      ],
                    ),

                    // Date Extension Requests
                    RefreshIndicator(
                      backgroundColor: Colors.white,
                      color: AppColors.brightCyan,
                      onRefresh: controller.fetchAllOrders,
                      child: buildExtendRequestsList(context, controller),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
