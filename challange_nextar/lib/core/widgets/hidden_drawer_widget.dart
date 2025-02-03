import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/styles.dart';
import 'package:challange_nextar/views/pages_drawer/client_view/client_view.dart';
import 'package:challange_nextar/views/pages_drawer/home_view/home_view.dart';
import 'package:challange_nextar/views/pages_drawer/my_account_data_view/my_account_view.dart';
import 'package:challange_nextar/views/pages_drawer/products_view/product_view.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

class HiddenDrawerComponent extends StatefulWidget {
  const HiddenDrawerComponent({super.key});

  @override
  State<HiddenDrawerComponent> createState() => _HiddenDrawerComponentState();
}

class _HiddenDrawerComponentState extends State<HiddenDrawerComponent> {
  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Início',
          baseStyle: drawerMenuStyle(),
          selectedStyle: drawerMenuSelectedStyle(),
          colorLineSelected: AppColors.primary2,
        ),
        HomeView(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Produtos',
          baseStyle: drawerMenuStyle(),
          selectedStyle: drawerMenuSelectedStyle(),
          colorLineSelected: AppColors.primary2,
        ),
        const ProductView(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Clientes',
          baseStyle: drawerMenuStyle(),
          selectedStyle: drawerMenuSelectedStyle(),
          colorLineSelected: AppColors.primary2,
        ),
        const ClientView(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Minha conta',
          baseStyle: drawerMenuStyle(),
          selectedStyle: drawerMenuSelectedStyle(),
          colorLineSelected: AppColors.primary2,
        ),
        const MyAccountView(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: AppColors.primary.withAlpha(155),
      backgroundColorAppBar: AppColors.primary,
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 40,
      elevationAppBar: 0,
      styleAutoTittleName: titleStyle(),
      isTitleCentered: true,
    );
  }
}
