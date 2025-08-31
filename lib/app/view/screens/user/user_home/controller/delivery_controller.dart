import 'package:get/get.dart';

class MixInDelivery extends GetxController {
  // For map
  final RxString latitude = ''.obs;
  final RxString longitude = ''.obs;
  RxString address = 'Pick Delivery Location'.obs;
}
