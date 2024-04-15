// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // static final isDark = theme.isDark;

  static Color prim(bool isDark) => isDark ? purple : pink;
  // static Color get mid => isDark ? midPurple : midPink;
  // static Color get dark => isDark ? darkPurple : darkPink;

  static const pink = Color(0xffFF8FB1);
  static const purple = Color(0xffBA94D1);

  // ---------------------------- `COLOR VERSIONS`

  static const midPink = Color(0xFFEC407A);
  static const midPurple = Color(0xff7A4495);
  static const darkPink = Color(0xffde004a);
  static const darkPurple = Color(0xff18142c);

  // ---------------------------- `OTHERS`

  static const white = Color(0xffcccccc);
  static const black = Color(0xFF444444);
  static const transparent = Colors.transparent;

  static const lGrey = Colors.grey;
  static const dGrey = Colors.grey;

  static const success = Color(0xFF00A005);
  static const danger = Color(0xffde004a);

  // ---------------------------- `CORE`

  static const lSplash = Color(0x95FF8FB1);
  static const dSplash = Color(0x63BA94D1);

  // ---------------------------- `WIDGETS`

  /// `Scaffold`
  static const lScaffoldBG = Color(0xFFFFFBF3);
  static const dScaffoldBG = Color(0xFF03071B);

  /// `ListTile`
  static Color listTile(bool isDark) => isDark ? dListTile : lListTile;
  static const lListTile = Color(0xFFFFE2EA);
  static const dListTile = Color(0x18BA94D1);

  /// `Icons`
  static const lIcon = Color(0xFFEC407A);
  static const dIcon = Color(0xff7A4495);

  /// `Border`
  static Color border(bool isDark) => isDark ? dBorder : lBorder;
  static const lBorder = Color(0xFFEC407A);
  static const dBorder = Color(0xff7A4495);

  // ---------------------------- `OTHER COLORS`

  // static const grey = Color(0xFFAAAAAA);
  // static const midGrey = Color(0xFF5A5A5A);
  // static const greySmoke = Color(0xDCFFFFFF);

  // static const orangePink = Color(0xffFEBEB1);
  // static const emerald = Color(0xff647E68);
  // static const wheat = Color(0xffF2DEBA);

  // static Color prim([int a = 255]) =>
  //     isDark ? AppColors.purple.withAlpha(a) : AppColors.pink.withAlpha(a);
}
