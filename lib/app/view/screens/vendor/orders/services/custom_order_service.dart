import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/app_url.dart';
import '../models/custom_order_response_model.dart';

class CustomOrderService {
  /// Fetch all orders for a vendor
  Future<CustomOrderResponseModel> fetchVendorOrders({
    int page = 1,
    int limit = 10,
    String? status,
    bool? isCustom,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (status != null) {
        queryParams['status'] = status;
      }

      if (isCustom != null) {
        queryParams['isCustom'] = isCustom;
      }

      final response = await ApiClient.getData(
        ApiUrl.customOrder,
        query: queryParams,
      );

      if (response.statusCode == 200) {
        return CustomOrderResponseModel.fromJson(response.body);
      } else {
        throw Exception('Failed to fetch orders: ${response.statusText}');
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    }
  }

  /// Fetch orders by status
  Future<CustomOrderResponseModel> fetchOrdersByStatus(String status) async {
    return await fetchVendorOrders(status: status);
  }

  /// Fetch custom orders
  Future<CustomOrderResponseModel> fetchCustomOrders() async {
    return await fetchVendorOrders(isCustom: true);
  }

  /// Fetch general orders
  Future<CustomOrderResponseModel> fetchGeneralOrders() async {
    return await fetchVendorOrders(isCustom: false);
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final response = await ApiClient.patchData(
        '/order/update/$orderId/status',
        {'status': status},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update order status: ${response.statusText}');
      }
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  /// Accept order
  Future<void> acceptOrder(String orderId) async {
    await updateOrderStatus(orderId, 'accepted');
  }

  /// Reject order
  Future<void> rejectOrder(String orderId) async {
    await updateOrderStatus(orderId, 'rejected');
  }

  /// Mark order as in progress
  Future<void> markOrderInProgress(String orderId) async {
    await updateOrderStatus(orderId, 'in-progress');
  }

  /// Mark order as completed
  Future<void> markOrderCompleted(String orderId) async {
    await updateOrderStatus(orderId, 'completed');
  }

  /// Request delivery extension
  Future<void> requestDeliveryExtension(
    String orderId,
    DateTime newDate,
    String reason,
  ) async {
    try {
      final response = await ApiClient.postData(
        '/order/$orderId/extension',
        {
          'newDate': newDate.toIso8601String(),
          'reason': reason,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to request delivery extension: ${response.statusText}');
      }
    } catch (e) {
      throw Exception('Failed to request delivery extension: $e');
    }
  }
} 