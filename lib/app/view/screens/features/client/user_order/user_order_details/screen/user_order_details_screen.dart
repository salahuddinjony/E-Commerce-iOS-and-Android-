import 'package:flutter/material.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/view/screens/features/client/user_order/controller/user_order_controller.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/order_product_row.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/order_tracking_timeline.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/summary_row.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/order_action_card.dart';
import 'package:local/app/view/screens/features/client/user_order/user_order_details/widgets/order_status_card.dart';

class UserOrderDetailsScreen extends StatelessWidget {
  final bool isCustom;
  final dynamic orderData;
  final UserOrderController controller;
  const UserOrderDetailsScreen(
      {super.key,
      required this.isCustom,
      required this.orderData,
      required this.controller});

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

    if (value is DateTime) {
      return value.formatDate();
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
        (isCustom ? orderData?.status : orderData?.status)?.toString() ??
            '';
    final String orderPrice =
        (isCustom ? orderData?.price : orderData?.price)?.toString() ?? '';
    final String orderCurrency =
        (isCustom ? orderData?.currency : orderData?.currency)?.toString() ??
            '';
    final String orderQuantity =
        (isCustom ? orderData?.quantity : orderData?.totalQuantity)?.toString() ??
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
        (isCustom ? orderData?.deliveryOption : '')
                ?.toString() ??
            '';
    final String shippingAddress =
        (isCustom ? orderData?.shippingAddress : orderData?.shippingAddress)
                ?.toString() ??
            '';
    final String summery =
        isCustom ? (orderData?.summery?.toString() ?? '') : '';

    // determine statuses and activeIndex based on order type
    final status = orderStatus.toLowerCase();
    List<String> statuses;
    int activeIndex;
    List<String> timelineDates;

    if (isCustom) {
      // Custom order timeline: Offered/Pending -> Accepted -> Delivery Request -> Confirm Delivery (with optional Revision)
      if (status == 'revision') {
        statuses = ['Offered', 'Accepted', 'Delivery Request', 'Revision', 'Confirm Delivery'];
        activeIndex = 3;
        timelineDates = [orderDate, updatedAt, updatedAt, updatedAt, ''];
      } else if (status == 'cancelled' || status == 'rejected') {
        statuses = ['Offered', 'Cancelled'];
        activeIndex = 1;
        timelineDates = [orderDate, updatedAt];
      } else {
        statuses = ['Offered', 'Accepted', 'Delivery Request', 'Confirm Delivery'];
        if (status == 'offered' || status == 'pending') {
          activeIndex = 0;
          timelineDates = [orderDate, '', '', ''];
        } else if (status == 'accepted') {
          activeIndex = 1;
          timelineDates = [orderDate, updatedAt, '', ''];
        } else if (status == 'delivery-requested') {
          activeIndex = 2;
          timelineDates = [orderDate, updatedAt, updatedAt, ''];
        } else if (status == 'delivery-confirmed' || status == 'completed') {
          activeIndex = 3;
          timelineDates = [orderDate, updatedAt, updatedAt, orderDeliveryDate.isNotEmpty ? orderDeliveryDate : updatedAt];
        } else {
          activeIndex = 0;
          timelineDates = [orderDate, '', '', ''];
        }
      }
    } else {
      // Non-custom order timeline: Offered/Pending -> In Progress -> Delivery
      if (status == 'cancelled' || status == 'rejected') {
        statuses = ['Offered', 'In Progress', 'Cancelled'];
        activeIndex = 2;
        timelineDates = [orderDate, updatedAt, updatedAt];
      } else {
        statuses = ['Offered', 'In Progress', status == 'completed' || status == 'delivered' ? 'Delivered' : 'Delivery'];
        if (status == 'offered' || status == 'pending') {
          activeIndex = 0;
          timelineDates = [orderDate, '', ''];
        } else if (status == 'in-progress') {
          activeIndex = 1;
          timelineDates = [orderDate, updatedAt, ''];
        } else if (status == 'completed' || status == 'delivered') {
          activeIndex = 2;
          timelineDates = [orderDate, updatedAt, orderDeliveryDate.isNotEmpty ? orderDeliveryDate : updatedAt];
        } else {
          activeIndex = 0;
          timelineDates = [orderDate, '', ''];
        }
      }
    }

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
            designFiles: isCustom ? orderData?.designFiles : null,
          ),
          const SizedBox(height: 24),
          OrderTrackingTimeline(
            statuses: statuses,
            dates: timelineDates,
            activeIndex: activeIndex,
            isDisabled: isDisabled,
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${isCustom ? 'Offer' : 'Order'} Summary',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                SummaryRow(label: 'Price', value: '$orderCurrency$orderPrice'),
                SummaryRow(
                    label: 'Quantities', value: orderQuantity.padLeft(2, '0')),
                SummaryRow(
                    label: 'Payment Status',
                    value: orderPaymentStatus.safeCap()),
                SummaryRow(
                    label: 'Delivery Option', value: deliveryOption.safeCap()),
                // const Divider(),
                const SizedBox(height: 24),
                const Text(
                  'Delivery',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Text(shippingAddress.toString()),
                const SizedBox(height: 24),
                const Text(
                  'Additional Notes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(summery.toString()),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Action card for different order statuses
          if (isCustom)
            OrderActionCard(
              status: orderStatus,
              orderData: orderData,
              controller: controller,
              orderPrice: orderPrice,
              isCustom: isCustom,
            ),
          
          // Show status card for all statuses except those with action cards
          if (isCustom)
            OrderStatusCard(
              status: orderStatus,
              time: orderData.updatedAt.toString(),
            ),
        ]),
      ),
    );
  }
}
