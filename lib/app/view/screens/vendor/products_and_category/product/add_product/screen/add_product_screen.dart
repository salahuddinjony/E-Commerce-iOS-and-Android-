import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:local/app/view/screens/vendor/products_and_category/common_widgets/image_upload_widget/image_upload_widget.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/add_product/widgets/category_select_widget.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/add_product/widgets/multi_selected_field.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/add_product/widgets/single_select_dropdown.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/controller/vendor_product_controller.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddProductScreen extends StatelessWidget {
  final String? method;
  final String? productId;
  final String? productName;
  final String? imageUrl;
  final String? categoryId;
  final String? categoryName;
  final List<String>? selectedColor;
  final List<String>? selectedSize;
  final String? price;
  final String? quantity;
  final String? isFeatured;

  AddProductScreen(
      {super.key,
      this.method,
      this.productId,
      this.categoryId,
      this.categoryName,
      this.productName,
      this.imageUrl,
      this.price,
      this.quantity,
      this.isFeatured,
      this.selectedColor,
      this.selectedSize});

  final VendorProductController controller =
      Get.find<VendorProductController>();

  @override
  Widget build(BuildContext context) {
    // Initialize controller fields when the widget is built
    if (method == 'PATCH') {
      controller.initializeForEdit(
        productName: productName,
        colors: selectedColor,
        sizes: selectedSize,
        price: price,
        quantity: quantity,
        isFeaturedValue: isFeatured,
        categoryId: categoryId,
        categoryName: categoryName,
        image: imageUrl!,
      );
    } else {
      // Clear fields for new product
      controller.initializeForEdit(image: '');
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        iconData: Icons.arrow_back,
        appBarContent: method == 'POST' ? "Add Product" : "Edit Product",
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Upload image
              ImageUploadWidget<VendorProductController>(
                controller: controller,
                imagePath: controller.imagePath,
                isNetworkImage: controller.isNetworkImage,
                onPickImage: (ctrl, source) => ctrl.pickImage(source: source),
                onClearImage: () => controller.clearImage(),
              ),

              SizedBox(height: 20.h),

              /// Product Name
              CustomFromCard(
                hinText: "Enter product name",
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
                options: const ['true', 'false'],
                selectedValue: controller.isFeatured,
                hintText: 'Select Customizable',
                onChanged: controller.setIsFeatured,
              ),
              SizedBox(height: 20.h),
              CustomFromCard(
                hinText: "Enter quantity",
                title: "Qunatity",
                controller: controller.quantityController,
                validator: (v) {},
              ),
              SizedBox(height: 20.h),

              /// Price
              CustomFromCard(
                hinText: "Enter price",
                title: "Price (\$)",
                controller: controller.priceController,
                validator: (v) {},
              ),
              SizedBox(height: 20.h),

              /// Submit Button
              CustomButton(
                title: method == 'POST' ? "Submit" : "Update",
                onTap: () async {
                  bool success = await controller.createOrUpdateProduct(
                      method: method!, productId: productId);

                  if (success) {
                    controller.fetchProducts();
                    context.pop();
                  }
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
