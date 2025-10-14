import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/state_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/not_found.dart';
import 'package:local/app/view/screens/features/vendor/home/widgets/product_shimmer.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/product/model/product_response.dart';

import '../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../common_widgets/custom_text/custom_text.dart';

class BestSellingProducts extends StatelessWidget {
  final List<ProductItem> productsList;
  final controller;
  const BestSellingProducts({
    super.key,
    required this.productsList,
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final bestSellingProducts = productsList
          .where((product) => product.quantity > 5)
          .toList(); // Example condition for best-selling products
      if (controller.isProductsLoading.value) {
        return const ProductShimmer();
      }
      if (bestSellingProducts.isEmpty) {
        return NotFound(
            message: 'No Best Selling Products Found', icon: Icons.warning);
      }
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(bestSellingProducts.length, (index) {
            final product = bestSellingProducts[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(
                    RoutePath.showProductDetailsScreen,
                    extra: {
                      'product': product,
                    },
                  );
                },
                child: Card(
                  elevation: .3,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                          imageUrl: product.images.isNotEmpty
                              ? product.images.first
                              : '',
                          height: 119,
                          width: 119,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => SizedBox(
                            height: 119,
                            width: 119,
                            child: const Center(
                              child: null,
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 119,
                            width: 119,
                            color: AppColors.brightCyan,
                            alignment: Alignment.center,
                            child: const Icon(Icons.broken_image,
                                color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 10),
                        CustomText(
                          font: CustomFont.poppins,
                          color: AppColors.darkNaturalGray,
                          text: product.name,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.sp,
                        ),
                        CustomText(
                          font: CustomFont.poppins,
                          color: AppColors.darkNaturalGray,
                          text: 'Price: \$${product.price} ',
                          fontWeight: FontWeight.w500,
                          fontSize: 12.sp,
                          bottom: 10.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }
}
