import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/features/vendor/orders/controller/order_controller.dart';

class OrdersAppBar extends StatelessWidget {
  final OrdersController controller;
  const OrdersAppBar({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Orders',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              letterSpacing: .5,
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.brightCyan.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.brightCyan, width: 1),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) =>
                    ScaleTransition(scale: animation, child: child),
                child: Text(
                  controller.isCustomOrder.value
                      ? '${controller.totalCustomOrder}'
                      : '${controller.totalGeneralOrder}',
                  key: ValueKey(
                    controller.isCustomOrder.value
                        ? controller.totalCustomOrder
                        : controller.totalGeneralOrder,
                  ),
                  style: TextStyle(
                    color: AppColors.brightCyan,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
