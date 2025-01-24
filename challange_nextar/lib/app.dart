import 'package:challange_nextar/routes/routes.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/utils/images.dart';
import 'package:challange_nextar/viewmodels/forgot_password_viewmodel.dart';
import 'package:challange_nextar/viewmodels/login_viewmodel.dart';
import 'package:challange_nextar/viewmodels/client_viewmodel.dart';
import 'package:challange_nextar/viewmodels/products_viewmodel.dart';
import 'package:challange_nextar/views/account/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      ],
      child: MaterialApp(
        title: 'Challenger Nextar',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Pages.generateRoute,
        home: AnimatedSplashScreen(
          splash: AppImages.splashGif,
          nextScreen: const LoginView(),
          splashIconSize: 1500,
          centered: true,
          duration: 2900,
        ),
        theme: ThemeData(
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
