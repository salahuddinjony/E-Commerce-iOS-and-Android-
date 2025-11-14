import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_from_card/custom_from_card.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/common_widgets/image_upload_widget/image_upload_widget.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/product/add_product/widgets/category_select_widget.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/product/add_product/widgets/multi_selected_field.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/product/add_product/widgets/single_select_dropdown.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/product/controller/vendor_product_controller.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddProductScreen extends StatefulWidget {
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

  const AddProductScreen(
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

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final VendorProductController controller =
      Get.find<VendorProductController>();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Initialize controller fields when the widget is initialized
    if (widget.method == 'PATCH') {
      controller.initializeForEdit(
        productName: widget.productName,
        colors: widget.selectedColor,
        sizes: widget.selectedSize,
        price: widget.price,
        quantity: widget.quantity,
        isFeaturedValue: widget.isFeatured,
        categoryId: widget.categoryId,
        categoryName: widget.categoryName,
        image: widget.imageUrl!,
      );
    } else {
      // Clear fields for new product
      controller.clear();
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        iconData: Icons.arrow_back,
        appBarContent: widget.method == 'POST' ? "Add Product" : "Edit Product",
      ),
      body: GestureDetector(
        onTap: () {
          // Dismiss keyboard when tapping outside text fields
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.opaque,
        child: Padding(
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
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
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
                options: const ['Yes', 'No'],
                selectedValue: controller.isFeatured,
                hintText: 'Select Customizable',
                onChanged: controller.setIsFeatured,
              ),
              SizedBox(height: 20.h),
              CustomFromCard(
                hinText: "Enter quantities",
                title: "Quantities",
                controller: controller.quantityController,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please enter quantities';
                  }
                  if (int.tryParse(v) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),

              /// Price
              CustomFromCard(
                hinText: "Enter price",
                title: "Price (\$)",
                controller: controller.priceController,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Please enter price';
                  }
                  if (double.tryParse(v) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),

              /// Submit Button
              CustomButton(
                title: widget.method == 'POST' ? "Submit" : "Update",
                onTap: () async {
                  // Unfocus keyboard before submission
                  FocusScope.of(context).unfocus();
                  
                  bool success = await controller.createOrUpdateProduct(
                      method: widget.method!, productId: widget.productId);

                  if (success) {
                    // Ensure keyboard is closed after submission
                    FocusScope.of(context).unfocus();
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
      ),
    );
  }
}
