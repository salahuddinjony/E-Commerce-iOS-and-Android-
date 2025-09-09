import 'package:get/get.dart';
import 'package:local/app/view/screens/features/vendor/orders/mixins/general_order_mixin.dart';
import 'package:local/app/view/screens/features/vendor/orders/mixins/order_mixin.dart';
import 'package:local/app/view/screens/features/vendor/orders/services/custom_order_service.dart';
import 'package:local/app/view/screens/features/vendor/orders/services/general_order_service.dart';

class UserOrderController extends GetxController with GeneralOrderMixin, OrderMixin {


  //Create instances of services
  final CustomOrderService customerOrderService = CustomOrderService();
  final GeneralOrderService generalOrderService = GeneralOrderService();

  RxInt totalCustomOrder = 0.obs;
  RxInt totalGeneralOrder = 0.obs;

    // Fetch custom orders from API
  Future<void> fetchCustomOrders() async {
    try {
      isLoading.value = true;
      isError.value = false;

      final response = await customerOrderService.fetchVendorOrders();
      totalCustomOrder.value = response.data.meta.total;
      processOrderResponse(response);
     print("Total Custom Orders: ${totalCustomOrder.value}");
     print("Custom Orders: ${customOrders.length}");

    } catch (e) {
      isLoading.value = false;
      isError.value = true;
      errorMessage.value = e.toString();
    }
  }

  // Fetch general orders from API
  Future<void> fetchGeneralOrders() async {
    try {
      isGeneralOrdersLoading.value = true;
      isGeneralOrdersError.value = false;

      final response = await generalOrderService.fetchGeneralOrders();
      totalGeneralOrder.value = response.data.meta.total;
      processGeneralOrderResponse(response);
    } catch (e) {
      isGeneralOrdersLoading.value = false;
      isGeneralOrdersError.value = true;
      generalOrdersErrorMessage.value = e.toString();
    }
  }

    // Fetch all orders (both custom and general)
  Future<void> fetchAllOrders() async {
    await Future.wait([
      fetchCustomOrders(),
      fetchGeneralOrders(),
    ]);
  }

  @override
  void onInit(){
    print("UserOrderController initialized");
    super.onInit();
    fetchCustomOrders();
  }

  @override
  void onClose() {
    super.onClose();
  }
 
}