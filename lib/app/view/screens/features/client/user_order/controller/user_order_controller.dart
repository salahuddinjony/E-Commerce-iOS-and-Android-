import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:local/app/services/api_url.dart';
import 'package:local/app/view/screens/features/client/user_order/mixin/mixin_extend_order.dart';
import 'package:local/app/view/screens/features/vendor/orders/mixins/general_order_mixin.dart';
import 'package:local/app/view/screens/features/vendor/orders/mixins/order_mixin.dart';
import 'package:local/app/view/screens/features/vendor/orders/services/custom_order_service.dart';
import 'package:local/app/view/screens/features/vendor/orders/services/general_order_service.dart';

class UserOrderController extends GetxController
    with GeneralOrderMixin, OrderMixin, MixinExtendOrder {
  //Create instances of services
  final CustomOrderService customerOrderService = CustomOrderService();
  final GeneralOrderService generalOrderService = GeneralOrderService();

  RxInt totalCustomOrder = 0.obs;
  RxInt totalGeneralOrder = 0.obs;
  RxBool isLoadingForExtn = false.obs;
  RxBool isError = false.obs;
  RxString errorMessage = ''.obs;
  RxInt selectedOrderType = 0.obs; // 0 for Custom Orders, 1 for General Orders
  
  // Loading states for order status updates
  RxBool isAcceptLoading = false.obs;
  RxBool isRejectLoading = false.obs;
  
  // Individual loading states for specific actions
  RxBool isAcceptOfferLoading = false.obs;
  RxBool isRejectOfferLoading = false.obs;
  RxBool isAcceptDeliveryLoading = false.obs;
  RxBool isRequestRevisionLoading = false.obs;

  // Fetch custom orders from API
  Future<void> fetchCustomOrders() async {
    try {
      isLoading.value = true;
      isError.value = false;

      final response =
          await customerOrderService.fetchVendorOrders(role: 'client');
      // debug: log raw response and meta
      print("fetchCustomOrders response: ${response.toString()}");
      print("fetchCustomOrders response.data: ${response.data}");
      print("fetchCustomOrders response.data.meta: ${response.data.meta}");

      totalCustomOrder.value = response.data.meta.total;
      processOrderResponse(response);

      // debug: inspect list after processing
      print("Total Custom Orders: ${totalCustomOrder.value}");
      print("Custom Orders length (after process): ${customOrders.length}");
      print("Custom Orders content: ${customOrders}");
      // clear any previous error on success
      errorMessage.value = '';
    } catch (e, st) {
      isError.value = true;
      errorMessage.value = e.toString();
      print("fetchCustomOrders error: $e");
      print(st);
    } finally {
      // always clear loading flag
      isLoading.value = false;
    }
  }

  // Fetch general orders from API
  Future<void> fetchGeneralOrders() async {
    try {
      isGeneralOrdersLoading.value = true;
      isGeneralOrdersError.value = false;

      final response =
          await generalOrderService.fetchGeneralOrders(role: 'client');
      // debug: log raw response and meta
      print("fetchGeneralOrders response: ${response.toString()}");
      print("fetchGeneralOrders response.data: ${response.data}");
      print("fetchGeneralOrders response.data.meta: ${response.data.meta}");

      totalGeneralOrder.value = response.data.meta.total;
      processGeneralOrderResponse(response);

      // debug: inspect list after processing
      print("Total General Orders: ${totalGeneralOrder.value}");
      print("General Orders length (after process): ${generalOrdersList.length}");
      print("General Orders content: ${generalOrdersList}");
      generalOrdersErrorMessage.value = '';
    } catch (e, st) {
      isGeneralOrdersError.value = true;
      generalOrdersErrorMessage.value = e.toString();
      print("fetchGeneralOrders error: $e");
      print(st);
    } finally {
      isGeneralOrdersLoading.value = false;
    }
  }

  Future<bool> updateOrderExtention(
      {required String orderId, required String status}) async {
    isLoadingForExtn.value = true;

    try {
      return await customerOrderService.updateOrderStatusOrUpdateExtn(
          orderId, status,
          passedUrl: ApiUrl.updateExtendRequestStatus(requestId: orderId));
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
      return false;
    } finally {
      isLoadingForExtn.value = false;
    }
  }

  // Accept order method with action-specific loading states
  Future<bool> acceptOrder({
    required String orderId, 
    String? sessionId, 
    String? status, 
    String? action
  }) async {
    // Set appropriate loading state based on action
    switch (action) {
      case 'accept_offer':
        isAcceptOfferLoading.value = true;
        break;
      case 'accept_delivery':
        isAcceptDeliveryLoading.value = true;
        break;
      case 'request_revision':
        isRequestRevisionLoading.value = true;
        break;
      default:
        isAcceptLoading.value = true; // fallback to default
    }
    
    debugPrint("Accepting order: $orderId with sessionId: $sessionId, action: $action");
    final String orderStatus = status ?? 'accepted';
    
    try {
      return await customerOrderService.updateOrderStatusOrUpdateExtn(
          orderId, orderStatus, sessionId: sessionId);
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
      return false;
    } finally {
      // Clear appropriate loading state based on action
      switch (action) {
        case 'accept_offer':
          isAcceptOfferLoading.value = false;
          break;
        case 'accept_delivery':
          isAcceptDeliveryLoading.value = false;
          break;
        case 'request_revision':
          isRequestRevisionLoading.value = false;
          break;
        default:
          isAcceptLoading.value = false; // fallback to default
      }
    }
  }

  // Reject order method with action-specific loading states
  Future<bool> rejectOrder({required String orderId, String? status, String? action}) async {
    // Set appropriate loading state based on action
    switch (action) {
      case 'reject_offer':
        isRejectOfferLoading.value = true;
        break;
      default:
        isRejectLoading.value = true; // fallback to default
    }
    
    try {
      return await customerOrderService.updateOrderStatusOrUpdateExtn(
          orderId, status ?? 'rejected');
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
      return false;
    } finally {
      // Clear appropriate loading state based on action
      switch (action) {
        case 'reject_offer':
          isRejectOfferLoading.value = false;
          break;
        default:
          isRejectLoading.value = false; // fallback to default
      }
    }
  }

  // Fetch all orders (both custom and general)
  Future<void> fetchAllOrders() async {
    await Future.wait([
      fetchCustomOrders(),
      fetchGeneralOrders(),
    ]);
  }

  @override
  void onInit() {
    // run both sequentially when debugging to make output easier to follow
    fetchCustomOrders().then((_) => fetchGeneralOrders());
    print("------------------UserOrderController initialized---------");
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
