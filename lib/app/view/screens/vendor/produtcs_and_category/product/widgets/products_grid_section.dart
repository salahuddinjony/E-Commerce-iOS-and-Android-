import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/vendor/produtcs_and_category/product/add_product/add_product_screen.dart';
import 'package:local/app/view/screens/vendor/produtcs_and_category/product/controller/vendor_product_controller.dart';
import 'package:local/app/view/screens/vendor/produtcs_and_category/product/widgets/product_cards.dart';


class ProductsGridSection extends StatelessWidget {
  ProductsGridSection({super.key});

  VendorProductController vendorProductController =
      Get.put(VendorProductController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Expanded(
          child: Obx(() {
            final products = vendorProductController.productItems;

            if (products.isEmpty) {
              return Center(
                child: Text(
                  "No Products Found",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.grey[600],
                  ),
                ),
              );
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 2.h,
                crossAxisSpacing: 2.w,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductCard(productData: products[index]);
              },
            );
          }),
        ),
        SizedBox(height: 20.h),
        CustomButton(
          onTap: () {
            print("Add Product Button Pressed");
            vendorProductController.fetchProducts();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddProductScreen()),
            );
          },
          title: "Add Product",
          isRadius: true,
        ),
      ],
    );
  }
}
