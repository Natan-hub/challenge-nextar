import 'package:challange_nextar/components/hidden_drawer_component.dart';
import 'package:challange_nextar/routes/routes.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:challange_nextar/viewmodels/account_viewmodel/forgot_password_viewmodel.dart';
import 'package:challange_nextar/viewmodels/account_viewmodel/login_viewmodel.dart';
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
      ],
      child: MaterialApp(
        title: 'Challenger Nextar',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Pages.generateRoute,
        home: const HiddenDrawerComponent(),
        theme: ThemeData(
          useMaterial3: false,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            centerTitle: true,
          ),
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
