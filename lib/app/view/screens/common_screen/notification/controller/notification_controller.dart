import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/local/shared_prefs.dart';
import '../../../../../utils/app_constants/app_constants.dart';
import '../../../../../utils/enums/status.dart';
import '../mixin/notification_mixin.dart';
import '../model/notification_model.dart';

class NotificationController extends GetxController with NotificationMixin {
  
  // Consumer ID - will be loaded from shared preferences
  String? consumerId;

  @override
  void onInit() {
    super.onInit();
    // Load user ID and then load notifications
    _loadUserIdAndNotifications();
  }

  Future<void> _loadUserIdAndNotifications() async {
    try {
      // Get user ID from shared preferences
      consumerId = await SharePrefsHelper.getString(AppConstants.id);
      debugPrint("Retrieved user ID from shared preferences: '$consumerId'");
      
      if (consumerId != null && consumerId!.isNotEmpty) {
        debugPrint("Loading notifications for user ID: $consumerId");
        // Load notifications when controller initializes
        await getNotifications(consumerId: consumerId!);
        
        // Add dummy notifications for testing
        _addDummyNotifications();
      } else {
        debugPrint("No user ID found in shared preferences");
        setRxRequestStatus(Status.error);
      }
    } catch (e) {
      debugPrint("Error loading user ID: $e");
      setRxRequestStatus(Status.error);
    }
  }

  // Add dummy notifications for testing
  void _addDummyNotifications() {
    final dummyNotifications = [
      NotificationData(
        content: NotificationContent(
          source: NotificationSource(type: "order"),
          title: "New Order Received",
          message: "You have received a new order #ORD-2024-001 for 5 custom t-shirts",
        ),
        id: "dummy_1",
        consumer: consumerId,
        isDismissed: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
        v: 0,
      ),
      NotificationData(
        content: NotificationContent(
          source: NotificationSource(type: "payment"),
          title: "Payment Successful",
          message: "Payment of \$150.00 has been processed successfully for order #ORD-2024-002",
        ),
        id: "dummy_2",
        consumer: consumerId,
        isDismissed: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
        v: 0,
      ),
      NotificationData(
        content: NotificationContent(
          source: NotificationSource(type: "delivery"),
          title: "Order Shipped",
          message: "Your order #ORD-2024-003 has been shipped and is on its way to you",
        ),
        id: "dummy_3",
        consumer: consumerId,
        isDismissed: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        v: 0,
      ),
    ];

    // Add dummy notifications to the list
    notificationList.addAll(dummyNotifications);
    debugPrint("Added ${dummyNotifications.length} dummy notifications");
  }



  // Method to refresh notifications
  void refreshNotificationsList() {
    if (consumerId != null && consumerId!.isNotEmpty) {
      getNotifications(consumerId: consumerId!);
    }
  }

  // Method to dismiss a specific notification
  void dismissNotificationById(String notificationId) {
    dismissNotification(notificationId: notificationId);
  }

  // Method to clear all notifications
  void clearAllNotificationsForConsumer() {
    if (consumerId != null && consumerId!.isNotEmpty) {
      clearAllNotifications(consumerId: consumerId!);
    }
  }

  // Method to reload dummy notifications for testing
  void reloadDummyNotifications() {
    notificationList.clear();
    _addDummyNotifications();
  }
}
