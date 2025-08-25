import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/add_product/screen/add_product_screen.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/controller/vendor_product_controller.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/widgets/product_cards.dart';

class ProductsGridSection extends StatelessWidget {
  ProductsGridSection({super.key});

  final VendorProductController vendorProductController =
      Get.find<VendorProductController>();

  Future<void> _refresh() async {
    await vendorProductController.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Expanded(
          child: RefreshIndicator(
            backgroundColor: Colors.white,
            onRefresh: _refresh,
            color: AppColors.brightCyan,
            child: Obx(() {
              final products = vendorProductController.productItems;

              if (products.isEmpty) {
                // Allow pull-to-refresh even when empty
                return LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Center(
                        child: Text(
                          "No Products Found",
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              return GridView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // it would be 2
                  mainAxisSpacing: 2.h,
                  crossAxisSpacing: 2.w,
                  childAspectRatio: 0.7,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  return ProductCard(
                    productData: products[index],
                    onProductDeleted: () {
                      vendorProductController.fetchProducts();
                    },
                  );
                },
              );
            }),
          ),
        ),
        SizedBox(height: 20.h),
        CustomButton(
          onTap: ()async {
            
            await vendorProductController.fetchCategories();

            if (vendorProductController.categoriesData.isEmpty) {
              return;
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddProductScreen(method: 'POST'),
                ),
              );
            }
          },
          title: "Add Product",
          isRadius: true,
        ),
      ],
    );
  }
}
