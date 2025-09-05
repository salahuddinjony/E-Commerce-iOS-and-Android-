import 'package:flutter/material.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';

class ProductImageAndDetailsOverview extends StatelessWidget {
  final String productImage;
  final String productName;
  final String productCategoryName;
  final bool isCustom;
  final dynamic controller;
  const ProductImageAndDetailsOverview(
      {super.key,
      required this.productImage,
      required this.productName,
      required this.productCategoryName,
      required this.isCustom,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomNetworkImage(imageUrl: productImage, height: 150, width: 200),
        const SizedBox(width: 15),
        // Product details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                productName,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.category,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    productCategoryName,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              isCustom
                  ? const SizedBox.shrink()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Selected Size: ${controller.size}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                            )),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text("Selected Color ",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black,
                                )),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Color(int.parse(controller.color.value
                                    .replaceFirst('#', '0xff'))),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Unit Price: \$${controller.basePrice.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 8),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'QTY: ',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text(
                    '${controller.items}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
