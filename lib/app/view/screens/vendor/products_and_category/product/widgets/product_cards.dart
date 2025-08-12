import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:local/app/view/common_widgets/confirm_dialog_box.dart/confirm_dialog.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/add_product/screen/add_product_screen.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/controller/vendor_product_controller.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/model/product_response.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/services/product_services.dart';
import '../../../../../common_widgets/custom_network_image/custom_network_image.dart';

class ProductCard extends StatelessWidget {
  final ProductItem productData;
  final VoidCallback? onProductDeleted;

   ProductCard({
    super.key,
    required this.productData,
    this.onProductDeleted,
  });
    VendorProductController vendorProductController =
      Get.find<VendorProductController>();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Check if product has images and display them, otherwise show a placeholder
                productData.images.isNotEmpty &&
                        productData.images.first.isNotEmpty
                    ? CustomNetworkImage(
                        imageUrl: productData.images.first,
                        height: 90.h,
                        width: 119.w,
                      )
                    : Container(
                        height: 90.h,
                        width: 119.w,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.image_not_supported,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                      ),
                Positioned(
                  right: -22,
                  top: 0,
                  child: PopupMenuButton<String>(
                    color: Colors.white,
                    icon: Icon(Icons.more_vert,
                        size: 20, color: Colors.grey[800]),
                    onSelected: (value) {
                      if (value == 'edit') {
                       vendorProductController.fetchCategories();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddProductScreen(
                                    method: 'PATCH',
                                    productId: productData.id,
                                    productName: productData.name,
                                    imageUrl: productData.images.isNotEmpty
                                        ? productData.images.first
                                        : '',
                                    categoryId: productData.category,
                                    selectedColor: productData.colors,
                                    selectedSize: productData.size,
                                    price: productData.price.toString(),
                                    quantity: productData.quantity.toString(),
                                    isFeatured: productData.isFeatured
                                        ? 'true'
                                        : 'false')));
                      } else if (value == 'delete') {
                        showDialog(
                          context: context,
                          builder: (context) => ConfirmDialog(
                            title: 'Delete Product',
                            content:
                                'Are you sure you want to delete this product?',
                            onConfirm: () async {
                              // Delete the product using the service
                              final success =
                                  await ProductServices.deleteProduct(
                                      productData.id);
                              if (success && onProductDeleted != null) {
                                onProductDeleted!();
                              }
                            },
                          ),
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              (productData.name).length > 15
                  ? "${productData.name.substring(0, 15)}.."
                  : productData.name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              productData.size.isNotEmpty
                  ? 'Size: ${productData.size.join(', ')}'
                  : 'Size: Not specified',
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.amber,
              ),
              padding: const EdgeInsets.all(1.5), // optional for spacing
              child: Text(
                '${productData.price} ${productData.currency}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            Text(
              '${productData.quantity.toString()} in stock',
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
