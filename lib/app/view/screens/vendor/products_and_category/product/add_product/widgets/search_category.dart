import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/controller/vendor_product_controller.dart';
import 'dart:math';

class SearchCategory extends StatelessWidget {
  final VendorProductController controller;

  const SearchCategory({super.key, required this.controller});



  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.all(10.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      backgroundColor: AppColors.white,
      title: Column(
        children: [
          Text(
            "Select Category",
            style: TextStyle(
              color: AppColors.darkNaturalGray,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 10.h),
          // Search bar
          TextField(
            controller: controller.searchController,
            decoration: InputDecoration(
              hintText: "Search Categories",
              hintStyle: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
              ),
              filled: true,
              fillColor: AppColors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            ),
            style: TextStyle(
              color: AppColors.darkNaturalGray,
              fontSize: 14.sp,
            ),
            onChanged: (value) {
              controller.filterCategories(value);
            },
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        height: min(controller.filteredCategories.length * 50.h, 300.h),
        child: Obx(
          () => controller.filteredCategories.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 50.h),
                  child: Center(
                    child: Text(
                      "No Categories Found",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  itemCount: controller.filteredCategories.length,
                  separatorBuilder: (context, index) => Divider(
                    color: Colors.grey.shade300,
                    height: 1.h,
                  ),
                  itemBuilder: (context, index) {
                    final category = controller.filteredCategories[index];
                    return ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.w),
                      title: Text(
                        "${index + 1}. ${category.name}",
                        style: TextStyle(
                          color: AppColors.darkNaturalGray,
                          fontSize: 14.sp,
                        ),
                      ),
                      onTap: () {
                        controller.setSelectedCategory(category.id);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: TextStyle(
              color: AppColors.darkNaturalGray,
              fontSize: 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}