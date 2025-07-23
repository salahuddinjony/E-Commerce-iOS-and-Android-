import 'package:get/get.dart';

class InfoController extends GetxController{
  var selectedIndex = Rx<int?>(null);

// Toggle the selected FAQ item
  void toggleItem(int index) {
    selectedIndex.value = selectedIndex.value == index ? null : index;
  }




}