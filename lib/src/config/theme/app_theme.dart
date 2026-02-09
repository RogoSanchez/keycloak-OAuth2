import 'package:flutter/material.dart';
import 'package:keycloack_integrations/src/config/theme/app_style.dart';
import 'package:keycloack_integrations/src/config/theme/colors.dart';

class AppTheme {
  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.amber,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColor.appBarTitle),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 2,
        backgroundColor: AppColor.primary,
        titleTextStyle: AppTextStyle().appBarTitle,
      
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      scaffoldBackgroundColor: AppColor.background,
      cardTheme: const CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.white),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.white),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.white),
        ),
        outlineBorder: BorderSide(color: AppColor.white),

        fillColor: Colors.white,
        filled: true,
        prefixIconColor: AppColor.primary,
      ),

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColor.primary,
        surface: AppColor.background,
        error: AppColor.warning,
      ),
    );
  }
}
