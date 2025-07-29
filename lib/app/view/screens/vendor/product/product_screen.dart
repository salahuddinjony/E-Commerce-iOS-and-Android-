import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/screens/vendor/product/widgets/product_cards.dart';

import '../../../../core/route_path.dart';
import '../../../../utils/app_colors/app_colors.dart';
import '../../../common_widgets/custom_appbar/custom_appbar.dart';
import '../../../common_widgets/custom_button/custom_button.dart';
import '../../../common_widgets/owner_nav/owner_nav.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

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
            Expanded(
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.65,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(product: product);
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CustomButton(
                    title: "Add Product",
                    onTap: () {
                      context.pushNamed(
                        RoutePath.addProductScreen,
                      );
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
