import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/view/screens/features/vendor/home/widgets/product_shimmer.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/product/model/product_response.dart';

import '../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../common_widgets/custom_text/custom_text.dart';

class BestSellingProducts extends StatelessWidget {
  final List<ProductItem> productsList;
  const BestSellingProducts({
    super.key,
    required this.productsList,
  });

  List<ProductItem> get bestSellingProducts {
    return productsList.where((p) => p.quantity > 5).toList(); // Example condition for best-selling products
  }

  @override
  Widget build(BuildContext context) {
    if (bestSellingProducts.isEmpty) {
      return const ProductShimmer();
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(bestSellingProducts.length, (index) {
          final product = bestSellingProducts[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
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
                        ? product.images.first.replaceFirst(
                          'http://10.10.20.19:5007',
                          'https://gmosley-uteehub-backend.onrender.com',
                        )
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
                      child: const Icon(Icons.broken_image, color: Colors.grey),
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
          );
        }),
      ),
    );
  }
}
