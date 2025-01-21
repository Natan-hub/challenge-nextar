import 'package:challange_nextar/routes/pages.dart';
import 'package:flutter/material.dart';

class Pages {
  static Route generateRoute(RouteSettings settings) {
    final routeName = settings.name;

    switch (routeName) {
      case Routes.init:
        return MaterialPageRoute(
          builder: (context) => const Placeholder(),
        );
        
      default:
        return MaterialPageRoute(
          builder: (context) => const Placeholder(),
        );
    }
  }
}
