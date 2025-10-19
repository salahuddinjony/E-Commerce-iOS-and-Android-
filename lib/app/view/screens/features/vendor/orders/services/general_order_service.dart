import 'dart:convert';

import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/api_url.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import '../models/general_order_response_model.dart';

class GeneralOrderService {
  /// Fetch all general orders for a vendor
  Future<GeneralOrderResponseModel> fetchGeneralOrders({
    int? page,
    int? limit,
    String? status,
    String? UserId, // added
    required String role,
  }) async {
    try {
      final queryParams = <String, String>{};
      UserId ??= await SharePrefsHelper.getString(AppConstants.userId);
      if (UserId.isNotEmpty) {
        queryParams[role] = UserId;
      }

      if (page != null) queryParams['page'] = page.toString();
      if (limit != null) queryParams['limit'] = limit.toString();
      if (status != null) {
        queryParams['status'] = status;
      }

      print('Fetching general orders with query: $queryParams');

      final response = await ApiClient.getData(
        '${ApiUrl.baseUrl}general-order/retrieve',
        query: queryParams,
      );

      print('General orders response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        try {
          return GeneralOrderResponseModel.fromJson(response.body);
        } catch (e) {
          print('Error parsing general orders response: $e');
          print('Response body: ${response.body}');
          throw Exception('Failed to parse general orders response: $e');
        }
      } else {
        throw Exception('Failed to fetch general orders: ${response.statusText}');
      }
    } catch (e) {
      throw Exception('Failed to fetch general orders: $e');
    }
  }

  /// Fetch general orders by status
  Future<GeneralOrderResponseModel> fetchGeneralOrdersByStatus(String status) async {
    return await fetchGeneralOrders(status: status, role: 'vendor');
  }

  /// Update general order status
  Future<bool> updateGeneralOrderStatus(String orderId, String status) async {
    try {
      final response = await ApiClient.patchData(
        '${ApiUrl.baseUrl}general-order/update/$orderId',
        jsonEncode({'status': status}),
      );

      if (response.statusCode != 200) {

        return false;

      }
      return true;
    } catch (e) {
      return false;
    }
  }
  //Delete order
  Future<bool> deleteGeneralOrder(String orderId) async {
    try {
      final response = await ApiClient.deleteData(
        ApiUrl.deleteGeneralOrder(orderId: orderId),
      );

      if (response.statusCode != 200) {
        // throw Exception('Failed to delete general order: ${response.statusText}');
        return false;
      }
    } catch (e) {
      // throw Exception('Failed to delete general order: $e');
      return false;
    }
    return true;
  }

  /// Accept general order
  Future<void> acceptGeneralOrder(String orderId) async {
    await updateGeneralOrderStatus(orderId, 'accepted');
  }

  /// Reject general order
  Future<void> rejectGeneralOrder(String orderId) async {
    await updateGeneralOrderStatus(orderId, 'rejected');
  }

  /// Mark general order as in progress
  Future<void> markGeneralOrderInProgress(String orderId) async {
    await updateGeneralOrderStatus(orderId, 'in-progress');
  }

  /// Mark general order as completed
  Future<void> markGeneralOrderCompleted(String orderId) async {
    await updateGeneralOrderStatus(orderId, 'completed');
  }

  /// Mark general order as delivered
  Future<void> markGeneralOrderDelivered(String orderId) async {
    await updateGeneralOrderStatus(orderId, 'delivery-confirmed');
  }

  /// Get general order details
  Future<GeneralOrder> getGeneralOrderDetails(String orderId) async {
    try {
      final response = await ApiClient.getData(
        '${ApiUrl.baseUrl}general-order/retrieve/$orderId',
      );

      if (response.statusCode == 200) {
        // Assuming the API returns a single order object
        return GeneralOrder.fromJson(response.body);
      } else {
        throw Exception('Failed to fetch general order details: ${response.statusText}');
      }
    } catch (e) {
      throw Exception('Failed to fetch general order details: $e');
    }
  }

  /// Get general orders statistics
  Future<Map<String, dynamic>> getGeneralOrdersStatistics() async {
    try {
      final response = await ApiClient.getData(
        '${ApiUrl.baseUrl}general-order/statistics',
      );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to fetch general orders statistics: ${response.statusText}');
      }
    } catch (e) {
      throw Exception('Failed to fetch general orders statistics: $e');
    }
  }

  /// Search general orders
  Future<GeneralOrderResponseModel> searchGeneralOrders(String query) async {
    try {
      final response = await ApiClient.getData(
        '${ApiUrl.baseUrl}general-order/search',
        query: {'q': query},
      );

      if (response.statusCode == 200) {
        return GeneralOrderResponseModel.fromJson(response.body);
      } else {
        throw Exception('Failed to search general orders: ${response.statusText}');
      }
    } catch (e) {
      throw Exception('Failed to search general orders: $e');
    }
  }
} 