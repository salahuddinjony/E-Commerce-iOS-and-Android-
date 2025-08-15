import 'package:get/get.dart';
import '../models/custom_order_response_model.dart';
import '../constants/order_constants.dart';

mixin CustomOrderMixin on GetxController {
  // Observable variables
  final RxList<Order> allOrders = <Order>[].obs;
  final RxList<Order> customOrders = <Order>[].obs;
  final RxList<Order> generalOrders = <Order>[].obs;
  
  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;

  // Filtered orders by status
  List<Order> getOrdersByStatus(String status) {
    return allOrders.where((order) => order.status == status).toList();
  }

  // Get custom orders by status
  List<Order> getCustomOrdersByStatus(String status) {
    return customOrders.where((order) => order.status == status).toList();
  }

  // Get general orders by status
  List<Order> getGeneralOrdersByStatus(String status) {
    return generalOrders.where((order) => order.status == status).toList();
  }

  // Filter orders by type (custom or general)
  List<Order> getOrdersByType(bool isCustom) {
    return allOrders.where((order) => order.isCustom == isCustom).toList();
  }

  // Get orders for specific tab
  List<Order> getOrdersForTab(String tab, bool isCustomOrder) {
    if (isCustomOrder) {
      return getCustomOrdersForTab(tab);
    } else {
      return getGeneralOrdersForTab(tab);
    }
  }

  // Get custom orders for specific tab
  List<Order> getCustomOrdersForTab(String tab) {
    switch (tab) {
      case 'Pending':
        return customOrders.where((order) => 
          OrderConstants.isPendingStatus(order.status)
        ).toList();
      case 'In Progress':
        return customOrders.where((order) => 
          OrderConstants.isInProgressStatus(order.status)
        ).toList();
      case 'Completed':
        return customOrders.where((order) => 
          OrderConstants.isCompletedStatus(order.status)
        ).toList();
      case 'Cancelled':
        return customOrders.where((order) => 
          OrderConstants.isCancelledStatus(order.status)
        ).toList();
      default:
        return [];
    }
  }

  // Get general orders for specific tab
  List<Order> getGeneralOrdersForTab(String tab) {
    switch (tab) {
      case 'All Orders':
        return generalOrders;
      case 'Pending':
        return generalOrders.where((order) => 
          OrderConstants.isPendingStatus(order.status)
        ).toList();
      case 'Completed':
        return generalOrders.where((order) => 
          OrderConstants.isCompletedStatus(order.status)
        ).toList();
      case 'Rejected':
        return generalOrders.where((order) => 
          OrderConstants.isCancelledStatus(order.status)
        ).toList();
      default:
        return [];
    }
  }

  // Process API response
  void processOrderResponse(CustomOrderResponseModel response) {
    try {
      allOrders.assignAll(response.data.data);
      
      // Separate custom and general orders
      customOrders.assignAll(
        response.data.data.where((order) => order.isCustom).toList()
      );
      
      generalOrders.assignAll(
        response.data.data.where((order) => !order.isCustom).toList()
      );
      
      isLoading.value = false;
      isError.value = false;
    } catch (e) {
      isLoading.value = false;
      isError.value = true;
      errorMessage.value = 'Error processing orders: $e';
    }
  }

  // Get status display text
  String getStatusDisplayText(String status) {
    return OrderConstants.getStatusDisplayText(status);
  }

  // Get status color
  int getStatusColor(String status) {
    return OrderConstants.getStatusColor(status);
  }

  // Get payment status display text
  String getPaymentStatusDisplayText(String paymentStatus) {
    return OrderConstants.getPaymentStatusDisplayText(paymentStatus);
  }

  // Get payment status color
  int getPaymentStatusColor(String paymentStatus) {
    return OrderConstants.getPaymentStatusColor(paymentStatus);
  }

  // Clear all data
  void clearOrders() {
    allOrders.clear();
    customOrders.clear();
    generalOrders.clear();
    isLoading.value = false;
    isError.value = false;
    errorMessage.value = '';
  }
} 