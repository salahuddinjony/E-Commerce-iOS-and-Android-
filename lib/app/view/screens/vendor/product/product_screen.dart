import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/screens/vendor/product/controller/vendor_product_controller.dart';
import 'package:local/app/view/screens/vendor/product/widgets/product_cards.dart';

import '../../../../core/route_path.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../common_widgets/custom_appbar/custom_appbar.dart';
import '../../../common_widgets/custom_button/custom_button.dart';
import '../../../common_widgets/owner_nav/owner_nav.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  final VendorProductController vendorProductController =
      Get.put(VendorProductController());

  final List<Product> products = [
    Product(
      image: AppConstants.teeShirt,
      title: 'Party Mode Tee',
      subtitle: 'Top Rated Price',
      price: '\$22.20',
      sold: 'Sold (106)',
    ),
    Product(
      image: AppConstants.teeShirt,
      title: 'Guitar Soul Tee',
      subtitle: 'Top Rated Price',
      price: '\$22.20',
      sold: 'Sold (4.3k)',
    ),
    Product(
      image: AppConstants.teeShirt,
      title: 'Space Explorer',
      subtitle: 'Top Rated Price',
      price: '\$22.20',
      sold: 'Sold (1.7k)',
    ),
    Product(
      image: AppConstants.teeShirt,
      title: 'Party Mode Tee',
      subtitle: 'Top Rated Price',
      price: '\$22.20',
      sold: 'Sold (106)',
    ),
    Product(
      image: AppConstants.teeShirt,
      title: 'Guitar Soul Tee',
      subtitle: 'Top Rated Price',
      price: '\$22.20',
      sold: 'Sold (4.3k)',
    ),
    Product(
      image: AppConstants.teeShirt,
      title: 'Space Explorer',
      subtitle: 'Top Rated Price',
      price: '\$22.20',
      sold: 'Sold (1.7k)',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const OwnerNav(currentIndex: 2),
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "Products",
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            products.isEmpty
                ? Center(
                    child: Text(
                      "No Products Found",
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  )
                : Obx(()=>
                vendorProductController.userIndex.value=='product' ? Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 12.h,
                        crossAxisSpacing: 12.w,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(product: products[index]);
                      },
                    ),
                  ) : Text("Here Show the producs"),
                  ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CustomButton(
                    title: "Add Product",
                    onTap: () {
                       vendorProductController.toggleUserIndex(selectedIndex: 'category');
                      // context.pushNamed(RoutePath.addProductScreen);
                    },
                    textColor: AppColors.white,
                    fillColor: AppColors.brightCyan,
                  ),
                ),
                SizedBox(
                  width: 12.w,
                ),
                Expanded(
                  flex: 5,
                  child: CustomButton(
                    title: "Add Category",
                    onTap: () {
                      vendorProductController.toggleUserIndex(selectedIndex: 'product');
                    },
                    textColor: AppColors.white,
                    fillColor: AppColors.brightCyan,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
