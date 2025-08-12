import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/services/app_url.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';

class ProductServices {
  static Future<bool> deleteProduct(String productId) async {
    try {
      // Get the authentication token
      final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
      
      if (token == null || token.isEmpty) {
        EasyLoading.showError('Authentication token is missing. Please log in again.');
        return false;
      }
      
      // Make the delete API call
      final response = await http.delete(
        Uri.parse('${ApiUrl.baseUrl}/product/delete/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      
      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Product deleted successfully');
        return true;
      } else {
        final responseBody = await response.body;
        final jsonResponse = jsonDecode(responseBody);
        final errorMessage = jsonResponse['message'] ?? 'Failed to delete product';
        EasyLoading.showError(errorMessage);
        return false;
      }
    } catch (e) {
      EasyLoading.showError('Error deleting product: $e');
      return false;
    } finally {
      EasyLoading.dismiss();
    }
  }
}
