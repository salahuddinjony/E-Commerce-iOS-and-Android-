import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/not_found.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/vendor_product_card.dart';

Widget buildProductGrid(
    {required controller,
    required RxList<dynamic> products,
    required String categoryName}) {
  return Obx(() {
    // final list = controller.filteredProducts;
    final list = products;

    if (products.isEmpty) {
      var categoryName;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 100.h),
          NotFound(
              message: 'No products available in "$categoryName"',
              icon: Icons.store_mall_directory),
          SizedBox(height: 5.h),
          Text('Please check back later.',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600)),
        ],
      );
    }

    if (list.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 36.h),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.search_off, size: 56.r, color: Colors.grey),
              SizedBox(height: 8.h),
              Text(
                  'No products found ${controller.searchText.value.isEmpty ? '' : 'of "${controller.searchText.value}" '}',
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey)),
              SizedBox(height: 4.h),
              Text('Try a different keyword or clear the search.',
                  style:
                      TextStyle(fontSize: 12.sp, color: Colors.grey.shade600)),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 2.w,
        mainAxisSpacing: 5.h,
        childAspectRatio: 0.7,
      ),
      itemBuilder: (context, index) {
        final item = list[index];
        return GestureDetector(
          onTap: () {
            context.pushNamed(
              RoutePath.productDetailsScreen,
              extra: {
                'product': list[index],
                'vendorId': list[index].creator,
                'productCategoryName': categoryName,
              },
            );
          },
          child: VendorProductCard(
            imageUrl: item.images[0],
            productName: item.name,
            productPrice: item.price.toString(),
          ),
        );
      },
    );
  });
}
