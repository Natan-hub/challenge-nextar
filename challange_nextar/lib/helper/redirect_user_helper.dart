import 'package:challange_nextar/core/widgets/shimmer_loading_widget.dart';
import 'package:challange_nextar/routes/routes.dart';
import 'package:challange_nextar/viewmodels/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RedirectUserHelper extends StatefulWidget {
  const RedirectUserHelper({super.key});

  @override
  State<RedirectUserHelper> createState() => _RedirectUserHelperState();
}

class _RedirectUserHelperState extends State<RedirectUserHelper> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;
      _checkLoginStatus();
    }
  }

  Future<void> _checkLoginStatus() async {
    final loginViewModel = context.read<LoginViewModel>();
    await loginViewModel.loadCurrentUser();

    if (mounted) {
      if (loginViewModel.currentUser != null) {
        Navigator.pushReplacementNamed(context, Routes.hiddenDrawer);
      } else {
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: shimerColor(context),
      ),
    );
  }
}
