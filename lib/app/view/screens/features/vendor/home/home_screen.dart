import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/owner_appbar/owner_appbar.dart'
    show OwnerAppbar;
import 'package:local/app/view/screens/features/vendor/home/controller/home_page_controller.dart';
import 'package:local/app/view/screens/features/vendor/home/widgets/best_selling_products.dart';
import 'package:local/app/view/screens/features/vendor/home/widgets/stock_alert.dart';
import 'package:local/app/view/screens/features/vendor/home/widgets/vendor_total_earnings.dart';
import 'package:local/app/view/screens/common_screen/notification/controller/notification_controller.dart';
import 'package:local/app/view/screens/features/vendor/orders/controller/order_controller.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/product/controller/vendor_product_controller.dart';

import '../../../../common_widgets/custom_text/custom_text.dart';
import '../../../../common_widgets/bottom_navigation_bar/vendor_nav/vendor_nav.dart';
import '../../../../common_widgets/status_card/status_card.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomePageController controller = Get.find<HomePageController>();
  final NotificationController notificationController = Get.find<NotificationController>(); //notification controller
  final OrdersController orderController = Get.find<OrdersController>(); // order controller
  final VendorProductController productsController = Get.find<VendorProductController>();

  @override
  Widget build(BuildContext context) {
 
    
    return Scaffold(
      backgroundColor: AppColors.white,
      bottomNavigationBar:  OwnerNav(
        currentIndex: 0,
      ),
      body: Column(
        children: [
          //===============Top Appbar===========
         OwnerAppbar(
          scaffoldKey: GlobalKey<ScaffoldState>(),
          notificationOnTap: () {
            context.pushNamed(RoutePath.notificationScreen);
          },
          controller: notificationController,
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
                      notificationController: notificationController,
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
                      child: Obx(() {
                        final loading = orderController.isLoading.value;
                        return Row(
                          children: [
                            StatussCard(
                              onTap: () => context.pushNamed(
                                RoutePath.viewOrderScreen,
                                extra: {
                                  'status': 'allOrder',
                                  'orderData': orderController.customOrders.toList(),
                                },
                              ),
                              title: 'Total Customs\nOrders',
                              value: orderController.totalCustomOrder.value.toString(),
                              tealColor: AppColors.brightCyan,
                              icon: Icons.shopping_cart,
                              loading: loading,
                              status: 'allOrder',
                            ),
                            StatussCard(
                              onTap: () => context.pushNamed(
                                RoutePath.viewOrderScreen,
                                extra: {
                                  'status': 'pendingOrder',
                                  'orderData': orderController.customOrders.toList(),
                                },
                              ),
                              title: 'Customs Pending\nOrders',
                              value: orderController.totalPendingOrder.value.toString(),
                              tealColor: AppColors.brightCyan,
                              icon: Icons.access_time,
                              loading: loading,
                              status: 'pendingOrder',
                            ),
                            StatussCard(
                              onTap: () => context.pushNamed(
                                RoutePath.viewOrderScreen,
                                extra: {
                                  'status': 'inProgressOrder',
                                  'orderData': orderController.customOrders.toList(),
                                },
                              ),
                              title: 'Customs in-Progress\nOrders',
                              value: orderController.totalInProgressOrder.value.toString(),
                              tealColor: AppColors.brightCyan,
                              icon: Icons.autorenew,
                              loading: loading,
                              status: 'inProgressOrder',
                            ),
                          ],
                        );
                      }),
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
                    Obx(() => BestSellingProducts(controller: productsController, productsList: productsController.productItems.toList()),),
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
                    Obx(() => StockAlert(controller: productsController, productsList: productsController.productItems.toList()),),
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
