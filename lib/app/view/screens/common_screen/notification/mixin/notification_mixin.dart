import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../global/helper/toast_message/toast_message.dart';
import '../../../../../services/api_check.dart';
import '../../../../../services/api_client.dart';
import '../../../../../services/app_url.dart';
import '../../../../../utils/enums/status.dart';
import '../model/notification_model.dart';

mixin NotificationMixin on GetxController {
  final Rx<Status> rxRequestStatus = Status.loading.obs;
  final RxList<NotificationData> notificationList = <NotificationData>[].obs;
  final RxBool isDismissing = false.obs;
  final RxBool isClearing = false.obs;

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  // Get notifications for a specific consumer
  Future<void> getNotifications({required String consumerId}) async {
    setRxRequestStatus(Status.loading);

    final url = ApiUrl.getNotifications(consumerId: consumerId);
    debugPrint("Fetching notifications from: $url");
    
    var response = await ApiClient.getData(url);

    debugPrint("Response status: ${response.statusCode}");
    debugPrint("Response body: ${response.body}");

    if (response.statusCode == 200) {
      try {
        final notificationModel = NotificationModel.fromJson(response.body);
        notificationList.value = notificationModel.data ?? [];
        setRxRequestStatus(Status.completed);
        debugPrint("Notifications loaded: ${notificationList.length}");
      } catch (e) {
        debugPrint("Error parsing notifications: $e");
        setRxRequestStatus(Status.error);
      }
    } else {
      if (response.statusText == ApiClient.noInternetMessage) {
        setRxRequestStatus(Status.internetError);
      } else {
        setRxRequestStatus(Status.error);
      }
      ApiChecker.checkApi(response);
    }
  }

  // Dismiss a specific notification
  Future<void> dismissNotification({required String notificationId}) async {
    isDismissing.value = true;
    
    var response = await ApiClient.patchData(
      ApiUrl.dismissNotification(notificationId: notificationId),
      jsonEncode({}),
    );

    if (response.statusCode == 200) {
      try {
        final dismissResponse = NotificationDismissResponse.fromJson(response.body);
        toastMessage(message: dismissResponse.message ?? "Notification dismissed successfully");
        
        // Remove the dismissed notification from the list
        notificationList.removeWhere((notification) => notification.id == notificationId);
      } catch (e) {
        debugPrint("Error parsing dismiss response: $e");
        toastMessage(message: "Notification dismissed successfully");
      }
    } else {
      if (response.statusText == ApiClient.noInternetMessage) {
        toastMessage(message: "No internet connection");
      } else {
        ApiChecker.checkApi(response);
      }
    }
    
    isDismissing.value = false;
  }

  // Clear all notifications for a consumer
  Future<void> clearAllNotifications({required String consumerId}) async {
    isClearing.value = true;
    
    var response = await ApiClient.deleteData(
      ApiUrl.clearAllNotifications(consumerId: consumerId),
    );

    if (response.statusCode == 200) {
      try {
        final clearResponse = NotificationClearResponse.fromJson(response.body);
        toastMessage(message: clearResponse.message ?? "All notifications cleared successfully");
        
        // Clear the notification list
        notificationList.clear();
      } catch (e) {
        debugPrint("Error parsing clear response: $e");
        toastMessage(message: "All notifications cleared successfully");
      }
    } else {
      if (response.statusText == ApiClient.noInternetMessage) {
        toastMessage(message: "No internet connection");
      } else {
        ApiChecker.checkApi(response);
      }
    }
    
    isClearing.value = false;
  }

  // Refresh the notifications list
  void refreshNotifications({required String consumerId}) {
    getNotifications(consumerId: consumerId);
  }
}
