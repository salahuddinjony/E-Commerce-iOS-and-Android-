import 'package:flutter/material.dart';

import '../../../utils/app_colors/app_colors.dart';
import '../custom_network_image/custom_network_image.dart';
import '../custom_text/custom_text.dart';

class OrderCard extends StatelessWidget {
  final String parcelId;
  final String date;
  final String addressLine1;
  final String deliveryType;
  final int amount;
  final String timeAgo;
  final String imageUrl;

  const OrderCard(
      {required this.parcelId,
        required this.date,
        required this.addressLine1,
        required this.deliveryType,
        required this.amount,
        required this.timeAgo,
        required this.imageUrl,
        super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile image
            CustomNetworkImage(
              imageUrl: imageUrl,
              height: 40,
              width: 40,
              boxShape: BoxShape.circle,
            ),
            const SizedBox(width: 12),
            // Order details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Parcel ID and Date row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: "Parcel ID: $parcelId",
                        fontSize: 16,
                        font: CustomFont.poppins,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                      CustomText(
                        text: "Date: $date",
                        fontSize: 13,
                        font: CustomFont.poppins,
                        fontWeight: FontWeight.w400,
                        color: AppColors.naturalGray,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(addressLine1),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CustomText(
                        text: deliveryType,
                        fontSize: 16,
                        font: CustomFont.poppins,
                        fontWeight: FontWeight.w500,
                        color: AppColors.naturalGray,
                      ),
                      const Spacer(),
                      CustomText(
                        text: amount.toString(),
                        fontSize: 16,
                        font: CustomFont.poppins,
                        fontWeight: FontWeight.w500,
                        color: AppColors.naturalGray,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Time ago badge
          ],
        ),
      ),
    );
  }
}