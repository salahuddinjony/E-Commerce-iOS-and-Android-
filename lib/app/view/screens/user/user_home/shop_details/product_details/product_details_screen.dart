import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_loader/custom_loader.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/product_details/widgets/available_size_color.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/product_details/widgets/items_count.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/product_details/widgets/shipping_option.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/model/product_response.dart';

import '../../../../../../core/route_path.dart';
import 'controller/product_details_controller.dart';

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
          : Get.put(
              ProductDetailsController(
                basePrice: product.price.toDouble(),
              ),
              tag: product.id,
            );

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
            const SizedBox(height: 16),

            // Price
            Container(
              width: 80,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.attach_money,
                      color: Colors.green.shade700, size: 20),
                  Text(
                    '${product.price}',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // RichText(
            //   text: TextSpan(
            //     style: const TextStyle(color: Colors.black87, fontSize: 14),
            //     children: [
            //       const TextSpan(text: 'These '),
            //       TextSpan(
            //         text: 'T-shirts',
            //         style: TextStyle(color: Colors.blue.shade700),
            //       ),
            //       const TextSpan(
            //           text:
            //               ' are dominating the fashion scene with their unique designs and top-quality fabric. Pick your favorite now!'),
            //     ],
            //   ),
            // ),

            // const SizedBox(height: 16),
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

            // Items counter
            const Text('Items', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ItemsCount(controller: controller, product: product),

            const SizedBox(height: 16),

            // Size options
            const Text('Available Sizes',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            AvailableSizeColor(
                list: product.size, isColor: false, controller: controller),
            const SizedBox(height: 16),
            const Text('Available Colors',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),

            AvailableSizeColor(
                list: product.colors, isColor: true, controller: controller),

            const SizedBox(height: 16),

            // Shipping options
            const Text('Shipping Options:',
                style: TextStyle(fontWeight: FontWeight.bold)),

            ShippingOption(controller: controller),

            const SizedBox(height: 16),
            CustomButton(
              onTap: () {
                context.pushNamed(
                  RoutePath.addAddressScreen,
                  extra: {
                    'vendorId': vendorId,
                    'productId': product.id,
                    'productName': product.name,
                    'productCategoryName': productCategoryName,
                    'controller': controller,
                    'isCustomOrder': false,
                    'ProductImage': product.images.isNotEmpty
                        ? product.images.first.replaceFirst(
                          'http://10.10.20.19:5007',
                          'https://gmosley-uteehub-backend.onrender.com',
                        )
                      : AppConstants.teeShirt,
                  },
                );
              },
              title: "Order Now",
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
