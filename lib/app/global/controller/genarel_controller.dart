import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GeneralController extends GetxController {
  //================= Image ==========

  RxString image = "".obs;
  Rx<File> imageFile = File("").obs;
  bool isImagePickerActive = false;

  selectImage() async {
    if (isImagePickerActive) {
      return;
    }

    try {
      isImagePickerActive = true;
      final ImagePicker picker = ImagePicker();
      final XFile? getImages = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 15,
      );

      if (getImages != null) {
        imageFile.value = File(getImages.path);
        image.value = getImages.path;
        debugPrint("Selected Image Path: ${getImages.path}");

      }
    } catch (e) {
      debugPrint("Error selecting image: $e");
    } finally {
      isImagePickerActive = false;
    }
  }

  // Method to clear the image
  clearImage() {
    image.value = ""; // Clears the image path
    imageFile.value = File(""); // Clears the image file
  }




}
