import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:local/app/core/route_path.dart';

class OrdersController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  var isCustomOrder = false.obs; // toggle state

  final List<String> generalTabs = [
    'All Orders',
    'Pending',
    'Completed',
    'Rejected'
  ];
  final List<String> customTabs = [
    'Pending',
    'In Progress',
    'Completed',
    'Cancelled'
  ];

  List<String> get tabs => isCustomOrder.value ? customTabs : generalTabs;

  final List<Map<String, String>> pendingCustomOrders = [
    {
      'name': 'Custom Order 1',
      'parcelId': '#111111',
      'orderNumber': '901',
      'locationLine1': 'Custom Street',
      'locationLine2': 'Custom City',
      'imageUrl': 'https://i.pravatar.cc/150?img=4'
    },
  ];

  final List<Map<String, String>> pendingGeneralOrders = [
    {
      'name': 'General Order 1',
      'parcelId': '#222222',
      'orderNumber': '902',
      'locationLine1': 'General Street',
      'locationLine2': 'General City',
      'imageUrl': 'https://i.pravatar.cc/150?img=5'
    },
  ];

  List<Map<String, String>> get pendingOrders =>
      isCustomOrder.value ? pendingCustomOrders : pendingGeneralOrders;

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
  }

  void onPendingOrderTap(BuildContext context) {
    context.pushNamed(RoutePath.pendingDetailsScreen);
  }
}
