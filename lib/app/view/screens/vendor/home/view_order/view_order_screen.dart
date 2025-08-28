import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:local/app/core/route_path.dart';
import 'package:local/app/global/helper/extension/extension.dart';
import 'package:local/app/utils/app_colors/app_colors.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import 'package:local/app/view/common_widgets/custom_appbar/custom_appbar.dart';
import 'package:local/app/view/screens/vendor/orders/constants/order_constants.dart';
import 'package:local/app/view/screens/vendor/orders/models/custom_order_response_model.dart';

import '../../../../common_widgets/order_card/order_card.dart';

class ViewOrderScreen extends StatelessWidget {
  final String status;
  final List<Order> orderData;
  const ViewOrderScreen(
      {super.key, required this.status, required this.orderData});

  List<Order> get filteredOrders {
    switch (status) {
      case 'pendingOrder':
        return orderData
            .where((o) =>
                o.status.toLowerCase() == 'pending' ||
                o.status.toLowerCase() == 'offered')
            .toList();
      case 'inProgressOrder':
        return orderData
            .where((o) => o.status.toLowerCase() == 'in-progress')
            .toList();
      default:
        return orderData;
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = filteredOrders;
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        appBarContent: "Total Orders(${filteredOrders.length})",
        iconData: Icons.arrow_back,
      ),
      body: list.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 56.r,
                    color: AppColors.darkNaturalGray,
                  ),
                  12.verticalSpace,
                  Text(
                    'No orders found for $status',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.darkNaturalGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 10.w),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final o = list[index];
                return OrderCard(
                  parcelId: '#${o.id}',
                  date: o.createdAt.toIso8601String().getDateTime(),
                  addressLine1: o.shippingAddress,
                  deliveryType: o.status.capitalizeFirstWord(),
                  amount: o.price.toDouble(),
                  timeAgo: '',
                  color: Color(OrderConstants.getStatusColor(o.status)),
                  imageUrl: AppConstants.demoImage,
                  onTap: () {
                    context.pushNamed(RoutePath.viewOrderDetails, extra: {'order': o});
                  },
                );
              },
            ),
    );
  }
}
