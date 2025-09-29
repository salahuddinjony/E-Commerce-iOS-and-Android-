import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/global/helper/toast_message/toast_message.dart';
import 'package:local/app/view/common_widgets/custom_button/custom_button.dart';
import 'package:local/app/view/screens/features/vendor/orders/order_details/widgets/delivery_request_dialog.dart';
import 'package:local/app/view/screens/features/vendor/orders/order_details/widgets/two_buttons_in_row.dart';
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

      // if (order.status == 'offered' || order.status == 'pending') {
      //   return twoButtons(
      //     leftTitle: 'Approve',
      //     rightTitle: 'Reject',
      //     leftOnTap: () async {
      //       if (await controller.updateCustomOrderStatus(order.id, 'in-progress')) {
      //         toastMessage(message: 'Custom Order In Progress');
      //         context.pop();
      //       } else {
      //         toastMessage(message: 'Failed to approve order');
      //       }
      //     },
      //     rightOnTap: () async {
      //       if (await controller.updateCustomOrderStatus(order.id, 'cancelled')) {
      //         toastMessage(message: 'Custom Order Cancelled');
      //         context.pop();
      //       } else {
      //         toastMessage(message: 'Failed to cancel order');
      //       }
      //     },
      //   );
      // }
      if (order.status == 'in-progress' || order.status == 'revision' || order.status == 'accepted') {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Obx(
            () => twoButtons(
              height: 43, 
              leftTitle: 'Delivery Request',
              rightButton: false,
              isLeftLoading: controller.isAcceptLoading.value,
              isRightLoading: controller.isRejectLoading.value,
              // leftOnTap: () async {
              //   if (await controller.updateCustomOrderStatus(
              //       order.id, 'delivery-requested')) {
              //     toastMessage(message: 'Custom Order Delivery Requested');
              //     context.pop();
              //   } else {
              //     toastMessage(message: 'Failed to request delivery');
              //   }
              // },
              leftOnTap: () {
                showDialog(
                  context: context,
                  builder: (context) {        
                  return DeliveryRequestDialog(
                    orderId: order.id,
                  );
                  },
                );
              },
              // rightOnTap: () async {
              //   if (await controller.updateCustomOrderStatus(
              //       order.id, 'cancelled')) {
              //     toastMessage(message: 'Custom Order Cancelled');
              //     context.pop();
              //   } else {
              //     toastMessage(message: 'Failed to cancel order');
              //   }
              // },
            ),
          ),
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
        return twoButtons(
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
}
