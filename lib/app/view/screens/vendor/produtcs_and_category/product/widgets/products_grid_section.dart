import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/vendor/produtcs_and_category/product/add_product/add_product_screen.dart';
import 'package:local/app/view/screens/vendor/produtcs_and_category/product/widgets/product_cards.dart';

import '../model/product.dart';

class ProductsGridSection extends StatelessWidget {
  final List<Product> productsList;
  final VoidCallback onAddProduct;

  const ProductsGridSection(
      {super.key, required this.productsList, required this.onAddProduct});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       
        SizedBox(height: 12.h),
        Expanded(
          child: productsList.isEmpty
              ? Center(
                  child: Text(
                    "No Products Found",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 2.h,
                    crossAxisSpacing: 2.w,
                    childAspectRatio: 0.7,
                  ),
                  itemCount: productsList.length,
                  itemBuilder: (context, index) {
                    return ProductCard(productData: productsList[index]);
                  },
                ),
        ),
        SizedBox(height: 20.h),
         CustomButton(
          onTap: () {
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
