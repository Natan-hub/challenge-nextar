import 'package:challange_nextar/components/hidden_drawer_component.dart';
import 'package:challange_nextar/models/product_model.dart';
import 'package:challange_nextar/routes/pages.dart';
import 'package:challange_nextar/views/account/login_view.dart';
import 'package:challange_nextar/views/details_product.dart';
import 'package:challange_nextar/views/pages_drawer/edit_product.dart';
import 'package:flutter/material.dart';

class Pages {
  static Route generateRoute(RouteSettings settings) {
    final routeName = settings.name;

    switch (routeName) {
      case Routes.hiddenDrawer:
        return MaterialPageRoute(
          builder: (context) => const HiddenDrawerComponent(),
        );

      case Routes.login:
        return MaterialPageRoute(
          builder: (context) => const LoginView(),
        );

      case Routes.detailsProduct:
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        final ProductModel product = arguments['product'];
        return MaterialPageRoute(
          builder: (context) => DetailsProduct(
            product: product,
          ),
        );

      case Routes.editProduct:
        final Map<String, dynamic> arguments =
            settings.arguments as Map<String, dynamic>;
        final ProductModel product = arguments['product'];
        return MaterialPageRoute(
          builder: (context) => EditProductView(
            product: product,
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Placeholder(),
        );
    }
  }
}
