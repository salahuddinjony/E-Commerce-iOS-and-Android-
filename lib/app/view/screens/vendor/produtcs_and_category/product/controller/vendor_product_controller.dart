import 'package:get/get.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';
import '../model/product.dart';

class VendorProductController extends GetxController{


  var userIndex= "product".obs;

  void toggleUserIndex({required String selectedIndex}) {
    userIndex.value = selectedIndex;
  }

    final List<Product> productsData = [
    Product(
      image: AppConstants.teeShirt,
      title: 'Party Mode Tee',
      subtitle: 'Top Rated Price',
      price: '\$22.20',
      sold: 'Sold (106)',
    ),
    Product(
      image: AppConstants.teeShirt,
      title: 'Guitar Soul Tee',
      subtitle: 'Top Rated Price',
      price: '\$22.20',
      sold: 'Sold (4.3k)',
    ),
    Product(
      image: AppConstants.teeShirt,
      title: 'Space Explorer',
      subtitle: 'Top Rated Price',
      price: '\$22.20',
      sold: 'Sold (1.7k)',
    ),
    Product(
      image: AppConstants.teeShirt,
      title: 'Party Mode Tee',
      subtitle: 'Top Rated Price',
      price: '\$22.20',
      sold: 'Sold (106)',
    ),
    Product(
      image: AppConstants.teeShirt,
      title: 'Guitar Soul Tee',
      subtitle: 'Top Rated Price',
      price: '\$22.20',
      sold: 'Sold (4.3k)',
    ),
    Product(
      image: AppConstants.teeShirt,
      title: 'Space Explorer',
      subtitle: 'Top Rated Price',
      price: '\$22.20',
      sold: 'Sold (1.7k)',
    ),
  ];


}
