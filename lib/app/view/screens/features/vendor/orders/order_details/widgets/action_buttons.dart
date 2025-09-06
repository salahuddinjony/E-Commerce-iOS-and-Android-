import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import '../../models/custom_order_response_model.dart';
import '../../models/general_order_response_model.dart';
import '../../controller/order_controller.dart';

class ActionButtons extends StatelessWidget {
  final bool isCustomOrder;
  final dynamic orderData;
  final OrdersController controller;

  const ActionButtons({
    super.key,
    required this.isCustomOrder,
    required this.orderData,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    if (isCustomOrder) {
      final order = orderData as Order;

      if (order.status == 'offered' || order.status == 'pending') {
        return _twoButtons(
          leftTitle: 'Approve',
          rightTitle: 'Reject',
          leftOnTap: () async {
            if (await controller.updateCustomOrderStatus(order.id, 'in-progress')) {
              toastMessage(message: 'Custom Order In Progress');
              context.pop();
            } else {
              toastMessage(message: 'Failed to approve order');
            }
          },
          rightOnTap: () async {
            if (await controller.updateCustomOrderStatus(order.id, 'cancelled')) {
              toastMessage(message: 'Custom Order Cancelled');
              context.pop();
            } else {
              toastMessage(message: 'Failed to cancel order');
            }
          },
        );
      } else if (order.status == 'in-progress') {
        return _twoButtons(
          leftTitle: 'Complete',
          rightTitle: 'Reject',
          leftOnTap: () async {
            if (await controller.updateCustomOrderStatus(order.id, 'completed')) {
              toastMessage(message: 'Custom Order Completed');
              context.pop();
            } else {
              toastMessage(message: 'Failed to complete order');
            }
          },
          rightOnTap: () async {
            if (await controller.updateCustomOrderStatus(order.id, 'cancelled')) {
              toastMessage(message: 'Custom Order Cancelled');
              context.pop();
            } else {
              toastMessage(message: 'Failed to cancel order');
            }
          },
        );
      }
      return CustomButton(
        onTap: () => context.pop(),
        title: 'Back',
        isRadius: true,
      );
    } else {
      final order = orderData as GeneralOrder;
      if (order.status == 'offered' || order.status == 'pending') {
        return _twoButtons(
          leftTitle: 'Approve',
          rightTitle: 'Reject',
          leftOnTap: () {
            toastMessage(message: 'General Order Approved');
            context.pop();
          },
          rightOnTap: () async {
            if (await controller.deleteGeneralOrder(order.id)) {
              toastMessage(message: 'General Order Deleted');
              context.pop();
            } else {
              toastMessage(message: 'Failed to delete order');
            }
          },
        );
      }
      return CustomButton(
        onTap: () => context.pop(),
        title: 'Back',
        isRadius: true,
      );
    }
  }

  Widget _twoButtons({
    required String leftTitle,
    required String rightTitle,
    required VoidCallback leftOnTap,
    required VoidCallback rightOnTap,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: CustomButton(
            onTap: leftOnTap,
            title: leftTitle,
            isRadius: true,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          flex: 5,
          child: CustomButton(
            fillColor: Colors.red,
            onTap: rightOnTap,
            title: rightTitle,
            isRadius: true,
          ),
        ),
      ],
    );
  }
}