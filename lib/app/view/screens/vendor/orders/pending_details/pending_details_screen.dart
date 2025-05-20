import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';

class PendingDetailsScreen extends StatelessWidget {
  const PendingDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Order Details'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNetworkImage(
                    imageUrl: AppConstants.teeShirt, height: 127, width: 119),
                const SizedBox(width: 16),
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Guitar Soul Tee',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const Text(
                        'Supreme Soft Cotton',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          children: [
                            const TextSpan(text: 'These '),
                            TextSpan(
                              text: 'T-shirts',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            const TextSpan(
                              text:
                                  ' are dominating the fashion scene with their unique designs and top-quality fabric. Pick your favorite now!',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '\$20.22',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Order Details Section
            const Text(
              'Order Details',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            const OrderDetailRow(label: 'Order ID', value: '#123456'),
            const OrderDetailRow(label: 'Customer', value: 'John Doe'),
            const OrderDetailRow(label: 'Payment', value: 'Cash on Delivery'),
            const SizedBox(height: 20),

            // Date & Price Row
            Container(
              color: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('March: 25, 12:50 PM',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  Text('\$20', style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Delivery Route Section
            const Text(
              'Delivery Route',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            const DeliveryRouteItem(
              iconData: Icons.location_on_outlined,
              label: 'Pickup',
              value: 'U Tee Hub Store',
            ),
            const DeliveryRouteItem(
              iconData: Icons.location_on_outlined,
              label: 'Drop-off',
              value: '123 Main Street, NY',
            ),
            SizedBox(
              height: 50.h,
            ),

            Row(
              children: [
                Expanded(
                  flex: 5,
                  child: CustomButton(
                    onTap: () {
                      toastMessage(message: 'This Product is Approved');
                      context.pop();
                    },
                    title: "Approved",
                    isRadius: true,
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  flex: 5,
                  child: CustomButton(
                    fillColor: Colors.red,
                    onTap: () {
                      toastMessage(message: 'This Product is Rejected');
                      context.pop();
                    },
                    title: "Rejected",
                    isRadius: true,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class OrderDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const OrderDetailRow({required this.label, required this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text('$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              )),
          Text(value),
        ],
      ),
    );
  }
}

class DeliveryRouteItem extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String value;

  const DeliveryRouteItem({
    required this.iconData,
    required this.label,
    required this.value,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Colors.blue.shade300;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(iconData, color: color),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(color: color)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
