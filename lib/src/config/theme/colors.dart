// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

/// App color palette. These colors can and should be used to construct a custom Theme
class AppColor {
  final BuildContext context;
  AppColor(this.context);
  // Colores principales
  static const primary = Color(0xFF0D2B64); // Azul profundo (tu primario)
  static const secondary = Color(0xFFFFFFFF);
  static const unSelectedIcon = Colors.white;
  static const selectedIcon = Colors.yellow;

  static const celeste = Color.fromARGB(255, 105, 206, 231);

  static const blue = Color.fromARGB(255, 32, 71, 143);
  // Neutros y fondos
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF222222);
  static const grayLight = Color(0xFFF5F6F8);
  static const cardSlected = Color.fromARGB(255, 162, 195, 235);
  static const grey = Color(0xFF6B7280);
  static const background = Color.fromARGB(255, 255, 255, 255);
  static const card = Color(0xFFFFFFFF);
  static const border = Color(0xFFE0E0E0);

  // Estados
  static const success = Color(0xFF4F861A);
  static const warning = Color(0xFFFFB70A);
  static const error = Color(0xFFFF4D4F);
  static const info = Color(0xFF1890FF);

  // Acciones y acentos
  static const accent = Color(0xFFFFB70A); // Amarillo para botones/acento

  // Otros
  static const gold = Color.fromARGB(255, 231, 209, 82);
  static const silver = Color.fromARGB(255, 128, 127, 126);
  static const bronze = Color.fromARGB(255, 99, 25, 3);

  // Getters útiles para temas y componentes
  static Color get buttonPrimary => primary;
  static Color get buttonSecondary => secondary;
  static Color get buttonThree => error;

  static Color get buttonAccent => accent;
  static Color get buttonPrimaryText => white;
  static Color get buttonSecondaryText => white;
  static Color get buttonAccentText => black;

  static Color get appBarBackground => primary;
  static Color get appBarTitle => white;

  static Color get scaffoldBackground =>
      const Color.fromARGB(158, 231, 231, 231);
  static Color get cardBackground => const Color.fromARGB(255, 255, 255, 255);
  static Color get borderColor => border;

  static Color get iconPrimary => black;
  static Color get textSecondary => grey;
  static Color get textHint => cardSlected;

  static Color get divider => border;

  static const containerDark = Color(0xFF2B2B2B);
  static const scaffoldDark = Color.fromARGB(255, 22, 22, 22);
  // static const scaffoldDark = Color.fromARGB(255, 35, 34, 34);
  static const subContainerDark = Color.fromARGB(255, 37, 36, 36);
  static const textFieldDark = Color.fromARGB(255, 64, 64, 64);
  static const headerText = Color(0xFF2B3445);
  static const settingsTitleText = Color(0xFFA0A4AB);
  static const bodyText = Color(0xFF050315);
  // static const scaffold = Color.fromARGB(255, 233, 231, 231);

  static Color get buttonPrimaryDisable => primary.withOpacity(.30);

  static Color get buttonPrimaryTextDisable => white;

  static Color get dialogFullScreenBackground => white;

  static Color get placeholder => const Color.fromRGBO(129, 140, 153, 1.0);

  static Color get lightBackground => const Color.fromRGBO(248, 249, 250, 1);
  static Color get loginButtonColor => const Color.fromARGB(255, 19, 156, 190);

  static Color get darkBackground => const Color.fromARGB(255, 114, 43, 36);

  static Color get dangerBackground => const Color.fromRGBO(244, 220, 223, 1);
  static Color get loginBackground => Color(0x00F8F8F8);

  static Color get fieldBorder => primary;

  static Color get fieldBorderError => const Color.fromRGBO(220, 53, 69, 1);

  static Color get grayLightBT => const Color.fromRGBO(234, 234, 234, 1.0);

  static Color get lmFieldBackgroundDisable => grayLightBT;

  static Color get dmFieldBackgroundDisable =>
      const Color.fromARGB(255, 52, 52, 52);

  static Color get buttonTextSecondary =>
      const Color.fromRGBO(63, 138, 224, 1.0);
}

extension ColorSchemeExtension on ColorScheme {
  Color get success => brightness == Brightness.dark
      ? const Color(0xFF4CAF50) // Verde oscuro
      : const Color(0xFF2E7D32); // Verde claro

  Color get onSuccess =>
      brightness == Brightness.dark ? Colors.black : Colors.white;

  Color get warning => brightness == Brightness.dark
      ? const Color(0xFFFF9800) // Naranja oscuro
      : const Color(0xFFF57C00); // Naranja claro

  Color get onWarning => Colors.white;
}
