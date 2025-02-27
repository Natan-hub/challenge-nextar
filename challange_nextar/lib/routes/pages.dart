import 'package:challange_nextar/core/widgets/hidden_drawer_widget.dart';
import 'package:challange_nextar/models/product_model.dart';
import 'package:challange_nextar/routes/routes.dart';
import 'package:challange_nextar/views/account/login_view.dart';
import 'package:challange_nextar/views/pages_drawer/products_view/details_product_view.dart';
import 'package:challange_nextar/views/pages_drawer/products_view/edit_add_product_view.dart';
import 'package:challange_nextar/views/pages_drawer/home_view/select_product_view.dart';
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

      case Routes.editAddProduct:
        final arguments = settings.arguments;
        final ProductModel? product =
            arguments != null && arguments is Map<String, dynamic>
                ? arguments['product'] as ProductModel?
                : null;
        return MaterialPageRoute(
          builder: (context) => EditProductView(
            product: product,
          ),
        );

      case Routes.selectedProduct:
        return MaterialPageRoute(
          builder: (context) => const SelecetedProductView(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => const Placeholder(),
        );
    }
  }
}
