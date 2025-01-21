import 'package:challange_nextar/components/hidden_drawer_component.dart';
import 'package:challange_nextar/routes/pages.dart';
import 'package:flutter/material.dart';

class Pages {
  static Route generateRoute(RouteSettings settings) {
    final routeName = settings.name;

    switch (routeName) {
      case Routes.hiddenDrawer:
        return MaterialPageRoute(
          builder: (context) => const HiddenDrawerComponent(),
        );
        
      default:
        return MaterialPageRoute(
          builder: (context) => const Placeholder(),
        );
    }
  }
}
