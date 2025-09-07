import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_text_field/custom_text_field.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/product_details/category_wise_product/category_product_controller.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/product_details/category_wise_product/widgets/build_header.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/product_details/category_wise_product/widgets/build_product_grid.dart';

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
            buildHeader(
                controller: controller,
                categoryName: categoryName,
                categoryImage: categoryImage,
                products: products),
            SizedBox(height: 12.h),
            products.isNotEmpty
                ? CustomTextField(
                    inputTextStyle:
                        TextStyle(fontSize: 14.sp, color: AppColors.black),
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
                              child: Icon(Icons.clear,
                                  size: 20.r, color: Colors.grey),
                            )
                          : const SizedBox.shrink();
                    }),
                  )
                : const SizedBox.shrink(),
            SizedBox(height: 12.h),
            buildProductGrid(
                controller: controller,
                products: products,
                categoryName: categoryName),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
