import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common_widgets/custom_network_image/custom_network_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  CustomNetworkImage(
                    imageUrl: product.image ?? '', // fallback to empty string if null
                    height: 119.h,
                    width: 119.w,
                  ),
                  Positioned(
                    right: 0, 
                    top: 0,
                    child: PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, size: 20, color: Colors.white),
                      onSelected: (value) {
                        if (value == 'edit') {
                          // Handle edit
                        } else if (value == 'delete') {
                          // Handle delete
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
                product.title ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                product.subtitle ?? '',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
              Text(
                product.price ?? '',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                product.sold ?? '',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class Product {
  final String? image;
  final String? title;
  final String? subtitle;
  final String? price;
  final String? sold;

  Product({
    this.image,
    this.title,
    this.subtitle,
    this.price,
    this.sold,
  });
}
