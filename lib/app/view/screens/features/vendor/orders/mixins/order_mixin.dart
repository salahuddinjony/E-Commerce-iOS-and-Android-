import 'package:get/get.dart';
import '../models/custom_order_response_model.dart';
import '../constants/order_constants.dart';

mixin OrderMixin on GetxController {
  // Observable variables
  final RxList<Order> allOrders = <Order>[].obs;
  final RxList<Order> customOrders = <Order>[].obs; // Custom orders data
  final RxList<Order> generalOrders = <Order>[].obs; // General orders data

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isError = false.obs;
  final RxString errorMessage = ''.obs;


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
      case 'Offered':
        return customOrders.where((order) => 
          OrderConstants.isPendingStatus(order.status)
        ).toList();
      case 'Accepted Offers':
        return customOrders.where((order) => 
          OrderConstants.isInProgressStatus(order.status)
        ).toList();
      case 'Delivery Requested': 
        return customOrders.where((order) => 
          OrderConstants.isDeliveryRequestedStatus(order.status) 
        ).toList();
      case 'Delivered':
        return customOrders.where((order) =>  
          OrderConstants.isDeliveryConfirmedStatus(order.status)
        ).toList();
      case 'Revision':
        return customOrders.where((order) => 
          OrderConstants.isRevisionStatus(order.status)
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



  // Get order summary text
  String getOrderSummary<T>(order) {
    final productCount = order.products.length;
    final totalQuantity = order.totalQuantity;
    
    if (productCount == 1) {
      return '${totalQuantity} item'; 
    } else {
      return '${productCount} products, ${totalQuantity} items total';
    }
  }

  // Get order date display text
  String getOrderDateDisplay<T>(order) {
    final now = DateTime.now();
    final orderDate = order.createdAt;
    final difference = now.difference(orderDate); 

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}hr ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${orderDate.day}/${orderDate.month}/${orderDate.year}';
    }
  }

  // Check if order is recent (within last 24 hours)
  bool isRecentOrder<T>( order) {
    final now = DateTime.now();
    final orderDate = order.createdAt;
    final difference = now.difference(orderDate);
    return difference.inHours < 24;
  }
  

  // Process API response
  void processOrderResponse(CustomOrderResponseModel response, {bool isRefresh = false}) {
    try {
      if (isRefresh) {
        // For refresh, replace all data
        allOrders.assignAll(response.data.data);
        
        // Separate custom and general orders
        customOrders.assignAll(
          response.data.data.where((order) => order.isCustom).toList()
        );
        
        generalOrders.assignAll(
          response.data.data.where((order) => !order.isCustom).toList()
        );
      } else {
        // For pagination, append new data
        allOrders.addAll(response.data.data);
        
        // Separate and append custom and general orders
        customOrders.addAll(
          response.data.data.where((order) => order.isCustom).toList()
        );
        
        generalOrders.addAll(
          response.data.data.where((order) => !order.isCustom).toList()
        );
      }
      
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