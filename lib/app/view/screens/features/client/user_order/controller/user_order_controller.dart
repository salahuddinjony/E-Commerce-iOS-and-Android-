import 'dart:async';
import 'package:flutter/material.dart';
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

  // Pagination variables
  ScrollController customOrdersScrollController = ScrollController();
  ScrollController generalOrdersScrollController = ScrollController();
  ScrollController extensionsScrollController = ScrollController();
  
  // Custom Orders Pagination
  int customCurrentPage = 1;
  RxBool customHasMoreData = true.obs;
  RxBool customIsPaginating = false.obs;
  
  // General Orders Pagination
  int generalCurrentPage = 1;
  RxBool generalHasMoreData = true.obs;
  RxBool generalIsPaginating = false.obs;
  
  // Extensions Pagination
  int extensionsCurrentPage = 1;
  RxBool extensionsHasMoreData = true.obs;
  RxBool extensionsIsPaginating = false.obs;
  
  final int itemsPerPage = 10; // Number of items to load per page
  Timer? _customScrollDebounce;
  Timer? _generalScrollDebounce;

  // Fetch custom orders from API
  Future<void> fetchCustomOrders({int page = 1, bool isRefresh = false}) async {
    try {
      print('fetchCustomOrders called with page: $page, isRefresh: $isRefresh');
      
      // Only set isLoading for initial load (page 1) or refresh
      if (page == 1) {
        isLoading.value = true;
      }
      isError.value = false;
      
      if (isRefresh) {
        customOrders.clear();
        customCurrentPage = 1;
        customHasMoreData.value = true;
      }

      final response = await customerOrderService.fetchVendorOrders(
        role: 'client',
        isCustom: true,
        page: page,
        limit: itemsPerPage,
      );
      
      // debug: log raw response and meta
      print("fetchCustomOrders response: ${response.toString()}");
      print("fetchCustomOrders response.data: ${response.data}");
      print("fetchCustomOrders response.data.meta: ${response.data.meta}");

      totalCustomOrder.value = response.data.meta.total;
      
      if (page == 1 || isRefresh) {
        // First page or refresh - replace all orders
        processOrderResponse(response);
      } else {
        // Additional pages - append to existing orders
        final newOrders = response.data.data;
        customOrders.addAll(newOrders);
      }
      
      // Update pagination state based on response metadata
      final meta = response.data.meta;
      customHasMoreData.value = meta.page < meta.totalPages;
      print('Custom orders pagination: page ${meta.page}/${meta.totalPages}, hasMore: ${customHasMoreData.value}');
      
      print('Loaded ${response.data.data.length} custom orders for page $page. Total orders: ${customOrders.length}');

      // debug: inspect list after processing
      print("Total Custom Orders: ${totalCustomOrder.value}");
      print("Custom Orders length (after process): ${customOrders.length}");
      // clear any previous error on success
      errorMessage.value = '';
    } catch (e, st) {
      isError.value = true;
      errorMessage.value = e.toString();
      print("fetchCustomOrders error: $e");
      print(st);
      customHasMoreData.value = false;
    } finally {
      // always clear loading flag
      if (page == 1) {
        isLoading.value = false;
      }
      customIsPaginating.value = false;
    }
  }

  // Fetch general orders from API
  Future<void> fetchGeneralOrders({int page = 1, bool isRefresh = false}) async {
    try {
      print('fetchGeneralOrders called with page: $page, isRefresh: $isRefresh');
      
      // Only set isLoading for initial load (page 1) or refresh
      if (page == 1) {
        isGeneralOrdersLoading.value = true;
      }
      isGeneralOrdersError.value = false;
      
      if (isRefresh) {
        generalOrdersList.clear();
        generalCurrentPage = 1;
        generalHasMoreData.value = true;
      }

      final response = await generalOrderService.fetchGeneralOrders(
        role: 'client',
        page: page,
        limit: itemsPerPage,
      );
      
      // debug: log raw response and meta
      print("fetchGeneralOrders response: ${response.toString()}");
      print("fetchGeneralOrders response.data: ${response.data}");
      print("fetchGeneralOrders response.data.meta: ${response.data.meta}");

      totalGeneralOrder.value = response.data.meta.total;
      
      if (page == 1 || isRefresh) {
        // First page or refresh - replace all orders
        processGeneralOrderResponse(response);
      } else {
        // Additional pages - append to existing orders
        final newOrders = response.data.data;
        generalOrdersList.addAll(newOrders);
      }
      
      // Update pagination state based on response metadata
      final meta = response.data.meta;
      generalHasMoreData.value = meta.page < meta.totalPages;
      print('General orders pagination: page ${meta.page}/${meta.totalPages}, hasMore: ${generalHasMoreData.value}');
      
      print('Loaded ${response.data.data.length} general orders for page $page. Total orders: ${generalOrdersList.length}');

      // debug: inspect list after processing
      print("Total General Orders: ${totalGeneralOrder.value}");
      print("General Orders length (after process): ${generalOrdersList.length}");
      generalOrdersErrorMessage.value = '';
    } catch (e, st) {
      isGeneralOrdersError.value = true;
      generalOrdersErrorMessage.value = e.toString();
      print("fetchGeneralOrders error: $e");
      print(st);
      generalHasMoreData.value = false;
    } finally {
      if (page == 1) {
        isGeneralOrdersLoading.value = false;
      }
      generalIsPaginating.value = false;
    }
  }

  // Load more custom orders for pagination
  Future<void> getMoreCustomOrders() async {
    print('getMoreCustomOrders called - hasMoreData: ${customHasMoreData.value}, isPaginating: ${customIsPaginating.value}');
    
    if (!customHasMoreData.value) {
      print('Custom pagination blocked - no more data available');
      customIsPaginating.value = false;
      return;
    }

    print('Starting custom orders pagination - loading page ${customCurrentPage + 1}');
    try {
      customIsPaginating.value = true;
      final nextPage = customCurrentPage + 1;
      
      await fetchCustomOrders(page: nextPage);
      customCurrentPage = nextPage;
      
      print('Custom orders pagination completed successfully. Current page: $customCurrentPage');
    } catch (e) {
      print('Custom orders pagination failed: $e');
      customHasMoreData.value = false;
    } finally {
      customIsPaginating.value = false;
    }
  }

  // Load more general orders for pagination
  Future<void> getMoreGeneralOrders() async {
    print('getMoreGeneralOrders called - hasMoreData: ${generalHasMoreData.value}, isPaginating: ${generalIsPaginating.value}');
    
    if (!generalHasMoreData.value) {
      print('General pagination blocked - no more data available');
      generalIsPaginating.value = false;
      return;
    }

    print('Starting general orders pagination - loading page ${generalCurrentPage + 1}');
    try {
      generalIsPaginating.value = true;
      final nextPage = generalCurrentPage + 1;
      
      await fetchGeneralOrders(page: nextPage);
      generalCurrentPage = nextPage;
      
      print('General orders pagination completed successfully. Current page: $generalCurrentPage');
    } catch (e) {
      print('General orders pagination failed: $e');
      generalHasMoreData.value = false;
    } finally {
      generalIsPaginating.value = false;
    }
  }

  // Scroll listeners
  void _onCustomOrdersScroll() {
    if (_customScrollDebounce?.isActive ?? false) _customScrollDebounce!.cancel();
    _customScrollDebounce = Timer(const Duration(milliseconds: 50), () {
      _handleCustomOrdersScrollEvent();
    });
  }

  void _onGeneralOrdersScroll() {
    if (_generalScrollDebounce?.isActive ?? false) _generalScrollDebounce!.cancel();
    _generalScrollDebounce = Timer(const Duration(milliseconds: 50), () {
      _handleGeneralOrdersScrollEvent();
    });
  }

  void _handleCustomOrdersScrollEvent() {
    if (!customOrdersScrollController.position.hasContentDimensions) return;
    
    final currentPosition = customOrdersScrollController.position.pixels;
    final maxExtent = customOrdersScrollController.position.maxScrollExtent;
    
    final threshold80 = maxExtent * 0.8;
    
    bool shouldPaginate = !customIsPaginating.value &&
        customHasMoreData.value &&
        maxExtent > 0 &&
        currentPosition >= threshold80;
    
    if (shouldPaginate) {
      print('Triggering custom orders pagination');
      customIsPaginating.value = true;
      getMoreCustomOrders();
    }
  }

  void _handleGeneralOrdersScrollEvent() {
    if (!generalOrdersScrollController.position.hasContentDimensions) return;
    
    final currentPosition = generalOrdersScrollController.position.pixels;
    final maxExtent = generalOrdersScrollController.position.maxScrollExtent;
    
    final threshold80 = maxExtent * 0.8;
    
    bool shouldPaginate = !generalIsPaginating.value &&
        generalHasMoreData.value &&
        maxExtent > 0 &&
        currentPosition >= threshold80;
    
    if (shouldPaginate) {
      print('Triggering general orders pagination');
      generalIsPaginating.value = true;
      getMoreGeneralOrders();
    }
  }

  // Refresh methods for pull-to-refresh
  Future<void> refreshCustomOrders() async {
    customCurrentPage = 1;
    await fetchCustomOrders(isRefresh: true);
  }

  Future<void> refreshGeneralOrders() async {
    generalCurrentPage = 1;
    await fetchGeneralOrders(isRefresh: true);
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
      case 'delivery-confirmed':
        isAcceptDeliveryLoading.value = true;
        break;
      case 'request_revision':
        isRequestRevisionLoading.value = true;
        break;
      default:
        isAcceptLoading.value = true; // fallback to default
    }
    
    debugPrint("Accepting order: $orderId with sessionId: $sessionId, action: $action");
    final String orderStatus ='accepted';
    
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
        case 'delivery-confirmed':
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
      refreshCustomOrders(),
      refreshGeneralOrders(),
    ]);
  }

  @override
  void onInit() {
    // Initialize pagination state
    _initializePaginationState();
    
    // Add scroll listeners for pagination
    customOrdersScrollController.addListener(_onCustomOrdersScroll);
    generalOrdersScrollController.addListener(_onGeneralOrdersScroll);
    
    // Fetch fresh data on initialization
    _loadInitialData();
    print("------------------UserOrderController initialized---------");
    super.onInit();
  }

  // Initialize pagination state
  void _initializePaginationState() {
    customCurrentPage = 1;
    customHasMoreData.value = true;
    customIsPaginating.value = false;
    
    generalCurrentPage = 1;
    generalHasMoreData.value = true;
    generalIsPaginating.value = false;
  }

  // Load initial fresh data
  Future<void> _loadInitialData() async {
    try {
      // Load latest items for both order types with proper refresh
      await Future.wait([
        fetchCustomOrders(page: 1, isRefresh: true),
        fetchGeneralOrders(page: 1, isRefresh: true),
      ]);
    } catch (e) {
      print('Error loading initial data: $e');
    }
  }

  @override
  void onClose() {
    // Clean up pagination resources
    _customScrollDebounce?.cancel();
    _generalScrollDebounce?.cancel();
    customOrdersScrollController.removeListener(_onCustomOrdersScroll);
    generalOrdersScrollController.removeListener(_onGeneralOrdersScroll);
    customOrdersScrollController.dispose();
    generalOrdersScrollController.dispose();
    
    super.onClose();
  }
}
