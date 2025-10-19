import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../data/local/shared_prefs.dart';
import '../../../../../../../services/api_check.dart';
import '../../../../../../../utils/app_constants/app_constants.dart';
import '../../../../../../../utils/enums/status.dart';
import '../model/support_model.dart';
import '../services/support_service.dart';

class SupportController extends GetxController {
  final Rx<Status> rxRequestStatus = Status.loading.obs;
  final RxBool isSending = false.obs;
  
  final Rx<SupportModel> supportModel = SupportModel().obs;
  final Rx<SupportThread?> supportThread = Rx<SupportThread?>(null);
  
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  
  String userId = '';

  void setRxRequestStatus(Status value) => rxRequestStatus.value = value;

  @override
  void onInit() {
    super.onInit();
    getUserId();
  }

  /// Get user ID from shared preferences
  Future<void> getUserId() async {
    userId = await SharePrefsHelper.getString(AppConstants.userId);
    if (userId.isNotEmpty) {
      await getAllSupportMessages();
    }
  }

  /// Fetch all support threads
  Future<void> getAllSupportMessages() async {
    setRxRequestStatus(Status.loading);
    
    try {
      final response = await SupportService.getAllSupportThreads(userId: userId);
      
      if (response.statusCode == 200) {
        supportModel.value = SupportModel.fromJson(response.body);
        
        if (supportModel.value.data != null) {
          supportThread.value = supportModel.value.data!;
        }
        
        setRxRequestStatus(Status.completed);
      } else {
        ApiChecker.checkApi(response);
        setRxRequestStatus(Status.error);
      }
    } catch (e) {
      debugPrint('Error fetching support messages: $e');
      setRxRequestStatus(Status.error);
    }
  }

  /// Send a new support message
  Future<void> sendSupportMessage() async {
    if (subjectController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a subject',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    
    if (messageController.text.trim().isEmpty) {
      Get.snackbar('Error', 'Please enter a message',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isSending.value = true;

    try {
      final response = await SupportService.sendSupportMessage(
        userId: userId,
        subject: subjectController.text.trim(),
        message: messageController.text.trim(),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', 'Support message sent successfully',
            snackPosition: SnackPosition.BOTTOM);
        
        // Clear the input fields
        subjectController.clear();
        messageController.clear();
        
        // Refresh the support threads
        await getAllSupportMessages();
      } else {
        ApiChecker.checkApi(response);
      }
    } catch (e) {
      debugPrint('Error sending support message: $e');
      Get.snackbar('Error', 'Failed to send message',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isSending.value = false;
    }
  }

  @override
  void onClose() {
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
