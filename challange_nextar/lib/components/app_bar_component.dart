import 'dart:ui';

import 'package:challange_nextar/utils/styles.dart';
import 'package:flutter/material.dart';

class AppBarComponente extends StatelessWidget implements PreferredSizeWidget {
  final String isTitulo;
  final Widget? leading;
  final double appBarHeight;
  final bool? isVoltar;

  final List<Widget>? actions;

  const AppBarComponente({
    super.key,
    this.actions,
    this.leading,
    required this.isTitulo,
    this.appBarHeight = 55,
    this.isVoltar,
  });

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 10, sigmaX: 10),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
      titleTextStyle: titleStyle(),
      centerTitle: true,
      title: Text(isTitulo),
      automaticallyImplyLeading: false,
      elevation: 0,
      leading: isVoltar == true ? _buildLeading(context) : leading,
      actions: actions,
    );
  }

  Widget _buildLeading(context) {
    return IconButton(
        iconSize: 24,
        color: Colors.white,
        icon: const Icon(Icons.arrow_back_ios_new),
        onPressed: () {
          Navigator.pop(context, false);
        });
  }
}
