import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/common_widgets/custom_network_image/custom_network_image.dart';
import 'package:local/app/global/helper/extension/extension.dart';

class UserOrderDetailsScreen extends StatelessWidget {
  final bool isCustom;
  final dynamic orderData;
  const UserOrderDetailsScreen(
      {super.key, required this.isCustom, required this.orderData});

  @override
  Widget build(BuildContext context) {
    String safeFirstDesignImage(dynamic data) {
      try {
        final files = data?.designFiles;
        if (files is List && files.isNotEmpty && files.first != null) {
          return files.first.toString();
        }
      } catch (_) {}
      return AppConstants.demoImage;
    }

    String safeFormatDate(dynamic value) {
      if (value == null) return '';
      try {
        final dynamic result = (value as dynamic).formatDate();
        if (result != null) return result.toString();
      } catch (_) {}
      if (value is DateTime) {
        return '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
      }
      return value.toString();
    }

    final String productImage =
        isCustom ? safeFirstDesignImage(orderData) : AppConstants.demoImage;
    final String orderID =
        (isCustom ? orderData?.orderId : orderData?.id)?.toString() ?? '';
    final String orderStatus =
        (isCustom ? orderData?.status : orderData?.orderStatus)?.toString() ??
            '';
    final String orderPrice =
        (isCustom ? orderData?.price : orderData?.price)?.toString() ?? '';
    final String orderCurrency =
        (isCustom ? orderData?.currency : orderData?.currency)?.toString() ??
            '';
    final String orderQuantity =
        (isCustom ? orderData?.quantity : orderData?.quantity)?.toString() ??
            '';

    // Use safeFormatDate instead of calling formatDate() directly
    final String orderDate =
        safeFormatDate(isCustom ? orderData?.createdAt : orderData?.createdAt);
    final String updatedAt =
        safeFormatDate(isCustom ? orderData?.updatedAt : orderData?.updatedAt);
    final String orderDeliveryDate =
        isCustom ? safeFormatDate(orderData?.deliveryDate) : '';

    final String orderPaymentStatus =
        (isCustom ? orderData?.paymentStatus : orderData?.paymentStatus)
                ?.toString() ??
            '';
    final String deliveryOption =
        (isCustom ? orderData?.deliveryOption : orderData?.deliveryOption)
                ?.toString() ??
            '';
    final String shippingAddress =
        (isCustom ? orderData?.shippingAddress : orderData?.shippingAddress)
                ?.toString() ??
            '';
    final String summery =
        isCustom ? (orderData?.summery?.toString() ?? '') : '';

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
            // Product row (uses parsed fields)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomNetworkImage(
                  imageUrl: productImage,
                  height: 100,
                  width: 100,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#$orderID',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                            const TextSpan(text: 'Status : '),
                            TextSpan(
                              text: orderStatus.capitalizeFirstWord(),
                              style: TextStyle(
                                color: orderStatus.toLowerCase() == 'delivered'
                                    ? Colors.green
                                    : (orderStatus.toLowerCase() == 'cancelled'
                                        ? Colors.red
                                        : Colors.orange),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                            const TextSpan(text: 'Order Type : '),
                            TextSpan(
                              text: isCustom ? 'Custom Order' : 'General Order',
                              style: TextStyle(
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Placed on: $orderDate',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Order Status Timeline with dynamic Stack-based tracker
            // Determine statuses and activeIndex dynamically based on orderStatus
            Builder(
              builder: (context) {
                // Normalize status for matching
                final status = orderStatus.toLowerCase();
                List<String> statuses;
                int activeIndex;

                if (status == 'offered' || status == 'pending') {
                  statuses = ['Offered', 'In Progress', 'Completed'];
                  activeIndex = 0;
                } else if (status == 'in-progress') {
                  statuses = ['Offered', 'In Progress', 'Completed'];
                  // In-progress should map to the middle node (index 1)
                  activeIndex = 1;
                } else if (status == 'cancelled' || status == 'rejected') {
                  statuses = ['Offered', 'In Progress', 'Cancelled'];
                  activeIndex = 2;
                } else if (status == 'completed' || status == 'delivered') {
                  statuses = ['Offered', 'In Progress', 'Completed'];
                  // Completed/delivered is the last node (index 2)
                  activeIndex = 2;
                } else {
                  // fallback
                  statuses = ['Offered', 'In Progress', 'Completed'];
                  activeIndex = 0;
                }

                // Build dates list to match statuses length (safe mapping)
                final List<String> timelineDates = List.generate(
                  statuses.length,
                  (i) {
                    if (i == 0) return orderDate;
                    if (i == 1) return updatedAt;
                    return orderDeliveryDate;
                  },
                );

                // if cancelled/rejected -> visually disable the track
                final bool isDisabled =
                    status == 'cancelled' || status == 'rejected';

                return OrderTrackingTimeline(
                  statuses: statuses,
                  dates: timelineDates,
                  activeIndex: activeIndex,
                  isDisabled: isDisabled,
                );
              },
            ),

            const SizedBox(height: 24),

            // Order Summary
            const Text(
              'Order Summary',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            SummaryRow(label: 'Price', value: '$orderCurrency$orderPrice'),
            SummaryRow(label: 'Quantity', value: orderQuantity),
            SummaryRow(
                label: 'Payment Status', value: orderPaymentStatus.safeCap()),
            SummaryRow(
                label: 'Delivery Option', value: deliveryOption.safeCap()),
            const Divider(),
            // SummaryRow(
            //   label: 'Total',
            //   value: priceText,
            //   isBold: true,
            // ),

            const SizedBox(height: 24),

            // Delivery Address
            const Text(
              'Delivery',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(shippingAddress.toString()),
            Text(summery.toString()),
            const SizedBox(height: 12),

            const SizedBox(height: 8),
            Text(summery.toString()),
            const SizedBox(height: 24),
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
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
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
  final bool isDisabled; // new

  const OrderTrackingTimeline({
    super.key,
    required this.statuses,
    this.dates,
    required this.activeIndex,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    // Sizes for concentric rings
    const double outerSize = 48; // outermost ring diameter
    const double midSize = 48; // middle ring diameter
    const double innerSize = 35; // inner filled circle diameter
    const double lineHeight = 2.5;

    // Node layout
    const double nodeWidth = 120.0;
    const double connectorWidth = 56.0;

    return SizedBox(
      height: outerSize + 55,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final count = statuses.length;
            final step = nodeWidth + connectorWidth;
            final contentWidth =
                (count * nodeWidth) + ((count - 1) * connectorWidth);

            // clamp active index into valid range
            final effectiveActive = activeIndex.clamp(0, count - 1);

            // active color toggles to grey when disabled
            final Color activeColor =
                isDisabled ? Colors.grey : AppColors.brightCyan;

            // Compute active overlay width so the active track stops at the LEFT edge
            // of the active node circle (avoids crossing the circle).
            // overlay is positioned starting at x = nodeWidth/2, so desired width is:
            // (center_of_active_node - outerSize/2) - (nodeWidth/2) == effectiveActive*step - outerSize/2
            final double rawOverlay = (effectiveActive * step) - (outerSize / 2);
            final double maxOverlay = (contentWidth - nodeWidth / 2);
            final double activeOverlayWidth = rawOverlay <= 0
                ? 0.0
                : rawOverlay.clamp(0.0, maxOverlay);

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
                    child:
                        Container(height: lineHeight, color: Colors.grey[300]),
                  ),

                  // active connector overlay behind nodes (grey when disabled)
                  Positioned(
                    left: nodeWidth / 2,
                    top: outerSize / 2 - lineHeight / 2,
                    width: activeOverlayWidth,
                    child:
                        Container(height: lineHeight, color: activeColor),
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
                                // (inline) check if this status is a cancelled node
                                // using an inline expression instead of a variable declaration
                                // so we don't place statements inside the widget list.

                                // outer ring
                                Container(
                                  width: outerSize,
                                  height: outerSize,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                      color: i <= effectiveActive
                                          ? (statuses[i].toLowerCase().contains('cancel') ? Colors.red : activeColor)
                                              .withOpacity(0.6)
                                          : Colors.grey.shade300,
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
                                    color: i <= effectiveActive
                                        ? (statuses[i].toLowerCase().contains('cancel')
                                            ? Colors.red.withOpacity(0.12)
                                            : activeColor.withOpacity(0.12))
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: i <= effectiveActive
                                          ? (statuses[i].toLowerCase().contains('cancel') ? Colors.red : activeColor)
                                              .withOpacity(0.35)
                                          : Colors.transparent,
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
                                    color: i <= effectiveActive
                                        ? (statuses[i].toLowerCase().contains('cancel') ? Colors.red : activeColor)
                                        : Colors.white,
                                    border: Border.all(
                                      color: i <= effectiveActive
                                          ? (statuses[i].toLowerCase().contains('cancel') ? Colors.red : activeColor)
                                              .withOpacity(0.9)
                                          : Colors.grey.shade300,
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Center(
                                    child: i <= effectiveActive
                                        ? (statuses[i].toLowerCase().contains('cancel')
                                            ? const Icon(Icons.close, size: 16, color: Colors.white)
                                            : const Icon(Icons.check, size: 16, color: Colors.white))
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
                                      color: i <= effectiveActive
                                          ? (statuses[i].toLowerCase().contains('cancel') ? Colors.red : activeColor)
                                          : Colors.grey,
                                      fontWeight: i == effectiveActive
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // optional date below status
                                  if (dates != null && dates!.length > i)
                                    Text(
                                      dates![i],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 11, color: Colors.grey),
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
          },
        ),
      ),
    );
  }
}
