import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/api_url.dart';
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import '../models/custom_order_response_model.dart';

class CustomOrderService {
  /// Fetch all orders for a vendor
  Future<CustomOrderResponseModel> fetchVendorOrders({
    int? page,
    int? limit,
    String? status,
    bool? isCustom,
    String? UserId, // added
    required String role,
  }) async {
    try {
      // Fallback: load UserId from prefs if not provided
      UserId ??= await SharePrefsHelper.getString(AppConstants.userId);

      final queryParams = <String, dynamic>{};

      // if (page != null) queryParams['page'] = page;
      // if (limit != null) queryParams['limit'] = limit;
      // if (status != null && status.isNotEmpty) queryParams['status'] = status;
      // if (isCustom != null) queryParams['isCustom'] = isCustom;

      if (UserId.isNotEmpty) {
        queryParams[role] = UserId;
      }

      print('Fetching orders with query: $queryParams');

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
    return await fetchVendorOrders(status: status, role: 'vendor');
  }

  /// Fetch custom orders
  Future<CustomOrderResponseModel> fetchCustomOrders() async {
    return await fetchVendorOrders(isCustom: true, role: 'vendor');
  }

  /// Fetch general orders
  Future<CustomOrderResponseModel> fetchGeneralOrders() async {
    return await fetchVendorOrders(isCustom: false, role: 'vendor');
  }

  /// Update order status
  Future<bool> updateOrderStatusOrUpdateExtn(String orderId, String status, {String? passedUrl}) async {
    print('Updating order status: $orderId to $status');
    print('Using URL: ${passedUrl ?? "Url not provided, will use default"}');
    try {
      final url = passedUrl ?? ApiUrl.updateCustomOrderStatus(orderId: orderId);
      print('Sending PATCH request to: $url');

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'status': status}),
      );
      print('Response status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // throw Exception('Failed to update order status: ${response.body}')
       print('Order status updated successfully: $orderId to $status');
       return true;
      } else {
         print('Failed to update order status: ${response.body}');  
        return false;
       
      }
    } catch (e) {
      // throw Exception('Failed to update order status: $e');
      print('Error updating order status: $e');
      return false;
    }
  }

  /// Accept order
  Future<void> acceptOrder(String orderId) async {
    await updateOrderStatusOrUpdateExtn(orderId, 'accepted');
  }

  /// Reject order
  Future<void> rejectOrder(String orderId) async {
    await updateOrderStatusOrUpdateExtn(orderId, 'rejected');
  }

  /// Mark order as in progress
  Future<void> markOrderInProgress(String orderId) async {
    await updateOrderStatusOrUpdateExtn(orderId, 'in-progress');
  }

  /// Mark order as completed
  Future<void> markOrderCompleted(String orderId) async {
    await updateOrderStatusOrUpdateExtn(orderId, 'completed');
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