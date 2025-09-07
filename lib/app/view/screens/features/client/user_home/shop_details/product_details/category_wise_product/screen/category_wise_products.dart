import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/product_details/category_wise_product/category_product_controller.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/not_found.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/vendor_product_card.dart';

class CategoryWiseProducts extends StatelessWidget {
  final String categoryName;
  final RxList<dynamic> products;
  final String categoryImage;
  final String categoryId;

  const CategoryWiseProducts({
    super.key,
    required this.categoryName,
    required this.products,
    required this.categoryImage,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "CategoryWiseProducts build called for $categoryName, product number: ${products.length}");
    final tag = categoryId;
    final controller = Get.isRegistered<CategoryProductsController>(tag: tag)
        ? Get.find<CategoryProductsController>(tag: tag)
        : Get.put(CategoryProductsController(initialProducts: products),
            tag: tag);

    // Listen to changes in products and update controller
    ever<List<dynamic>>(products, (newProducts) {
      controller.updateProducts(newProducts);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        appBarContent: "Category Products",
        iconData: Icons.arrow_back,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildHeader(controller),
            SizedBox(height: 12.h),
            products.isNotEmpty
                ? buildSearchField(controller)
                : const SizedBox.shrink(),
            SizedBox(height: 12.h),
            buildProductGrid(controller),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget buildHeader(CategoryProductsController controller) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: Stack(
        children: [
          SizedBox(
            height: 110.h,
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: categoryImage.replaceFirst(
                'http://10.10.20.19:5007',
                'https://gmosley-uteehub-backend.onrender.com',
              ),
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[200],
                child: Center(
                  child: SizedBox(
                    width: 32.r,
                    height: 32.r,
                    child: const CircularProgressIndicator(strokeWidth: 2.5),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[300],
                child: Icon(Icons.broken_image, color: Colors.grey, size: 40.r),
              ),
            ),
          ),
          Container(
            height: 110.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: .55),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
          Positioned(
            left: 20.w,
            bottom: 12.h,
            right: 20.w,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    categoryName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 12.w),
                Obx(() {
                  // final count = controller
                  //     .filteredProducts.length; 
                       final count =products.length; // <-- Use filteredProducts

                  return Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: .85),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      '$count item${count == 1 ? '' : 's'}',
                      style: TextStyle(
                        color: AppColors.brightCyan,
                        fontWeight: FontWeight.w600,
                        fontSize: 13.sp,
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSearchField(CategoryProductsController controller) {
    return CustomTextField(
      inputTextStyle: TextStyle(fontSize: 14.sp, color: AppColors.black),
      cursorColor: AppColors.black,
      textEditingController: controller.searchController,
      hintText: 'Search products in $categoryName',
      prefixIcon: const Icon(Icons.search),
      onChanged: controller.filter,
      suffixIcon: Obx(() {
        return controller.searchText.value.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  controller.searchController.clear();
                  controller.filter('');
                },
                child: Icon(Icons.clear, size: 20.r, color: Colors.grey),
              )
            : const SizedBox.shrink();
      }),
    );
  }

  Widget buildProductGrid(CategoryProductsController controller) {
    return Obx(() {
      // final list = controller.filteredProducts;
      final list =products;

      if (products.isEmpty) {
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
                    style: TextStyle(
                        fontSize: 12.sp, color: Colors.grey.shade600)),
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
}
