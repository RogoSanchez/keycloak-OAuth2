import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keycloack_integrations/src/config/theme/colors.dart';

class AppTextStyle {
  static final fontFamily = "Poppins";
  // static final fontFamily = GoogleFonts.averiaLibre().fontFamily;
  static const secondaryFontFamily = 'Montserrat';
  static const thirdFontFamily = 'JackRollDemoRegular';

  // Custom text theme overriding material 3 properties.
  // This class has few implemented styles and by default is not applied to the theme.

  /// Base Text Style
  static final _default = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    textBaseline: TextBaseline.alphabetic,
  );
  TextStyle get appBarTitle => _default.copyWith(
    fontSize: 20.h,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
    height: 1.3,
    color: AppColor.appBarTitle,
  );

  /// Display Text Style
  TextStyle get display => _default.copyWith(
    fontSize: 57,
    fontWeight: FontWeight.bold,
    height: 1.12,
    letterSpacing: -0.25,
  );
  TextStyle get emptyData =>
      _default.copyWith(fontWeight: FontWeight.w400, letterSpacing: -0.25);

  TextStyle get drawerUsername => _default.copyWith(
    fontSize: 25,
    fontWeight: FontWeight.w400,
    height: 1.12,
    letterSpacing: -0.25,
  );

  TextStyle get snackBar => _default.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
  );

  TextStyle get onboardTitle => _default.copyWith(
    fontSize: 40,
    fontWeight: FontWeight.w600,
    letterSpacing: -.8,
    height: 1.15,
    fontFamily: fontFamily,
  );

  TextStyle get onboardSubTitle =>
      _default.copyWith(fontSize: 20, fontWeight: FontWeight.w400, height: 1.3);

  TextStyle get tableTitle => _default.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0,
    // height: 1.3,
  );

  TextStyle get tabBarSelected => _default.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: AppColor.primary,
    letterSpacing: 0,
    height: 1.3,
  );

  TextStyle get tabBarUnselected => _default.copyWith(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: Colors.white,
    letterSpacing: 0,
    height: 1.3,
  );

  TextStyle get frostButton => const TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 12,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  TextStyle get primaryButtonLeading => _default.copyWith(
    fontSize: 15,
    letterSpacing: -.2,
    fontWeight: FontWeight.w500,
    height: .9,
  );

  TextStyle get primaryButtonTrailing => _default.copyWith(
    fontSize: 14,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  );

  TextStyle get profilePublication => _default.copyWith(
    fontSize: 12,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  );
  TextStyle get textPublication => _default.copyWith(
    fontSize: 12,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );
  TextStyle get textButton => _default.copyWith(
    fontSize: 12,
    letterSpacing: 0,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  TextStyle get likesAndChat => _default.copyWith(
    fontSize: 14,
    letterSpacing: 0,
    color: Colors.grey,
    fontWeight: FontWeight.w500,
  );

  TextStyle get dialogTitle => _default.copyWith(
    fontSize: 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  );

  TextStyle get petDetailsName => _default.copyWith(
    fontSize: 24,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  );

  TextStyle get petDetailsBreed => _default.copyWith(
    fontSize: 14,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  TextStyle get petDetailsDescription => _default.copyWith(
    fontSize: 14,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
    color: Colors.grey,
  );

  TextStyle get matchTime => _default.copyWith(
    fontSize: 30,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
  );

  TextStyle get newsTitle => _default.copyWith(
    fontSize: 17,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  TextStyle get time => _default.copyWith(
    fontSize: 13,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  TextStyle get squadName => _default.copyWith(
    fontSize: 17,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
  );

  TextStyle get tournamentStatsPlayerTitle => _default.copyWith(
    fontSize: 17,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  TextStyle get tournamentResults => _default.copyWith(
    fontSize: 16,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
  );

  TextStyle get matchResult => _default.copyWith(
    fontSize: 30,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
  );

  TextStyle get matchStatus => _default.copyWith(
    fontSize: 12,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
    color: Colors.grey,
  );

  TextStyle get dateTimeMatch => _default.copyWith(
    fontSize: 14,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  );

  TextStyle get matchSummaryEvent => _default.copyWith(
    fontSize: 13,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  );

  TextStyle get datePicker => _default.copyWith(
    fontSize: 12,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  );

  TextStyle get sliverAppBar => _default.copyWith(
    fontSize: 16,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  TextStyle get bottomSheetTitle => _default.copyWith(
    fontSize: 18,
    letterSpacing: 0,
    fontWeight: FontWeight.w500,
  );

  TextStyle get profileSectionTitle => _default.copyWith(
    fontSize: 15,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
  );

  TextStyle get subscriptionPrice => _default.copyWith(
    fontSize: 15,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
  );

  TextStyle get teamMatch => _default.copyWith(
    fontSize: 16,
    letterSpacing: 0,
    fontWeight: FontWeight.bold,
  );
}
