import 'package:get/get.dart';

class VendorProductController extends GetxController{


  var userIndex= "product".obs;

  void toggleUserIndex({required String selectedIndex}) {
    userIndex.value = selectedIndex;
  }

}