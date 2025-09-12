import 'package:get/get.dart';
import 'package:local/app/services/api_client.dart';
import 'package:local/app/services/app_url.dart';

mixin MixinCreateOrder {
  final items = 1.obs;
  final size = ''.obs;
  final color = ''.obs;



  Future<void> createOrder(
      {required vendorId,
      required clientId,
      required int price,
      required String ProductId,
      required int quantity,
      required String shippingAddress,
      required String sessionId}) async {
    try {
      final orderData = {
        "vendor": vendorId,
        "client": clientId,
        "price": price,
        "products": [
          {"productId": ProductId, "quantity": quantity}
        ],
        "paymentStatus": "paid",
        "shippingAddress": shippingAddress,
        "sessionId": sessionId
      };
      print(orderData); // Use the variable, or replace with your API call


      final response=await ApiClient.postData(ApiUrl.createGeneralOrder, orderData);
       print("Response: ${response.body}");

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Order created successfully: ${response.body}');
      } else {
        print('Failed to create order: ${response.statusCode} - ${response.body}');
      }

    
    } catch (e) {
      print('Error creating order: $e');
      rethrow; // Rethrow the error after logging it
    } finally {

      // Any cleanup code here
    }
  }
}
