import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/local/shared_prefs.dart';
import '../../../../../utils/app_constants/app_constants.dart';
import '../../../../../utils/enums/status.dart';
import '../mixin/notification_mixin.dart';

class NotificationController extends GetxController with NotificationMixin {
  
  // Consumer ID - will be loaded from shared preferences
  String? consumerId;

  @override
  void onInit() {
    super.onInit();
    // Load user ID and then load notifications
    loadUserIdAndNotifications();
  }

  Future<void> loadUserIdAndNotifications() async {
    try {
      // Get user ID from shared preferences
      consumerId = await SharePrefsHelper.getString(AppConstants.id);
      debugPrint("Retrieved user ID from shared preferences: '$consumerId'");
      
      if (consumerId != null && consumerId!.isNotEmpty) {
        debugPrint("Loading notifications for user ID: $consumerId");
        // Load notifications when controller initializes
        await getNotifications(consumerId: consumerId!);
        
        // Add dummy notifications for testing
        // _addDummyNotifications(); // Commented out for production
      } else {
        debugPrint("No user ID found in shared preferences");
        setRxRequestStatus(Status.error);
      }
    } catch (e) {
      debugPrint("Error loading user ID: $e");
      setRxRequestStatus(Status.error);
    }
  }



  // Method to refresh notifications
  void refreshNotificationsList() {
    if (consumerId != null && consumerId!.isNotEmpty) {
      getNotifications(consumerId: consumerId!);
    }
  }

  // Method to dismiss a specific notification and then re-fetch from backend
  Future<void> dismissNotificationById(String notificationId) async {
    await dismissNotification(notificationId: notificationId);
    if (consumerId != null && consumerId!.isNotEmpty) {
      await getNotifications(consumerId: consumerId!);
    }
  }

  // Method to clear all notifications
  void clearAllNotificationsForConsumer() {
    if (consumerId != null && consumerId!.isNotEmpty) {
      clearAllNotifications(consumerId: consumerId!);
    }
  }

  // Method to reload dummy notifications for testing
  // void reloadDummyNotifications() {
  //   notificationList.clear();
  //   _addDummyNotifications();
  // }
}
