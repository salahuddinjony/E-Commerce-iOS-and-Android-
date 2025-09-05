import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/product_details/widgets/available_size_color.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/product_details/widgets/counter_button_andThumbnail.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/model/product_response.dart';

import '../../../../../../core/route_path.dart';
import 'product_details_controller.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductItem product;
  final String vendorId;
  final String productCategoryName;

  ProductDetailsScreen(
      {super.key,
      required this.product,
      required this.vendorId,
      required this.productCategoryName});

  late final ProductDetailsController controller =
      Get.isRegistered<ProductDetailsController>(tag: product.id)
          ? Get.find<ProductDetailsController>(tag: product.id)
          : Get.put(ProductDetailsController(), tag: product.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "Product Details",
        iconData: Icons.arrow_back,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main product image
            Center(
              child: Container(
                width: 400,
                height: 250,
                decoration: BoxDecoration(
                  // color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.images.isNotEmpty
                      ? product.images.first.replaceFirst(
                                    'http://10.10.20.19:5007',
                                    'https://gmosley-uteehub-backend.onrender.com',
                                  )
                      : AppConstants.teeShirt,
                  fit: BoxFit.contain,
                  width: 400,
                  height: 250,
                  placeholder: (context, url) => Center(child: CustomLoader()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Title and subtitle
            Text(
              product.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Icon(Icons.category, color: Colors.grey, size: 18),
                const SizedBox(width: 6),
                Text(
                  productCategoryName.toString(),
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 14),
                children: [
                  const TextSpan(text: 'These '),
                  TextSpan(
                    text: 'T-shirts',
                    style: TextStyle(color: Colors.blue.shade700),
                  ),
                  const TextSpan(
                      text:
                          ' are dominating the fashion scene with their unique designs and top-quality fabric. Pick your favorite now!'),
                ],
              ),
            ),
            const SizedBox(height: 8),

            //rating and sold
            // const Text(
            //   '\$20.22',
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(height: 16),
            // // Rating and sold
            // Row(
            //   children: [
            //     const Icon(Icons.star, color: Colors.amber, size: 18),
            //     const SizedBox(width: 4),
            //     const Text('4.5'),
            //     const SizedBox(width: 16),
            //     const Text('Sold (100)'),
            //   ],
            // ),
            // const SizedBox(height: 16),
            // // Thumbnails row (placeholder images)
            // SizedBox(
            //   height: 70,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       thumbnail(AppConstants.teeShirt),
            //       thumbnail(AppConstants.teeShirt),
            //       thumbnail(AppConstants.teeShirt),
            //     ],
            //   ),
            // ),
            const SizedBox(height: 16),
            // Items counter
            const Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                counterButton(label: '-', onPressed: controller.decrement, tag: product.id, quantity: product.quantity),
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
                          int.tryParse(controller.itemsTextController.text) == 0) {
                        controller.items.value = 1;
                        controller.itemsTextController.text = '1';
                      }
                    },
                  ),
                ),
                counterButton(label: '+', onPressed: controller.increment, tag: product.id, quantity: product.quantity),
                const SizedBox(width: 16),
                Text('Available: ${product.quantity}',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            // Size options
            const Text('Available Sizes',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
             AvailableSizeColor( list: product.size, isColor: false, controller: controller),
            const SizedBox(height: 16),
            const Text('Available Colors',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

             AvailableSizeColor( list: product.colors, isColor: true, controller: controller),

            const SizedBox(height: 16),
            // Shipping options
            const Text('Shipping Options:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Obx(() => CheckboxListTile(
                  title: const Text('Standard Shipping (5-7 days)'),
                  value: controller.standardShipping.value,
                  onChanged: (val) => controller.toggleStandard(val ?? false),
                  secondary: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text('\$10',
                        style: TextStyle(color: Colors.teal)),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                )),
            Obx(() => CheckboxListTile(
                  title: const Text('Express Shipping (2-3 days)'),
                  value: controller.expressShipping.value,
                  onChanged: (val) => controller.toggleExpress(val ?? false),
                  secondary: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal),
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text('\$10',
                        style: TextStyle(color: Colors.teal)),
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
                  onChanged: (val) =>
                      controller.toggleHomeDelivery(val ?? false),
                  secondary: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal),
                        borderRadius: BorderRadius.circular(8)),
                    child:
                        const Text('\$8', style: TextStyle(color: Colors.teal)),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                )),
            const SizedBox(height: 8),
            const Text('Hub Fee 20%',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Obx(() => Text(
                'Total Cost: \$${controller.totalCost.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.teal))),

            const SizedBox(height: 16),
            CustomButton(
              onTap: () {
                context.pushNamed(
                  RoutePath.addAddressScreen,
                );
              },
              title: "order Now",
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
