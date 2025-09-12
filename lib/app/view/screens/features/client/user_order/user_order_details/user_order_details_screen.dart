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
      body: SingleChildScrollView(
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

            // Order Status Timeline with dynamic Stack-based tracker
            OrderTrackingTimeline(
              statuses: const [
                'Order Placed',
                'Processing',
                'Completed',
              ],
              dates: const [
                'Wed, 11 Jan',
                'Thu, 12 Jan',
                'Fri, 13 Jan',
              ],
              activeIndex: 1, // change dynamically
            ),

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
            width: 90,
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

// Dynamic, Stack-based order tracking timeline that matches the requested design.
class OrderTrackingTimeline extends StatelessWidget {
  final List<String> statuses;
  final List<String>? dates;
  final int activeIndex;

  const OrderTrackingTimeline({
    super.key,
    required this.statuses,
    this.dates,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    // Sizes for concentric rings
    const double outerSize = 66; // outermost ring diameter
    const double midSize = 48; // middle ring diameter
    const double innerSize = 35; // inner filled circle diameter
    const double lineHeight = 3;

    // Node layout
    const double nodeWidth = 120.0;
    const double connectorWidth = 56.0;

    return SizedBox(
      height: outerSize + 55,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: LayoutBuilder(builder: (context, constraints) {
          final count = statuses.length;
          final step = nodeWidth + connectorWidth;
          final contentWidth = (count * nodeWidth) + ((count - 1) * connectorWidth);

          // active overlay width: up to center of active node
          final activeOverlayWidth = (activeIndex * step) + (nodeWidth / 2);

          return SizedBox(
            width: contentWidth,
            height: outerSize + 40,
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                // base grey connector full width, starts at center of first node
                Positioned(
                  left: nodeWidth / 2,
                  right: nodeWidth / 2,
                  top: outerSize / 2 - lineHeight / 2,
                  child: Container(height: lineHeight, color: Colors.grey[300]),
                ),

                // active connector overlay behind nodes
                Positioned(
                  left: nodeWidth / 2,
                  top: outerSize / 2 - lineHeight / 2,
                  width: activeOverlayWidth.clamp(0.0, contentWidth),
                  child: Container(height: lineHeight, color: AppColors.brightCyan),
                ),

                // nodes (drawn on top of the connector)
                for (int i = 0; i < count; i++)
                  Positioned(
                    left: i * step,
                    top: 0,
                    child: SizedBox(
                      width: nodeWidth,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              // outer ring
                              Container(
                                width: outerSize,
                                height: outerSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(
                                    color: i <= activeIndex ? AppColors.brightCyan.withOpacity(0.5) : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                              ),
                              // middle ring
                              Container(
                                width: midSize,
                                height: midSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i <= activeIndex ? AppColors.brightCyan.withOpacity(0.15) : Colors.transparent,
                                  border: Border.all(
                                    color: i <= activeIndex ? AppColors.brightCyan.withOpacity(0.35) : Colors.transparent,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              // inner filled circle or dot
                              Container(
                                width: innerSize,
                                height: innerSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: i <= activeIndex ? AppColors.brightCyan : Colors.white,
                                  border: Border.all(
                                    color: i <= activeIndex ? AppColors.brightCyan.withOpacity(0.9) : Colors.grey.shade300,
                                    width: 1.2,
                                  ),
                                ),
                                child: Center(
                                  child: i <= activeIndex
                                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                                      : Container(
                                          width: 6,
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[400],
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: nodeWidth,
                            child: Column(
                              children: [
                                Text(
                                  statuses[i],
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  style: TextStyle(
                                    color: i <= activeIndex ? AppColors.brightCyan : Colors.grey,
                                    fontWeight: i == activeIndex ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // optional date below status
                                if (dates != null && dates!.length > i)
                                  Text(
                                    dates![i],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
