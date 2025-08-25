import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_text/custom_text.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/add_product/widgets/search_category.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/controller/vendor_product_controller.dart';

class CategorySelectWidget extends StatelessWidget {
  final VendorProductController controller;

  const CategorySelectWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          font: CustomFont.inter,
          color: AppColors.darkNaturalGray,
          text: 'Category',
          fontWeight: FontWeight.w600,
          fontSize: 16.sp,
          bottom: 8.h,
        ),
        Obx(
          () => GestureDetector(
            onTap: () {
              if (controller.categoriesData.isEmpty) return;
              controller.searchController.clear();
              controller.filterCategories('');
              
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return SearchCategory(controller: controller);
                },
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.categoriesData.length != 0
                        ? controller.selectedCategory.value.isNotEmpty
                            ? controller.categoriesData
                                    .firstWhere(
                                      (category) =>
                                          category.id ==
                                          controller.selectedCategory.value,
                                      orElse: () =>
                                          controller.categoriesData.first,
                            )
                            .name
                        : "Select Category"
                        : "Please at first create a category",
                    style: TextStyle(
                      color: controller.categoriesData.length != 0 ? AppColors.darkNaturalGray : Colors.red,
                      fontSize: 16.sp,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.darkNaturalGray,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}