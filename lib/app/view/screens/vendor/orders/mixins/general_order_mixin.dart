import 'package:get/get.dart';
import '../models/general_order_response_model.dart';
import '../constants/order_constants.dart';

mixin GeneralOrderMixin on GetxController {
  // Observable variables for general orders
  final RxList<GeneralOrder> generalOrdersList = <GeneralOrder>[].obs;
  
  // Loading states
  final RxBool isGeneralOrdersLoading = false.obs;
  final RxBool isGeneralOrdersError = false.obs;
  final RxString generalOrdersErrorMessage = ''.obs;

  // Get general orders by status
  List<GeneralOrder> getGeneralOrdersByStatusGeneral(String status) {
    return generalOrdersList.where((order) => order.status == status).toList();
  }

  // Get general orders for specific tab
  List<GeneralOrder> getGeneralOrdersForTabGeneral(String tab) {
    switch (tab) {
      case 'All Orders':
        return generalOrdersList;
      case 'Pending':
        return generalOrdersList.where((order) => 
          OrderConstants.isPendingStatus(order.status)
        ).toList();
      case 'Completed':
        return generalOrdersList.where((order) => 
          OrderConstants.isCompletedStatus(order.status)
        ).toList();
      case 'Rejected':
        return generalOrdersList.where((order) => 
          OrderConstants.isCancelledStatus(order.status)
        ).toList();
      default:
        return [];
    }
  }

  // Process general order API response
  void processGeneralOrderResponse(GeneralOrderResponseModel response) {
    try {
      generalOrdersList.assignAll(response.data.data);
      isGeneralOrdersLoading.value = false;
      isGeneralOrdersError.value = false;
      generalOrdersErrorMessage.value = '';
    } catch (e) {
      isGeneralOrdersLoading.value = false;
      isGeneralOrdersError.value = true;
      generalOrdersErrorMessage.value = 'Error processing general orders: $e';
      print('General order processing error: $e');
    }
  }


  // Get order priority (for sorting)
  int getOrderPriority(GeneralOrder order) {
    switch (order.status) {
      case 'pending':
        return 1; // Highest priority
      case 'offered':
        return 2;
      case 'accepted':
        return 3;
      case 'in-progress':
        return 4;
      case 'delivery-requested':
        return 5;
      case 'delivery-confirmed':
        return 6;
      case 'completed':
        return 7;
      case 'cancelled':
      case 'rejected':
        return 8; // Lowest priority
      default:
        return 9;
    }
  }

  // Sort general orders by priority and date
  List<GeneralOrder> getSortedGeneralOrders(List<GeneralOrder> orders) {
    final sortedOrders = List<GeneralOrder>.from(orders);
    sortedOrders.sort((a, b) {
      final priorityA = getOrderPriority(a);
      final priorityB = getOrderPriority(b);
      
      if (priorityA != priorityB) {
        return priorityA.compareTo(priorityB);
      }
      
      // If same priority, sort by creation date (newest first)
      return b.createdAt.compareTo(a.createdAt);
    });
    
    return sortedOrders;
  }

  // Get orders for specific tab with sorting
  List<GeneralOrder> getSortedGeneralOrdersForTab(String tab) {
    final orders = getGeneralOrdersForTabGeneral(tab);
    return getSortedGeneralOrders(orders);
  }

  // Clear general orders data
  void clearGeneralOrders() {
    generalOrdersList.clear();
    isGeneralOrdersLoading.value = false;
    isGeneralOrdersError.value = false;
    generalOrdersErrorMessage.value = '';
  }

  // Get general orders statistics
  Map<String, int> getGeneralOrdersStatistics() {
    final stats = <String, int>{};
    
    for (final order in generalOrdersList) {
      final status = order.status;
      stats[status] = (stats[status] ?? 0) + 1;
    }
    
    return stats;
  }

  // Get total revenue from general orders
  double getTotalGeneralOrdersRevenue() {
    return generalOrdersList.fold(0.0, (sum, order) => sum + order.price);
  }

  // Get average order value
  double getAverageGeneralOrderValue() {
    if (generalOrdersList.isEmpty) return 0.0;
    return getTotalGeneralOrdersRevenue() / generalOrdersList.length;
  }
} 