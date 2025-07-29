
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common_widgets/custom_network_image/custom_network_image.dart';

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: CustomNetworkImage(
                imageUrl: product.image, height: 119.h, width: 119.w)),
        const SizedBox(height: 6),
        Text(
          product.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          product.subtitle,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        Text(
          product.price,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          product.sold,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }
}

class Product {
  final String image;
  final String title;
  final String subtitle;
  final String price;
  final String sold;

  Product({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.sold,
  });
}
