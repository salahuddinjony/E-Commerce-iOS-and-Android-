import 'package:get/get.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';

class UserOrderController extends GetxController {
  final RxList<Map<String, dynamic>> myOrders = <Map<String, dynamic>>[
    {
      'image': AppConstants.demoImage,
      'title': 'Guitar Soul Tee',
      'subtitle': 'Supreme Soft Cotton',
      'description':
          'These T-shirts are popular for their unique design and high-quality fabric. Pick your favorite now!',
      'isActive': true,
    },
    {
      'image': AppConstants.demoImage,
      'title': 'Vintage Rock Tee',
      'subtitle': 'Classic Cotton',
      'description': 'A classic vintage rock tee, a must-have for all rock fans.',
      'isActive': false,
    },
  ].obs;

  final RxList<Map<String, dynamic>> extendDateRequests = <Map<String, dynamic>>[
    {
      'image': AppConstants.demoImage,
      'title': 'Extended Guitar Soul Tee',
      'subtitle': 'Extended Soft Cotton',
      'description': 'Extension request sent for this order.',
      'requestedDays': 5,
      'isAccepted': false,
    },
    {
      'image': AppConstants.demoImage,
      'title': 'Extended Rock Tee',
      'subtitle': 'Extended Soft Cotton',
      'description': 'Extension date request.',
      'requestedDays': 3,
      'isAccepted': false,
    },
  ].obs;

  void acceptRequest(int index) {
    if (index < 0 || index >= extendDateRequests.length) return;
    final item = Map<String, dynamic>.from(extendDateRequests[index]);
    item['isAccepted'] = true;
    // replace the item to trigger listeners
    extendDateRequests[index] = item;
  }
}
