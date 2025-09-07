import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/category_circle_card.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/customShimmer_loader.dart';
import 'package:local/app/view/screens/features/client/user_home/shop_details/widgets/not_found.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/category/model/category_response.dart';

class VendorCategories extends StatelessWidget {
  final controller;
  const VendorCategories({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isCategoryLoading.value) {
        return CustomShimmerLoader(isCircleLoader: true);
      }
      final List<CategoryData> categoriesData = controller.categoriesData;
      if (categoriesData.isEmpty) {
        return NotFound(
            message: 'No categories available', icon: Icons.category_outlined);
      }
      return SizedBox(
        height: 100,
        child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 0.w),
          scrollDirection: Axis.horizontal,
          itemCount: categoriesData.length,
          separatorBuilder: (_, __) => SizedBox(width: 20.w),
          itemBuilder: (context, index) { 
            return CategoryCircleCard(
              controller: controller,
              categoryId: categoriesData[index].id,
              categoryName: categoriesData[index].name,
              imageUrl: categoriesData[index].image,
            );
          },
        ),
      );
    });
  }
}
