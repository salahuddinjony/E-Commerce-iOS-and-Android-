import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/product_details/widgets/order_overview_row.dart';

class CustomOrderScreen extends StatelessWidget {
  final String vendorId;
  final String productId;
  final String productName;
  final String productCategoryName;
  final controller;
  final bool isCustom;
  final String productImage;

  const CustomOrderScreen({
    super.key,
    this.vendorId = '',
    this.productId = '',
    this.productName = '',
    this.controller,
    this.productCategoryName = '',
    required this.isCustom,
    required this.productImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        appBarContent:
            isCustom ? "Custom Design Overview" : "General Order Overview",
        iconData: Icons.arrow_back,
      ),
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row with image and details
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomNetworkImage(
                      imageUrl: productImage, height: 150, width: 200),
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
                         Text(
                         productCategoryName,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
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
                                          color: Color(int.parse(controller
                                              .color.value
                                              .replaceFirst('#', '0xff'))),
                                          borderRadius:
                                              BorderRadius.circular(4),
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
              ),
              const SizedBox(height: 20),

              // Order Summary section
              const Text(
                'Order Summary',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 0.3),
              ),
              const SizedBox(height: 10),
              OrderOverviewRow(
                fieldName: 'Standard Shipping',
                fieldValue: '\$10',
                isTrue: controller.standardShipping.value,
              ),
              const SizedBox(height: 4),

              OrderOverviewRow(
                fieldName: 'Express Shipping',
                fieldValue: '\$10',
                isTrue: controller.expressShipping.value,
              ),
              const SizedBox(height: 4),
              OrderOverviewRow(
                fieldName: 'Home Delivery',
                fieldValue: '\$8',
                isTrue: controller.homeDelivery.value,
              ),
              const SizedBox(height: 4),
              OrderOverviewRow(
                fieldName: 'Hub Fee 20% of ${controller.subTotal.toString()}',
                fieldValue:
                    '\$${(controller.priceOfItems * 0.2).toStringAsFixed(2)}',
                isTrue: true,
              ),

              const Divider(height: 30, thickness: 1),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    '\$${controller.totalCost.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )
                ],
              ),

              const SizedBox(height: 30),

              // Delivery (refreshed UI — compact, non-profile style)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: AppColors.brightCyan, blurRadius: 1, offset: Offset(0, 0.5))
                  ],
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // vertical accent bar
                    Container(
                      width: 6,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.brightCyan,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // details column
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // header with edit
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Delivery To',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                   Navigator.pop(context);
                                },
                                icon: const Icon(Icons.edit, size: 18),
                                label: const Text('Edit'),
                                style: TextButton.styleFrom(
                                  minimumSize: const Size(0, 30),
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 8),

                          // name + phone as compact row
                          Text(
                            (controller?.customerNameController.text ?? '').isNotEmpty
                                ? controller.customerNameController.text
                                : 'No recipient name',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),

                          // address block
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.location_on, size: 16, color: Colors.redAccent),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  (controller?.customerAddressController.text ?? '').isNotEmpty
                                      ? controller.customerAddressController.text
                                      : 'No address provided',
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // chips for city/region and phone
                          Row(
                            children: [
                              if ((controller?.customerRegionCityController.text ?? '').isNotEmpty)
                                Chip(
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: AppColors.brightCyan.withValues(alpha: .12),
                                  label: Text(
                                    controller.customerRegionCityController.text,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              if ((controller?.customerPhoneController.text ?? '').isNotEmpty)
                                Chip(
                                  backgroundColor: Colors.lightBlue.withValues(alpha: .2),
                                  visualDensity: VisualDensity.compact,
                                  avatar: const Icon(Icons.phone, size: 16),
                                  label: Text(
                                    controller.customerPhoneController.text,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Payment options
              const Text(
                'Payment Options',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    letterSpacing: 0.3),
              ),

              const SizedBox(height: 25),

              // Apple Pay button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brightCyan,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(
                  Icons.apple,
                  color: AppColors.white,
                ),
                label: const Text(
                  'Apple Pay',
                  style: TextStyle(fontSize: 16, color: AppColors.white),
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
