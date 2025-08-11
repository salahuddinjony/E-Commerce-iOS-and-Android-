import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/add_product/widgets/category_select_widget.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/add_product/widgets/multi_selected_field.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/add_product/widgets/single_select_dropdown.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/add_product/widgets/upload_image_widget.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/controller/vendor_product_controller.dart';
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
              /// Upload image
              ImageUploadWidget(controller: controller),
              SizedBox(height: 20.h),

              /// Product Name
              CustomFromCard(
                hinText: "U Tee Hub",
                title: "Product Name",
                controller: controller.productNameController,
                validator: (v) {},
              ),
              SizedBox(height: 20.h),

              /// Category
              CategorySelectWidget(controller: controller),
              SizedBox(height: 20.h),

              /// Colors
              MultiSelectField(
                title: 'Colors',
                items: controller.colors.entries
                    .map((entry) =>
                        MultiSelectItem<String>(entry.value, entry.key))
                    .toList(),
                selectedValues: controller.selectedColor,
                hintText: 'Select Colors',
                searchHint: 'Search Colors',
                onConfirm: controller.setSelectedColor,
              ),
              SizedBox(height: 20.h),
              SizedBox(height: 20.h),

              /// Sizes
              MultiSelectField(
                title: 'Sizes',
                items: controller.sizes
                    .map((size) => MultiSelectItem<String>(size, size))
                    .toList(),
                selectedValues: controller.selectedSize,
                hintText: 'Select Sizes',
                searchHint: 'Search Sizes',
                onConfirm: controller.setSelectedSize,
              ),
              SizedBox(height: 20.h),

              /// Customizable
              SingleSelectDropdown(
                title: 'Customizable',
                options: controller.isFeatured.isEmpty
                    ? ['Yes', 'No']
                    : ['No', 'Yes'],
                selectedValue: controller.isFeatured,
                hintText: 'Select Customizable',
                onChanged: controller.isFeatured,
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
                  controller.createProduct();
                  controller.getAllData();
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
