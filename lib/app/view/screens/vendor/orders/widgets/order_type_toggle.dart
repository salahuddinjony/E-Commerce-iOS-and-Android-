import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/vendor/orders/controller/order_controller.dart';

class OrderTypeToggle extends StatelessWidget {
  final OrdersController controller;
  const OrderTypeToggle({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ChoiceChip(
                avatar: controller.isCustomOrder.value
                    ? const Icon(Icons.list_alt, color: Colors.black)
                    : null,
                checkmarkColor: Colors.white,
                label: const Text('General Orders'),
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
                ),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                avatar: controller.isCustomOrder.value
                    ? null
                    : const Icon(Icons.design_services, color: Colors.black),
                checkmarkColor: Colors.white,
                label: const Text('Custom Orders'),
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
                ),
              ),
            ],
          )),
    );
  }
}
