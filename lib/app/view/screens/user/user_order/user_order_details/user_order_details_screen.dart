import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';

class UserOrderDetailsScreen extends StatelessWidget {
  const UserOrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "Order Details",
        iconData: Icons.arrow_back,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(
                        AppConstants
                            .teeShirt, // Replace with your product image URL or use AssetImage
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black),
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
                                    ' are dominating the fashion scene with their unique designs and top-quality fabric. Pick your favorite now!'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Price: \$24',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'QTY: 1',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Order Status Timeline with horizontal scroll and flexible lines
            const OrderStatusTimeline(),

            const SizedBox(height: 24),

            // Order Summary
            const Text(
              'Order Summary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const SummaryRow(label: 'Discount', value: '\$2'),
            const SummaryRow(label: 'Discount (50%)', value: '- \$0.214'),
            const SummaryRow(label: 'Delivery', value: '\$4.00'),
            const SummaryRow(label: 'Tax', value: '+ \$18.88'),
            const Divider(),
            const SummaryRow(
              label: 'Total',
              value: '\$24.00',
              isBold: true,
            ),

            const SizedBox(height: 24),

            // Delivery Address
            const Text(
              'Delivery',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text('Address'),
            const Text('847 Jewess Bridge Apt. 174 , UK'),
            const Text('474-769-3919'),
          ],
        ),
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = isBold
        ? const TextStyle(fontWeight: FontWeight.bold)
        : const TextStyle();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}

class OrderStatusTimeline extends StatelessWidget {
  const OrderStatusTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    const double circleSize = 16;

    Widget statusCircle(Color color, {bool isFilled = true}) {
      return Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isFilled ? color : Colors.grey[300],
          border: Border.all(color: Colors.grey),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Confirmed
          Column(
            children: [
              statusCircle(Colors.blue),
              const SizedBox(height: 4),
              const Text(
                'Order Confirmed',
                style: TextStyle(fontSize: 12),
              ),
              const Text(
                'Wed, 11th Jan',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),

          // Flexible blue line
          const SizedBox(width: 4),
          SizedBox(
            height: 2,
            width: 80,
            child: Container(color: AppColors.brightCyan),
          ),
          const SizedBox(width: 4),

          // Out For Delivery
          Column(
            children: [
              statusCircle(Colors.blue),
              const SizedBox(height: 4),
              const Text(
                'Out For Delivery',
                style: TextStyle(fontSize: 12),
              ),
              const Text(
                'Wed, 11th Jan',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),

          // Flexible grey line
          const SizedBox(width: 4),
          SizedBox(
            height: 2,
            width: 80,
            child: Container(color: AppColors.brightCyan),
          ),
          const SizedBox(width: 4),

          // Delivered
          Column(
            children: [
              statusCircle(Colors.grey, isFilled: false),
              const SizedBox(height: 4),
              const Text(
                'Delivered',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Text(
                'Expected by, Wed, 11th Jan',
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
