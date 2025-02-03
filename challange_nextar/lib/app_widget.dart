import 'package:challange_nextar/helper/redirect_user_helper.dart';
import 'package:challange_nextar/routes/pages.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:challange_nextar/core/theme/colors.dart';
import 'package:challange_nextar/core/theme/images.dart';
import 'package:challange_nextar/viewmodels/edit_add_product_viewmodel.dart';
import 'package:challange_nextar/viewmodels/forgot_password_viewmodel.dart';
import 'package:challange_nextar/viewmodels/home_viewmodel.dart';
import 'package:challange_nextar/viewmodels/login_viewmodel.dart';
import 'package:challange_nextar/viewmodels/client_viewmodel.dart';
import 'package:challange_nextar/viewmodels/products_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ForgotPasswordViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => EditAddProductViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Challenger Nextar',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Pages.generateRoute,
        home: AnimatedSplashScreen(
          splash: AppImages.splashGif,
          nextScreen: const RedirectUserHelper(),
          splashIconSize: 1000,
          centered: true,
          duration: 1500,
        ),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          useMaterial3: false,
          primaryColor: AppColors.primary,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.primary,
          ),
          dividerTheme: const DividerThemeData(color: Colors.black),
        ),
      ),
    );
  }
}
