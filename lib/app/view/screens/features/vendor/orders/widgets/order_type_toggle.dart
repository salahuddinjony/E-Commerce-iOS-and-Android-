import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/features/vendor/orders/controller/order_controller.dart';

class OrderTypeToggle extends StatelessWidget {
  final OrdersController controller;
  const OrderTypeToggle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                avatar: controller.isCustomOrder.value
                    ? null
                    : Icon(Icons.design_services, color: Colors.black, size: 18.sp),
                checkmarkColor: Colors.white,
                label: Text('Custom Orders', style: TextStyle(fontSize: 13.sp)),
                selected: controller.isCustomOrder.value,
                onSelected: (val) {
                  controller.isCustomOrder.value = true;
                  controller.refreshOrdersByType(true);
                },
                selectedColor: AppColors.brightCyan,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: controller.isCustomOrder.value
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
              SizedBox(width: 8.w),
              ChoiceChip(
                avatar: controller.isCustomOrder.value
                    ? Icon(Icons.list_alt, color: Colors.black, size: 18.sp)
                    : null,
                checkmarkColor: Colors.white,
                label: Text('General Orders', style: TextStyle(fontSize: 13.sp)),
                selected: !controller.isCustomOrder.value,
                onSelected: (val) {
                  controller.isCustomOrder.value = false;
                  controller.refreshOrdersByType(false);
                },
                selectedColor: AppColors.brightCyan,
                backgroundColor: Colors.white,
                labelStyle: TextStyle(
                  color: !controller.isCustomOrder.value
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
            ],
          )),
    );
  }
}
