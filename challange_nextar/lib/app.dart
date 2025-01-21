import 'package:challange_nextar/routes/routes.dart';
import 'package:challange_nextar/utils/colors.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Challenger Nextar',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Pages.generateRoute,
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
    );
  }
}
