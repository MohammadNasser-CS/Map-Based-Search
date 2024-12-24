import 'package:flutter/material.dart';
import 'package:map_based_search/core/utils/app_color.dart';
import 'package:map_based_search/features/bottom_navbar/bottom_navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Map App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColor.white,
        scaffoldBackgroundColor: AppColor.grey1,
        appBarTheme: const AppBarTheme(
            backgroundColor: AppColor.white, scrolledUnderElevation: 0),
        useMaterial3: true,
        inputDecorationTheme: _buildInputDecorationTheme(),
      ),
      home: const CustomBottomNavbar(),
    );
  }
}

InputDecorationTheme _buildInputDecorationTheme() {
  return InputDecorationTheme(
    fillColor: AppColor.grey1,
    filled: true,
    border: _buildOutlineInputBorder(AppColor.grey1),
    enabledBorder: _buildOutlineInputBorder(AppColor.grey1),
    focusedBorder: _buildOutlineInputBorder(AppColor.grey1),
    disabledBorder: _buildOutlineInputBorder(AppColor.grey1),
    errorBorder: _buildOutlineInputBorder(AppColor.red),
    focusedErrorBorder: _buildOutlineInputBorder(AppColor.red),
  );
}

/// Reusable method for creating consistent border styles.
OutlineInputBorder _buildOutlineInputBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(32.0),
    borderSide: BorderSide(color: color),
  );
}
