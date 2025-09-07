import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';

class VendorProductCard extends StatelessWidget {
  final String imageUrl;
  final String productName;
  final String productPrice;
  const VendorProductCard(
      {super.key,
      required this.imageUrl,
      required this.productName,
      required this.productPrice});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            child: CustomNetworkImage(
              imageUrl: imageUrl.replaceFirst(
                'http://10.10.20.19:5007',
                'https://gmosley-uteehub-backend.onrender.com',
              ),
              height: 100.h,
              width: double.infinity,
              boxShape: BoxShape.rectangle,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  productName,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "\$${productPrice}",
                  style: TextStyle(
                      color: Colors.cyan, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
