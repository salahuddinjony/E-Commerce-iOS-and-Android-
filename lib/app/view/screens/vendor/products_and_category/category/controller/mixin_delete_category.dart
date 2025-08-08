import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:local/app/services/app_url.dart';

mixin class DeleteCategoryMixin {
  Future<void> deleteCategory(String categoryId) async {
    EasyLoading.show(status: 'Deleting category...');

    try {
      // Call the categoryDelete function with categoryId
      final url = ApiUrl.categoryDelete(categoryId: categoryId);
      print('Constructed URL: $url');
      final response = await http.delete(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        
        },
      );

      if (response.statusCode == 200) {
        EasyLoading.showSuccess('Category deleted successfully');
        print("Category deleted successfully: ${response.body}");
      } else {
        EasyLoading.showError('Failed to delete category: ${response.statusCode}');
        print("Failed to delete category: ${response.body}");
        print('Status code: ${response.statusCode}');
      }
    } catch (error) {
      print("Failed to delete category: $error");
      if (error is http.ClientException) {
        print("Network error: $error");
      } else if (error is FormatException) {
        print("URI format error: $error");
      }
      EasyLoading.showError('Failed to delete category: $error');
    } finally {
      EasyLoading.dismiss();
    }
  }
}