import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/product_details/widgets/counter_button_andThumbnail.dart';



class ItemsCount extends StatelessWidget {
  final controller;
  final product;
  const ItemsCount({super.key, required this.controller, required this.product});

  @override
  Widget build(BuildContext context) {
    return  Row(
              children: [
                counterButton(
                    label: '-',
                    onPressed: controller.decrement,
                    tag: product.id,
                    quantity: product.quantity),
                SizedBox(
                  width: 50,
                  child: TextField(
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                    controller: controller.itemsTextController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) {
                      if (controller.itemsTextController.text.trim().isEmpty ||
                          int.tryParse(controller.itemsTextController.text) ==
                              0) {
                        controller.items.value = 1;
                        controller.itemsTextController.text = '1';
                      } else if (int.tryParse(
                              controller.itemsTextController.text)! >
                          product.quantity) {
                        controller.items.value = product.quantity;
                        controller.itemsTextController.text =
                            product.quantity.toString();
                      }
                      
                    },
                  ),
                ),
                counterButton(
                    label: '+',
                    onPressed: controller.increment,
                    tag: product.id,
                    quantity: product.quantity),
                const SizedBox(width: 16),
                Text('Available: ${product.quantity}',
                    style: const TextStyle(color: Colors.grey)),
              ],
            );
  }
}