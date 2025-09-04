import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/widgets/customShimmer_loader.dart';
import 'package:local/app/view/screens/user/user_home/shop_details/widgets/not_found.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/model/product_response.dart';

class VendorProductList extends StatelessWidget {
  final controller;
  const VendorProductList({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final List<ProductItem> productItems = controller.productItems;

       if(controller.isProductsLoading.value){
        return CustomShimmerLoader();
      }
      if (productItems.isEmpty) {
        return NotFound(
            message: 'No products available',
            icon: Icons.shopping_bag_outlined);
      }
      return SizedBox(
        height: 180, // height to fit the card + padding
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: productItems.length,
          separatorBuilder: (_, __) => SizedBox(width: 5.w),
          itemBuilder: (context, index) {
            return SizedBox(
              width: 140.w, // fixed card width
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(RoutePath.productDetailsScreen);
                },
                child: Card(
                  color: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: CustomNetworkImage(
                          imageUrl:
                              productItems[index].images.first.replaceFirst(
                                    'http://10.10.20.19:5007',
                                    'https://gmosley-uteehub-backend.onrender.com',
                                  ),
                          height: 100.h,
                          width: double.infinity,
                          boxShape: BoxShape.rectangle,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              productItems[index].name.toString(),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "\$${productItems[index].price.toString()}",
                              style: TextStyle(color: Colors.cyan, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
