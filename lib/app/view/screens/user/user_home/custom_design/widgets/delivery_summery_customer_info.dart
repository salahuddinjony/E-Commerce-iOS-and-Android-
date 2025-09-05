import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';

class DeliverySummaryCustomerInfo extends StatelessWidget {
  final dynamic controller;

  const DeliverySummaryCustomerInfo({super.key, this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: AppColors.brightCyan,
              blurRadius: 1,
              offset: Offset(0, 0.5))
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // vertical accent bar
          Container(
            width: 6,
            height: 96,
            decoration: BoxDecoration(
              color: AppColors.brightCyan,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 12),

          // details column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header with edit
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Delivery To',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.2,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit'),
                      style: TextButton.styleFrom(
                        minimumSize: const Size(0, 30),
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 8),

                // name + phone as compact row
                Text(
                  (controller?.customerNameController.text ?? '').isNotEmpty
                      ? controller.customerNameController.text
                      : 'No recipient name',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),

                // address block
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: Colors.redAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        (controller?.customerAddressController.text ?? '')
                                .isNotEmpty
                            ? controller.customerAddressController.text
                            : 'No address provided',
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // chips for city/region and phone
                Row(
                  children: [
                    if ((controller?.customerRegionCityController.text ?? '')
                        .isNotEmpty)
                      Chip(
                        visualDensity: VisualDensity.compact,
                        backgroundColor:
                            AppColors.brightCyan.withValues(alpha: .12),
                        label: Text(
                          controller.customerRegionCityController.text,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    const SizedBox(width: 8),
                    if ((controller?.customerPhoneController.text ?? '')
                        .isNotEmpty)
                      Chip(
                        backgroundColor: Colors.lightBlue.withValues(alpha: .2),
                        visualDensity: VisualDensity.compact,
                        avatar: const Icon(Icons.phone, size: 16),
                        label: Text(
                          controller.customerPhoneController.text,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
