import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';

class CategoryCircleCard extends StatelessWidget {
  final controller;
  final String categoryName;
  final String categoryId;
  final String imageUrl;
  const CategoryCircleCard(
      {super.key,
      required this.controller,
      required this.categoryName,
      required this.categoryId,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    debugPrint(
        "CategoryCircleCard build called for, product number: ${controller.productItems.length}");
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          RoutePath.categoryWiseProducts,
          extra: {
            'categoryName': categoryName,
            'categoryId': categoryId,
            'products': controller.productItems
                .where((p) => p.category == categoryId)
                .toList(),
            'categoryImage': imageUrl,
          },
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.green, width: 3),
            ),
            child: CustomNetworkImage(
              imageUrl: imageUrl.replaceFirst(
                'http://10.10.20.19:5007',
                'https://gmosley-uteehub-backend.onrender.com',
              ),
              height: 58,
              width: 58,
              boxShape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            categoryName,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
