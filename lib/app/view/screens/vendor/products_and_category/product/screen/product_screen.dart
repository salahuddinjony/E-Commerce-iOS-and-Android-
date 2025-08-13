import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/screen/categories_screen.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/controller/vendor_product_controller.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/widgets/products_grid_section.dart';
import '../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../common_widgets/custom_appbar/custom_appbar.dart';
import '../../../../../common_widgets/owner_nav/owner_nav.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({super.key});

  final VendorProductController vendorProductController =
      Get.put(VendorProductController());


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        bottomNavigationBar: const OwnerNav(currentIndex: 2),
        backgroundColor: AppColors.white,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 48),
          child: Column(
            children: [
              CustomAppBar(appBarContent: "Products & Categories"),
              TabBar(
                indicatorColor: AppColors.brightCyan,
                labelColor: AppColors.brightCyan,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Products"),
                  Tab(text: "Categories"),
                ],
              ),
            ],
          ),
        ),
        body: Padding(
          
          padding: const EdgeInsets.all(12),
          child: TabBarView(
            children: [
            ProductsGridSection(),
            const CategoriesScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
