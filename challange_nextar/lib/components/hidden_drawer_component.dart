import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/utils/styles.dart';
import 'package:challange_nextar/views/base_view.dart';
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
          name: 'Home',
          baseStyle: drawerMenuStyle(),
          selectedStyle: drawerMenuSelectedStyle(),
          colorLineSelected: AppColors.primary2,
        ),
        BaseView(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Minha conta',
          baseStyle: drawerMenuStyle(),
          selectedStyle: drawerMenuSelectedStyle(),
          colorLineSelected: AppColors.primary2,
        ),
        Placeholder(),
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
