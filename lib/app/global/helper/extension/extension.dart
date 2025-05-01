
import 'package:local/app/core/route_path.dart';



extension RouteBasePathExt on String {
  String get addBasePath {
    return RoutePath.basePath + this;
  }
}

