import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';

Widget showOrdersDataLoader(dynamic controller) {
  return Obx(() {
    print('LOADER DEBUG - isPaginating: ${controller.isPaginating.value}, hasMoreData: ${controller.hasMoreData.value}, customOrders: ${controller.customOrders.length}');
    
    if (controller.isPaginating.value) {
      print('SHOWING PAGINATION LOADER');
      // Show animated loading indicator when loading more data
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.brightCyan.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.brightCyan),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Loading more orders...'.tr,
                style: TextStyle(
                  color: Colors.grey[600], 
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 60,
                height: 2,
                decoration: BoxDecoration(
                  color: AppColors.brightCyan.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      );
    } else if (!controller.hasMoreData.value && 
               controller.customOrders.isNotEmpty) {
      print('SHOWING NO MORE DATA MESSAGE');
      // Show "no more data" message when all data is loaded
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 1, 
                    width: 40, 
                    color: Colors.grey[300],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'No more orders'.tr,
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    height: 1, 
                    width: 40, 
                    color: Colors.grey[300],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Icon(
                Icons.check_circle_outline,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      );
    }
    print('LOADER: Showing nothing (neither paginating nor end state)');
    return const SizedBox.shrink();
  });
}