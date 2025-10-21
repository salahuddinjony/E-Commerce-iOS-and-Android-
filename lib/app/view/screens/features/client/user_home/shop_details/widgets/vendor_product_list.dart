import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/customShimmer_loader.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/not_found.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/vendor_product_card.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/product/model/product_response.dart';

class VendorProductList extends StatelessWidget {
  final controller;
  final String vendorId;

  const VendorProductList({super.key, this.controller, required this.vendorId});

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
        height: 180.h, // height to fit the card + padding
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: productItems.length,
          separatorBuilder: (_, __) => SizedBox(width: 5.w),
          itemBuilder: (context, index) {
            return SizedBox(
              width: 140.w,
              child: GestureDetector(
                onTap: () {
                  
                  // Find the category name based on the product's category ID
                  final catIndex = controller.categoriesData.indexWhere(
                    (category) => category.id == productItems[index].category,
                  );
                  final productCategoryName =
                      catIndex != -1 ? controller.categoriesData[catIndex].name : null;

                  context.pushNamed(
                    RoutePath.productDetailsScreen,
                    extra: {
                      'product': productItems[index],
                      'vendorId': vendorId,
                      'productCategoryName': productCategoryName,
                    },
                  );
                },
                child: VendorProductCard(
                  imageUrl: productItems[index].images.isNotEmpty
                      ? productItems[index].images[0]
                      : '',
                  productName: productItems[index].name,
                  productPrice: productItems[index].price.toString(),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
