import 'package:get/get.dart';
import 'package:local/app/view/screens/features/client/chat/inbox/controller/mixin_create_or_retrive_conversation.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/category/services/category_services.dart';
import 'package:local/app/view/screens/features/vendor/products_and_category/product/services/product_services.dart';


class ShopDetailsController extends GetxController with CategoryServices, ProductServices, MixinCreateOrRetrieveConversation {



  @override
  void onInit() {
    // fetchCategories(vendorId: Get.parameters['vendorId']);
    // fetchProducts();
    super.onInit();
  }

  @override
  void onClose() {
   
    super.onClose();
  }
}