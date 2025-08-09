import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/view/common_widgets/confirm_dialog_box.dart/confirm_dialog.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/add_product/add_product_screen.dart';
import 'package:local/app/view/screens/vendor/products_and_category/product/model/product_response.dart';
import '../../../../../common_widgets/custom_network_image/custom_network_image.dart';

class ProductCard extends StatelessWidget {
  final ProductItem productData;

  const ProductCard({super.key, required this.productData});

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
                CustomNetworkImage(
                  imageUrl: productData.images
                      .toString(), // fallback to empty string if null
                  height: 90.h,
                  width: 119.w,
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                     AddProductScreen()));
                      } else if (value == 'delete') {
                        showDialog(
                            context: context,
                            builder: (context) => ConfirmDialog(
                                  title: 'Delete Category',
                                  content:
                                      'Are you sure you want to delete this category?',
                                  onConfirm: () {
                                    
                                    Navigator.pop(context);
                                  },
                                ));
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
              productData.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              productData.size.isNotEmpty
                  ? 'Size: ${productData.size.join(', ')}'
                  : 'Size: Not specified',
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${productData.price} ${productData.currency}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Text(
                  '${productData.quantity.toString()} in stock',
                  style: TextStyle(color: Colors.grey[600], fontSize: 10),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
