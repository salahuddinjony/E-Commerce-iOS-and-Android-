import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/custom_assets/assets.gen.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:local/app/view/screens/vendor/products_and_category/category/widgets/image_upload_widget.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/controller/vendor_product_controller.dart';
import '../../../../../../utils/app_colors/app_colors.dart';
import '../../../../../common_widgets/custom_appbar/custom_appbar.dart';
import '../../../../../common_widgets/custom_text/custom_text.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  final VendorProductController controller =
      Get.find<VendorProductController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        iconData: Icons.arrow_back,
        appBarContent: "Add Product",
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Upload image placeholder
              Center(
            //  child: ImageUploadWidget(categoryController: controller),
              ),
              SizedBox(height: 20.h),

              /// Product Name
              CustomFromCard(
                hinText: "U Tee Hub",
                title: "Product Name",
                controller: controller.productNameController,
                validator: (v) {},
              ),

              /// Category dropdown
              /// Category dropdown
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
      // Show a dialog with the category list
     controller.categoriesData.isEmpty
     ? null
     :  showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(10.w),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            backgroundColor: AppColors.white,
            title: Text(
              "Select Category out of ${controller.categoriesData.length} Categories",
              style: TextStyle(
                color: AppColors.darkNaturalGray,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: min(controller.categoriesData.length * 50.h, 300.h), // Dynamic height, max 300
              child: controller.categoriesData.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Text(
                        "No Categories Found",
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14.sp,
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: controller.categoriesData.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey.shade300,
                        height: 1.h,
                      ),
                      itemBuilder: (context, index) {
                        return ListTile(
                     
                          enabled: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
                          title: Text(
                            "${index + 1}. ${controller.categoriesData[index].name}",
                            style: TextStyle(
                              color: AppColors.darkNaturalGray,
                              fontSize: 14.sp,
                            ),
                          ),
                          onTap: () {
                            controller.setSelectedCategory(
                              controller.categoriesData[index].id,
                            );
                            Navigator.pop(context);
                          },
                        );
                      },
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
           controller.selectedCategory.value.isNotEmpty
                ?  controller.selectedCategory.value.isEmpty
                ? "Select Category"
                : controller.categoriesData
                    .firstWhere(
                      (category) => category.id == controller.selectedCategory.value,
                      orElse: () => controller.categoriesData.first, // Fallback
                    )
                    .name: "No Category are Available",
            style: TextStyle(
              color: AppColors.darkNaturalGray,
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
              // Obx(
              //   () => DropdownButtonFormField<String>(
              //     value: controller.selectedCategory.value.isEmpty
              //         ? null
              //         : controller.selectedCategory.value,
              //     decoration: InputDecoration(
              //       filled: true,
              //       fillColor: AppColors.white,
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(8.r),
              //         borderSide: BorderSide(color: Colors.grey.shade300),
              //       ),
              //     ),
              //     dropdownColor: AppColors.white,
              //     hint: const Text("Select Category"),
              //     items: controller.categoryOptions.map((String category) {
              //       return DropdownMenuItem<String>(
              //         value: category,
              //         child: Text(category),
              //       );
              //     }).toList(),
              //     onChanged: (value) {
              //       if (value != null) {
              //         controller.setSelectedCategory(value);
              //       }
              //     },
              //   ),
              // ),

              SizedBox(height: 20.h),

              /// Colors multi-select
              CustomText(
                font: CustomFont.inter,
                color: AppColors.darkNaturalGray,
                text: 'Colors Available',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                bottom: 8.h,
              ),
              Obx(
                () => MultiSelectDialogField<String>(
                  items: controller.colors.keys
                      .map((color) => MultiSelectItem<String>(color, color))
                      .toList(),
                  initialValue: controller.selectedColor.toList(),
                  title: const Text("Select Colors"),
                  selectedColor: Colors.black,
                  backgroundColor: AppColors.white,
                  dialogHeight: 300.h,
                  searchable: true,
                  searchHint: "Search Colors",
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  buttonText: Text(
                    controller.selectedColor.isEmpty
                        ? "Select Colors"
                        : controller.selectedColor.join(", "),
                    style: TextStyle(
                      color: AppColors.darkNaturalGray,
                      fontSize: 16.sp,
                    ),
                  ),

                  // Hide selected chips under the field
                  chipDisplay: MultiSelectChipDisplay.none(),
                  buttonIcon: const Icon(
                    Icons.arrow_drop_down, // Your custom icon here
                    color: AppColors.darkNaturalGray,
                  ),
                  onConfirm: (List<String> values) {
                    controller.setSelectedColor(values);
                  },
                ),
              ),

              SizedBox(height: 20.h),

              /// Sizes multi-select
              CustomText(
                font: CustomFont.inter,
                color: AppColors.darkNaturalGray,
                text: 'Sizes Available',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                bottom: 8.h,
              ),
              Obx(
                () => MultiSelectDialogField<String>(
                  items: controller.sizes
                      .map((size) => MultiSelectItem<String>(size, size))
                      .toList(),
                  initialValue: controller.selectedSize.toList(),
                  title: const Text("Select Sizes"),
                  selectedColor: Colors.black,
                  backgroundColor: AppColors.white,
                  dialogHeight: 300.h,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.r)),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  buttonText: Text(
                    controller.selectedSize.isEmpty
                        ? "Select Sizes"
                        : controller.selectedSize.join(", "),
                    style: TextStyle(
                      color: AppColors.darkNaturalGray,
                      fontSize: 16.sp,
                    ),
                  ),

                  // Hide selected chips under the field
                  chipDisplay: MultiSelectChipDisplay.none(),

                  // Use buttonIcon to change or remove the icon
                  buttonIcon: const Icon(
                    Icons.arrow_drop_down, // Your custom icon here
                    color: AppColors.darkNaturalGray,
                  ),

                  // To remove icon completely, use:
                  // buttonIcon: null,
                  onConfirm: (List<String> values) {
                    controller.setSelectedSize(values);
                  },
                ),
              ),

              SizedBox(height: 20.h),

              /// Customizable dropdown
              CustomText(
                font: CustomFont.inter,
                color: AppColors.darkNaturalGray,
                text: 'Customizable',
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
                bottom: 8.h,
              ),
              Obx(
                () => DropdownButtonFormField<String>(
                  value: controller.selectedCustomizable.value.isEmpty
                      ? null
                      : controller.selectedCustomizable.value,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.r),
                      borderSide:
                          const BorderSide(color: AppColors.darkNaturalGray),
                    ),
                  ),
                  dropdownColor: AppColors.white,
                  hint: const Text("Select Customizable"),
                  items: controller.customizable.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.setSelectedCustomizable(value);
                    }
                  },
                ),
              ),

              SizedBox(height: 20.h),

              /// Price
              CustomFromCard(
                hinText: "20\$",
                title: "Price (\$)",
                controller: controller.priceController,
                validator: (v) {},
              ),

              SizedBox(height: 20.h),

              /// Submit Button
              CustomButton(
                title: "Submit",
                onTap: () {
                  controller.selectedColor.clear();
                  controller.selectedSize.clear();
                  // Add submission logic here
                  context.pop();
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
