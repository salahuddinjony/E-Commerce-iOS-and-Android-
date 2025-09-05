import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShippingOption extends StatelessWidget {
  final controller;
  const ShippingOption({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => CheckboxListTile(
              title: const Text('Standard Shipping (5-7 days)'),
              value: controller.standardShipping.value,
              onChanged: (val) => controller.toggleStandard(val ?? false),
              secondary: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(8)),
                child: const Text('\$10', style: TextStyle(color: Colors.teal)),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            )),
        Obx(() => CheckboxListTile(
              title: const Text('Express Shipping (2-3 days)'),
              value: controller.expressShipping.value,
              onChanged: (val) => controller.toggleExpress(val ?? false),
              secondary: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(8)),
                child: const Text('\$10', style: TextStyle(color: Colors.teal)),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            )),
        const SizedBox(height: 8),
        // Delivery option
        const Text('Delivery Option:',
            style: TextStyle(fontWeight: FontWeight.bold)),
        Obx(() => CheckboxListTile(
              title: const Text('Home Delivery'),
              value: controller.homeDelivery.value,
              onChanged: (val) => controller.toggleHomeDelivery(val ?? false),
              secondary: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(8)),
                child: const Text('\$8', style: TextStyle(color: Colors.teal)),
              ),
              controlAffinity: ListTileControlAffinity.leading,
            )),
        const SizedBox(height: 8),
        const Text('Hub Fee 20%',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Obx(() => Text(
            'Total Cost: \$${controller.totalCost.toStringAsFixed(2)}',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.teal))),
      ],
    );
  }
}
