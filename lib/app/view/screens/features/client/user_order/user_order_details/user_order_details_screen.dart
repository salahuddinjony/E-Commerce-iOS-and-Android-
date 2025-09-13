import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/order_product_row.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/order_tracking_timeline.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/summary_row.dart';

class UserOrderDetailsScreen extends StatelessWidget {
  final bool isCustom;
  final dynamic orderData;
  const UserOrderDetailsScreen(
      {super.key, required this.isCustom, required this.orderData});

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

  @override
  Widget build(BuildContext context) {
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

    // determine statuses and activeIndex
    final status = orderStatus.toLowerCase();
    List<String> statuses;
    int activeIndex;
    if (status == 'offered' || status == 'pending') {
      statuses = ['Offered', 'In Progress', 'Completed'];
      activeIndex = 0;
    } else if (status == 'in-progress') {
      statuses = ['Offered', 'In Progress', 'Completed'];
      activeIndex = 1;
    } else if (status == 'cancelled' || status == 'rejected') {
      statuses = ['Offered', 'In Progress', 'Cancelled'];
      activeIndex = 2;
    } else if (status == 'completed' || status == 'delivered') {
      statuses = ['Offered', 'In Progress', 'Completed'];
      activeIndex = 2;
    } else {
      statuses = ['Offered', 'In Progress', 'Completed'];
      activeIndex = 0;
    }

    final List<String> timelineDates = List.generate(
      statuses.length,
      (i) {
        if (i == 0) return orderDate;
        if (i == 1) return updatedAt;
        return orderDeliveryDate;
      },
    );

    final bool isDisabled = status == 'cancelled' || status == 'rejected';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        appBarContent: "Order Details",
        iconData: Icons.arrow_back,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          OrderProductRow(
            imageUrl: productImage,
            orderID: orderID,
            orderStatus: orderStatus,
            isCustom: isCustom,
            orderDate: orderDate,
          ),
          const SizedBox(height: 24),
          OrderTrackingTimeline(
            statuses: statuses,
            dates: timelineDates,
            activeIndex: activeIndex,
            isDisabled: isDisabled,
          ),
          const SizedBox(height: 24),
          const Text(
            'Order Summary',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          SummaryRow(label: 'Price', value: '$orderCurrency$orderPrice'),
          SummaryRow(label: 'Quantity', value: orderQuantity),
          SummaryRow(label: 'Payment Status', value: orderPaymentStatus.safeCap()),
          SummaryRow(label: 'Delivery Option', value: deliveryOption.safeCap()),
          const Divider(),
          const SizedBox(height: 24),
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
        ]),
      ),
    );
  }
}
