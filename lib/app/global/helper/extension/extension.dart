
import 'package:local/app/core/route_path.dart';



extension RouteBasePathExt on String {
  String get addBasePath {
    return RoutePath.basePath + this;
  }
}

extension StringCapitalization on String {
  
  String capitalizeFirstWord() {
    if (isEmpty) return this;
  return this[0].toUpperCase() + this.substring(1).toLowerCase();
  }
 
}

extension DateTimeConverter on String {

  String getDateTime() {
    final parsed = DateTime.tryParse(this);
    if (parsed == null) return this;

    final now = DateTime.now();
    final difference = now.difference(parsed);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}hr ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${parsed.day}/${parsed.month}/${parsed.year}';
    }
  }
}
