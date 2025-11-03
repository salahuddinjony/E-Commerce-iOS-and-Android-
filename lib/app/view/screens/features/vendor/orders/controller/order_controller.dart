import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local/app/core/route_path.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/api_url.dart';
import '../mixins/order_mixin.dart';
import '../mixins/general_order_mixin.dart';
import '../models/custom_order_response_model.dart';
import '../services/custom_order_service.dart';
import '../services/general_order_service.dart';
import '../constants/order_constants.dart';

class OrdersController extends GetxController
    with GetTickerProviderStateMixin, OrderMixin, GeneralOrderMixin {
  late TabController generalTabController;
  late TabController customTabController;

  //Create instances of services
  final CustomOrderService customerOrderService = CustomOrderService();
  final GeneralOrderService generalOrderService = GeneralOrderService();

  var isCustomOrder = true.obs; // toggle state
  RxList<File> selectedImages = <File>[].obs;
  final TextEditingController descController = TextEditingController();
  final RxList<String> selectedFiles = <String>[].obs;

  Future<void> pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile>? images = await picker.pickMultipleMedia();
      if (images != null && images.isNotEmpty) {
        selectedImages.addAll(images.map((xfile) => File(xfile.path)));
      }
    } catch (e) {
      print('Error picking images: $e');
    }
  }

  RxInt totalCustomOrder = 0.obs;
  RxInt totalInProgressOrder = 0.obs;
  RxInt totalGeneralOrder = 0.obs;
  RxInt totalPendingOrder = 0.obs;

  // Loading states for order status updates
  RxBool isAcceptLoading = false.obs;
  RxBool isRejectLoading = false.obs;

  List<String> get generalTabs => OrderConstants.generalTabs;
  List<String> get customTabs => OrderConstants.customTabs;

  void totalOrder() async {
    totalInProgressOrder.value = await customOrders
        .where((order) => order.status == OrderConstants.statusInProgress)
        .length;
    totalPendingOrder.value = await customOrders
        .where((order) =>
            order.status == OrderConstants.statusPending ||
            order.status == OrderConstants.statusOffered)
        .length;
  }

  // Get the current tabs
  List<String> get currentTabs =>
      isCustomOrder.value ? customTabs : generalTabs;

  // Get the current tab controller
  TabController get currentTabController =>
      isCustomOrder.value ? customTabController : generalTabController;

   // Pagination variables
  ScrollController scrollController = ScrollController();
  int currentPage = 1;
  RxBool hasMoreData = true.obs;
  RxBool isPaginating = false.obs;
  final int itemsPerPage = 10; // Number of items to load per page
  Rx<RxStatus> getCustomOrdersStatus = RxStatus.success().obs;
  Timer? _scrollDebounce;


  @override
  void onInit() {

    scrollController.addListener(_onScroll);

    super.onInit();
    totalOrder();
    generalTabController =
        TabController(length: generalTabs.length, vsync: this);
    customTabController = TabController(length: customTabs.length, vsync: this);

    // Listen for tab changes to filter orders by status
    generalTabController.addListener(() {
      if (!generalTabController.indexIsChanging) {
        final currentTab = generalTabs[generalTabController.index];
        final status = _getStatusFromGeneralTab(currentTab);
        print('General tab changed to: $currentTab with status: $status');
        print('Calling fetchGeneralOrders with status: $status');
        fetchGeneralOrders(status: status);
      }
    });
    
    customTabController.addListener(() {
      if (!customTabController.indexIsChanging) {
        final currentTab = customTabs[customTabController.index];
        final status = _getStatusFromCustomTab(currentTab);
        print('Custom tab changed to: $currentTab with status: $status');
        print('Calling fetchCustomOrders with status: $status');
        fetchCustomOrders(status: status, isRefresh: true);
      }
    });

    // Load both types of orders
    fetchAllOrders();
  }
   void _onScroll() {
    // Debounce scroll events to prevent rapid fire, but keep it responsive
    if (_scrollDebounce?.isActive ?? false) _scrollDebounce!.cancel();
    
    _scrollDebounce = Timer(const Duration(milliseconds: 50), () {
      _handleScrollEvent();
    });
  }
  
  void _handleScrollEvent() {
    // Check if we can scroll (avoid division by zero)
    if (!scrollController.position.hasContentDimensions) return;
    
    final currentPosition = scrollController.position.pixels;
    final maxExtent = scrollController.position.maxScrollExtent;
    
    // Use multiple thresholds to make pagination more responsive (lowered for testing)
    final threshold50 = maxExtent * 0.5; // 50% threshold for easier testing
    final threshold80 = maxExtent * 0.8; // 80% threshold
    final threshold90 = maxExtent * 0.9; // 90% threshold
    final thresholdNearBottom = maxExtent - 100; // Within 100 pixels of bottom
    
    print('Scroll event - pixels: $currentPosition, maxExtent: $maxExtent');
    print('Thresholds - 50%: $threshold50, 80%: $threshold80, 90%: $threshold90, nearBottom: $thresholdNearBottom');
    print('isCustomOrder: ${isCustomOrder.value}, isPaginating: ${isPaginating.value}, hasMoreData: ${hasMoreData.value}');
    
    // Only paginate for custom orders since general orders don't support pagination
    // Use multiple conditions to trigger pagination more reliably
    bool shouldPaginate = isCustomOrder.value &&
        !isPaginating.value &&
        hasMoreData.value &&
        maxExtent > 0 &&
        (currentPosition >= threshold50 || // 50% scrolled (easier for testing)
         currentPosition >= threshold80 || // 80% scrolled
         currentPosition >= thresholdNearBottom || // Near bottom
         (maxExtent > 0 && (currentPosition / maxExtent) >= 0.5)); // Alternative percentage check
    
    if (shouldPaginate) {
      final percentage = (currentPosition / maxExtent * 100).toStringAsFixed(1);
      print('Triggering pagination - $percentage% scrolled');
      // Set paginating flag immediately to show loader
      isPaginating.value = true;
      getMoreOrders();
    }
  }

  @override
  void onClose() {
    generalTabController.dispose();
    customTabController.dispose();
    scrollController.dispose();
    _scrollDebounce?.cancel();
    super.onClose();
  }

  // Fetch all orders (both custom and general)
  Future<void> fetchAllOrders() async {
    await Future.wait([
      fetchCustomOrders(isRefresh: true),
      fetchGeneralOrders(),
    ]);
  }

  // Fetch custom orders from API
  Future<void> fetchCustomOrders({int page = 1, bool isRefresh = false, String? status}) async {
    try {
      print('fetchCustomOrders called with status: $status, page: $page, isRefresh: $isRefresh');
      
      // Only set isLoading for initial load (page 1) or refresh
      if (page == 1) {
        isLoading.value = true;
        getCustomOrdersStatus.value = RxStatus.loading();
      } else {
        getCustomOrdersStatus.value = RxStatus.success();
      }
      
      isError.value = false;
      if (isRefresh) {
        currentPage = 1;
        hasMoreData.value = true;
        customOrders.clear();
      }
  
      final response = await customerOrderService.fetchVendorOrders(
        role: 'vendor',
        page: page, 
        limit: itemsPerPage,
        status: status,
      );
      totalCustomOrder.value = response.data.meta.total;
      final newData = response.data.data;
      
      if(newData.isNotEmpty){
        processOrderResponse(response, isRefresh: isRefresh);
        currentPage = page;
        
        // Check if there's more data based on total count vs current loaded items
        final totalLoadedItems = customOrders.length;
        hasMoreData.value = totalLoadedItems < response.data.meta.total;
        print('Loaded ${newData.length} items, total loaded: $totalLoadedItems, total available: ${response.data.meta.total}, hasMoreData: ${hasMoreData.value}');
      } else {
        hasMoreData.value = false;
        print('No more data available');
      }
     
      totalOrder();
    } catch (e) {
      isError.value = true;
      errorMessage.value = e.toString();
      // Reset pagination flag on error
      isPaginating.value = false;
    } finally {
      // Always reset loading state for initial load or refresh
      if (page == 1) {
        isLoading.value = false;
        getCustomOrdersStatus.value = RxStatus.success();
      }
      isPaginating.value = false;
    }
  }
  // Fetch more orders for pagination
    // Load more data when scrolling reaches the bottom
  Future<void> getMoreOrders() async {
    print('getMoreOrders called - hasMoreData: ${hasMoreData.value}, isPaginating: ${isPaginating.value}');
    
    if (!hasMoreData.value) {
      print('Pagination blocked - no more data available');
      isPaginating.value = false;
      return;
    }

    print('Starting pagination - loading page ${currentPage + 1}');
    try {
      await fetchCustomOrders(page: currentPage + 1);
      print('Pagination completed successfully');
    } catch (e) {
      print('Pagination failed: $e');
    } finally {
      isPaginating.value = false;
    }
  }


  // Fetch general orders from API
  Future<void> fetchGeneralOrders({int page = 1, bool isRefresh = false, String? status}) async {
    try {
      print('fetchGeneralOrders called with status: $status, page: $page, isRefresh: $isRefresh');
      
      isGeneralOrdersLoading.value = true;
      isGeneralOrdersError.value = false;

      final response = await generalOrderService.fetchGeneralOrders(
        role: 'vendor',
        status: status,
      );
      totalGeneralOrder.value = response.data.meta.total;
      processGeneralOrderResponse(response);
    } catch (e) {
      isGeneralOrdersError.value = true;
      generalOrdersErrorMessage.value = e.toString();
    } finally {
      isGeneralOrdersLoading.value = false;
    }
  }

  // Fetch orders by type
  Future<void> fetchOrdersByType(bool isCustom) async {
    if (isCustom) {
      await fetchCustomOrders(isRefresh: true);
    } else {
      await fetchGeneralOrders();
    }
  }

  // Update custom order status
  Future<bool> updateCustomOrderStatus(String orderId, String status) async {
    isAcceptLoading.value = true;
    try {
      print('Updating custom order status: $orderId to $status');
      final result = await customerOrderService.updateOrderStatusOrUpdateExtn(
          orderId, status);
      // Refresh custom orders after status update
      refreshOrdersByType(true);
      return result;
    } catch (e) {
      print('Failed to update custom order status: $e');
      return false;
    } finally {
      isAcceptLoading.value = false;
    }
  }

  Future<bool> updateOrderToDeliveryRequested(
      String orderId, String status) async {
    isAcceptLoading.value = true;
    try {
      print('Updating custom order status: $orderId to $status');

      // Create the request body - exclude workSamples from body since they're sent as multipart
      Map<String, dynamic> body = {
        "status": status,
        "description": descController.text,
      };

      // Debug the URL being generated
      String apiUrl = ApiUrl.updateCustomOrderStatus(orderId: orderId);
      print('Generated API URL: $apiUrl');
      
      // Try using the exact URL from your successful test
      String correctUrl = "order/update/$orderId";
      print('Using corrected URL: $correctUrl');

      final result = await ApiClient.patchMultipart(
          correctUrl, // Use the corrected URL instead
          body,
          multipartBody: selectedImages
              .map((xfile) => MultipartBody(
                    'workSamples',
                    xfile,
                  ))
              .toList());
      if (result.statusCode != 200) {
        print('Failed to update custom order status: ${result.body}');
        return false;
      }
      // Refresh custom orders after status update
      refreshOrdersByType(true);
      debugPrint('Order updated successfully: ${result.body}');
      fetchCustomOrders(isRefresh: true);
      return true;
    } catch (e) {
      print('Failed to update custom order status: $e');
      return false;
    } finally {
      isAcceptLoading.value = false;
    }
  }

// Method to clear form data after submission
  void clearDeliveryRequestForm() {
    descController.clear();
    selectedImages.clear();
    selectedFiles.clear();
  }

  // Update general order status
  Future<bool> updateGeneralOrderStatus(String orderId, String status) async {
    isAcceptLoading.value = true;
    try {
      final bool result = await generalOrderService.updateGeneralOrderStatus(orderId, status);
      // Refresh general orders after status update
      if (result) {
        await fetchGeneralOrders();
        Get.snackbar(
          'Success',
          'General order status updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update general order status: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isAcceptLoading.value = false;
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

      // Treat as expired only when deliveryTime is before now and more than 0 full days have passed.
      // If deliveryTime is before now but within the same day (inDays == 0) we'll fall through to the countdown block below.
      if (deliveryTime.isBefore(now) && now.difference(deliveryTime).inDays > 0) {
        yield "Expired";
        break; // stop the stream when delivered long ago
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
      fetchCustomOrders(isRefresh: true);
    } else {
      fetchGeneralOrders(isRefresh: true);
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

  // Find order by id (reactive lookup for details screen)
  dynamic findOrderById(String id, bool isCustom) {
    if (isCustom) {
      for (final o in customOrders) {
        if (o.id == id) return o;
      }
    } else {
      for (final g in generalOrders) {
        if (g.id == id) return g;
      }
    }
    return null;
  }

  // Helper method to get status from general tab name
  String? _getStatusFromGeneralTab(String tabName) {
    switch (tabName) {
      case 'All Orders':
        return null; // No status filter for "All Orders"
      case 'Pending':
        return OrderConstants.statusPending;
      case 'In-Progress':
        return OrderConstants.statusProcess; // Use 'process' for general orders
      case 'Delivered':
        return OrderConstants.statusDelivered;
      case 'Rejected':
        return OrderConstants.statusRejected;
      default:
        return null;
    }
  }

  // Helper method to get status from custom tab name
  String? _getStatusFromCustomTab(String tabName) {
    switch (tabName) {
      case 'Offers':
        return OrderConstants.statusOffered;
      case 'Accepted Offers':
        return OrderConstants.statusAccepted;
      case 'Delivery Requested':
        return OrderConstants.statusDeliveryRequested;
      case 'Delivered':
        return OrderConstants.statusDeliveryConfirmed;
      case 'Revision':
        return OrderConstants.statusRevision;
      case 'Cancelled':
        return OrderConstants.statusCancelled;
      default:
        return null;
    }
  }
}
