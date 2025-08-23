import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';
import '../mixins/order_mixin.dart';
import '../mixins/general_order_mixin.dart';
import '../models/custom_order_response_model.dart';
import '../services/custom_order_service.dart';
import '../services/general_order_service.dart';
import '../constants/order_constants.dart';

class OrdersController extends GetxController
    with GetTickerProviderStateMixin, OrderMixin, GeneralOrderMixin {
  late TabController tabController;

  //Create instances of services
  final CustomOrderService customerOrderService = CustomOrderService();
  final GeneralOrderService generalOrderService = GeneralOrderService();

  var isCustomOrder = false.obs; // toggle state

  List<String> get generalTabs => OrderConstants.generalTabs;
  List<String> get customTabs => OrderConstants.customTabs;
  List<String> get tabs => isCustomOrder.value ? customTabs : generalTabs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);

    // Recreate TabController whenever toggle changes
    ever(isCustomOrder, (_) {
      tabController.dispose();
      tabController = TabController(length: tabs.length, vsync: this);
      update();
    });

    // Load both types of orders
    fetchAllOrders();
  }

  // Fetch all orders (both custom and general)
  Future<void> fetchAllOrders() async {
    await Future.wait([
      fetchCustomOrders(),
      fetchGeneralOrders(),
    ]);
  }

  // Fetch custom orders from API
  Future<void> fetchCustomOrders() async {
    try {
      isLoading.value = true;
      isError.value = false;

      final response = await customerOrderService.fetchVendorOrders();
      processOrderResponse(response);
    } catch (e) {
      isLoading.value = false;
      isError.value = true;
      errorMessage.value = e.toString();
    }
  }

  // Fetch general orders from API
  Future<void> fetchGeneralOrders() async {
    try {
      isGeneralOrdersLoading.value = true;
      isGeneralOrdersError.value = false;

      final response = await generalOrderService.fetchGeneralOrders();
      processGeneralOrderResponse(response);
    } catch (e) {
      isGeneralOrdersLoading.value = false;
      isGeneralOrdersError.value = true;
      generalOrdersErrorMessage.value = e.toString();
    }
  }

  // Fetch orders by type
  Future<void> fetchOrdersByType(bool isCustom) async {
    if (isCustom) {
      await fetchCustomOrders();
    } else {
      await fetchGeneralOrders();
    }
  }

  // Update custom order status
  Future<bool> updateCustomOrderStatus(String orderId, String status) async {
    try {
      print('Updating custom order status: $orderId to $status');
      final result = await customerOrderService.updateOrderStatus(orderId, status);
      // Refresh custom orders after status update
       refreshOrdersByType(true);
      return result;

    } catch (e) {
      print('Failed to update custom order status: $e');
      return false; 
    }
  }

  // Update general order status
  Future<void> updateGeneralOrderStatus(String orderId, String status) async {
    try {
      await generalOrderService.updateGeneralOrderStatus(orderId, status);
      // Refresh general orders after status update
      await fetchGeneralOrders();
      Get.snackbar(
        'Success',
        'General order status updated successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update general order status: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  // Delete general order
  Future<bool> deleteGeneralOrder(String orderId) async {
    try {
      final ok = await generalOrderService.deleteGeneralOrder(orderId);
      if (!ok) return false;

      // Fetch fresh list only after confirmed deletion
      await fetchGeneralOrders();
     
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete general order: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
  }

  // Accept custom order
  Future<void> acceptCustomOrder(String orderId) async {
    await updateCustomOrderStatus(orderId, OrderConstants.statusAccepted);
  }

  // Reject custom order
  Future<void> rejectCustomOrder(String orderId) async {
    await updateCustomOrderStatus(orderId, OrderConstants.statusRejected);
  }

  // Mark custom order as in progress
  Future<void> markCustomOrderInProgress(String orderId) async {
    await updateCustomOrderStatus(orderId, OrderConstants.statusInProgress);
  }

  // Mark custom order as completed
  Future<void> markCustomOrderCompleted(String orderId) async {
    await updateCustomOrderStatus(orderId, OrderConstants.statusCompleted);
  }

  // Accept general order
  Future<void> acceptGeneralOrder(String orderId) async {
    await updateGeneralOrderStatus(orderId, OrderConstants.statusAccepted);
  }

  // Reject general order
  Future<void> rejectGeneralOrder(String orderId) async {
    await updateGeneralOrderStatus(orderId, OrderConstants.statusRejected);
  }

  // Mark general order as in progress
  Future<void> markGeneralOrderInProgress(String orderId) async {
    await updateGeneralOrderStatus(orderId, OrderConstants.statusInProgress);
  }

  // Mark general order as completed
  Future<void> markGeneralOrderCompleted(String orderId) async {
    await updateGeneralOrderStatus(orderId, OrderConstants.statusCompleted);
  }

  // Mark general order as delivered
  Future<void> markGeneralOrderDelivered(String orderId) async {
    await updateGeneralOrderStatus(
        orderId, OrderConstants.statusDeliveryConfirmed);
  }

  void onPendingOrderTap(BuildContext context) {
    context.pushNamed(RoutePath.pendingDetailsScreen);
  }

  // Navigate to order details for custom orders
  void onOrderTap<T>(BuildContext context, T order) {
    context.pushNamed(
      RoutePath.pendingDetailsScreen,
      extra: {
        'orderData': order,
        'isCustomOrder': T == Order ? true : false,
      },
    );
  }

  // Countdown stream for order delivery
  Stream<String> countdownStream(
      DateTime orderTime, DateTime deliveryTime) async* {
    while (true) {
      final now = DateTime.now();

      if (now.isAfter(deliveryTime)) {
        yield "Expired";
        break; // stop the stream when delivered
      } else if (now.isBefore(orderTime)) {
        yield "Not started";
      } else {
        final remaining = deliveryTime.difference(now);
        final days = remaining.inDays;
        final hours = remaining.inHours % 24;
        final minutes = remaining.inMinutes % 60;
        final seconds = remaining.inSeconds % 60;

        yield "${days == 0 ? '' : '${days.toString().padLeft(2, '0')} days '}"
          "${hours.toString().padLeft(2, '0')} hours "
          "${minutes.toString().padLeft(2, '0')} minutes "
          "${seconds.toString().padLeft(2, '0')} seconds";
      }

      await Future.delayed(const Duration(seconds: 1));
    }
  }

  // Refresh all orders
  void refreshOrders() {
    fetchAllOrders();
  }

  // Refresh orders by type
  void refreshOrdersByType(bool isCustom) {
    if (isCustom) {
      fetchCustomOrders();
    } else {
      fetchGeneralOrders();
    }
  }

  // Get combined loading state
  bool get isAnyLoading => isLoading.value || isGeneralOrdersLoading.value;

  // Get combined error state
  bool get isAnyError => isError.value || isGeneralOrdersError.value;

  // Get combined error message
  String get combinedErrorMessage {
    if (isError.value) return errorMessage.value;
    if (isGeneralOrdersError.value) return generalOrdersErrorMessage.value;
    return '';
  }
}
