import 'package:local/app/data/local/shared_prefs.dart';
import 'package:local/app/utils/app_constants/app_constants.dart';

class AuthHelper {
  /// Check if user is authenticated (has a valid token)
  static Future<bool> isAuthenticated() async {
    final token = await SharePrefsHelper.getString(AppConstants.bearerToken);
    return token.isNotEmpty;
  }
}

