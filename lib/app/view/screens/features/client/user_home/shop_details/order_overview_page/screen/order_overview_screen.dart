import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/order_overview_page/widgets/delivery_summery_customer_info.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/order_overview_page/widgets/product_imsge_and_details_overview.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/product_details/widgets/order_overview_row.dart';

class OrderOverviewScreen extends StatelessWidget {
  final String vendorId;
  final String productId;
  final String productName;
  final String productCategoryName;
  final controller;
  final bool isCustom;
  final String productImage;

  const OrderOverviewScreen({
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
              ProductImageAndDetailsOverview(
                productImage: productImage,
                productName: productName,
                productCategoryName: productCategoryName,
                isCustom: isCustom,
                controller: controller,
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
                fieldName:"$productName (${controller.items.value} items x \$${controller.basePrice.toStringAsFixed(2)})",
                fieldValue: '\$${controller.priceOfItems.toStringAsFixed(2)}',
                isTrue: true,
              ),
              const SizedBox(height: 4),
              OrderOverviewRow(
                fieldName: 'Hub Fee 20% of \$${controller.subTotal.toString()}',
                fieldValue:
                    '\$${(controller.hubfee).toStringAsFixed(2)}',
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

              // Delivery summary--> customer info
              DeliverySummaryCustomerInfo(controller: controller),

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
