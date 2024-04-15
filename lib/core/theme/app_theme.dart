// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:reddit/core/constants/app_text_styles.dart';
import 'package:reddit/core/constants/colors.dart';

class AppTheme {
  AppTheme._();

  /// ---------------------------------------------------------- `COLORS`

  static Color normalColor(bool isDark) =>
      isDark ? AppColors.white : AppColors.black;

  static Color primaryColor(bool isDark) =>
      isDark ? AppColors.purple : AppColors.pink;

  static Color midPrimary(bool isDark) =>
      isDark ? AppColors.midPurple : AppColors.midPink;

  static Color scaffoldBGColor(bool isDark) =>
      isDark ? AppColors.dScaffoldBG : AppColors.lScaffoldBG;

  static Color listTileColor(bool isDark) =>
      isDark ? AppColors.dListTile : AppColors.lListTile;

  static Color borderColor(bool isDark) =>
      isDark ? AppColors.dBorder : AppColors.lBorder;

  static Color iconColor(bool isDark) =>
      isDark ? AppColors.dIcon : AppColors.lIcon;

  /// ---------------------------------------------------------- `CORE WIDGETS`

  static AppBarTheme appBarTheme([bool isDark = false]) {
    return const AppBarTheme().copyWith(
      iconTheme: IconThemeData(color: primaryColor(isDark), size: 24),
      titleTextStyle: TextStyle(
        color: primaryColor(isDark),
        fontSize: 19,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0,
    );
  }

  static BottomSheetThemeData bottomSheet([bool isDark = false]) {
    return const BottomSheetThemeData().copyWith(
      modalBackgroundColor: scaffoldBGColor(isDark),
    );
  }

  static DrawerThemeData drawer([bool isDark = false]) {
    return const DrawerThemeData().copyWith(
      backgroundColor: scaffoldBGColor(isDark),
    );
  }

  static FloatingActionButtonThemeData floatingActionButton([
    bool isDark = false,
  ]) {
    return const FloatingActionButtonThemeData().copyWith(
      backgroundColor: isDark ? AppColors.purple : AppColors.pink,
      iconSize: 30,
    );
  }

  /// ---------------------------------------------------------- `BUTTONS`

  static ElevatedButtonThemeData elevatedButton([bool isDark = false]) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        foregroundColor: scaffoldBGColor(isDark),
        disabledForegroundColor: primaryColor(isDark),
        backgroundColor: primaryColor(isDark),
        disabledBackgroundColor: primaryColor(isDark).withAlpha(100),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData outlinedButton([bool isDark = false]) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        foregroundColor: primaryColor(isDark),
        disabledForegroundColor: primaryColor(isDark).withAlpha(150),
        backgroundColor: primaryColor(isDark).withAlpha(50),
        disabledBackgroundColor: primaryColor(isDark).withAlpha(25),
        textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: BorderSide(color: primaryColor(isDark), width: 1.5),
      ),
    );
  }

  static TextButtonThemeData textButton([bool isDark = false]) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        foregroundColor: primaryColor(isDark),
        disabledForegroundColor: primaryColor(isDark).withAlpha(150),
        textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  static ToggleButtonsThemeData toggleButton([bool isDark = false]) {
    return ToggleButtonsThemeData(
      selectedColor: primaryColor(isDark),
      color: normalColor(isDark),
      borderColor: primaryColor(isDark).withAlpha(100),
      selectedBorderColor: primaryColor(isDark),
      borderRadius: BorderRadius.circular(16),
      textStyle: AppTStyles.primary(isDark),
    );
  }

  /// ---------------------------------------------------------- `LIST TILES`

  static ListTileThemeData listTile([bool isDark = false]) {
    return const ListTileThemeData().copyWith(
      tileColor: listTileColor(isDark),
      contentPadding: const EdgeInsets.fromLTRB(17, 1, 5, 1),
      titleTextStyle: AppTStyles.themeBody(isDark),
      iconColor: primaryColor(isDark),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
  }

  /// ---------------------------------------------------------- `TEXTFIELD`

  static InputDecorationTheme inputDecorationTheme([bool isDark = false]) {
    return const InputDecorationTheme().copyWith(
      labelStyle: TextStyle(color: primaryColor(isDark), fontSize: 15),
      counterStyle: TextStyle(color: midPrimary(isDark)),
      suffixIconColor: primaryColor(isDark),
      prefixIconColor: primaryColor(isDark),
      filled: true,
      fillColor: listTileColor(isDark),
      contentPadding: const EdgeInsets.all(18),
      alignLabelWithHint: true,
      //
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.transparent, width: 0),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor(isDark), width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  /// ---------------------------------------------------------- `OTHERS`

  static IconThemeData iconTheme([bool isDark = false]) {
    return const IconThemeData().copyWith(
      color: primaryColor(isDark),
      size: 28,
    );
  }

  static DividerThemeData dividerTheme([bool isDark = false]) {
    return const DividerThemeData().copyWith(
      color: primaryColor(isDark).withAlpha(50),
      space: 25,
      indent: 10,
      endIndent: 10,
    );
  }

  static ProgressIndicatorThemeData progressIndicator([bool isDark = false]) {
    return ProgressIndicatorThemeData(
      color: primaryColor(isDark),
      circularTrackColor: scaffoldBGColor(isDark),
    );
  }

  // ============================== LIGHT ==============================
  // ============================== LIGHT ==============================

  static ThemeData get light {
    return ThemeData.light().copyWith(
      /// -------------------------------------- `CORE`
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.pink),
      splashColor: AppColors.lSplash,
      scaffoldBackgroundColor: AppColors.lScaffoldBG,

      /// -------------------------------------- `CORE WIDGETS`
      appBarTheme: appBarTheme(),
      floatingActionButtonTheme: floatingActionButton(),
      drawerTheme: drawer(),
      bottomSheetTheme: bottomSheet(),

      /// -------------------------------------- `BUTTONS`
      elevatedButtonTheme: elevatedButton(),
      outlinedButtonTheme: outlinedButton(),
      textButtonTheme: textButton(),
      toggleButtonsTheme: toggleButton(),

      /// -------------------------------------- `LISTTILES`
      listTileTheme: listTile(),

      /// -------------------------------------- `TEXTFIELD`
      inputDecorationTheme: inputDecorationTheme(),

      /// -------------------------------------- `OTHERS`
      iconTheme: iconTheme(),
      dividerTheme: dividerTheme(),
      progressIndicatorTheme: progressIndicator(),
    );
  }

  // ============================== DARK ==============================
  // ============================== DARK ==============================

  static ThemeData get dark {
    return ThemeData.dark().copyWith(
      /// -------------------------------------- `CORE`
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.purple),
      splashColor: AppColors.dSplash,
      scaffoldBackgroundColor: AppColors.dScaffoldBG,

      /// -------------------------------------- `CORE WIDGETS`
      appBarTheme: appBarTheme(true),
      floatingActionButtonTheme: floatingActionButton(true),
      drawerTheme: drawer(true),
      bottomSheetTheme: bottomSheet(true),

      /// -------------------------------------- `BUTTONS`
      elevatedButtonTheme: elevatedButton(true),
      outlinedButtonTheme: outlinedButton(true),
      textButtonTheme: textButton(true),
      toggleButtonsTheme: toggleButton(true),

      /// -------------------------------------- `LISTTILES`
      listTileTheme: listTile(true),

      /// -------------------------------------- `TEXTFIELD`
      inputDecorationTheme: inputDecorationTheme(true),

      /// -------------------------------------- `OTHERS`
      iconTheme: iconTheme(true),
      dividerTheme: dividerTheme(true),
      progressIndicatorTheme: progressIndicator(true),
    );
  }
}
