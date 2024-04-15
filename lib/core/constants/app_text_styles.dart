// ignore_for_file: avoid_positional_boolean_parameters

import 'package:flutter/material.dart';
import 'package:reddit/core/constants/colors.dart';

class AppTStyles {
  AppTStyles._();

  static TextStyle heading = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const body = TextStyle(fontSize: 16);

  static const caption = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
  );

  static TextStyle themeBody(bool isDark) => TextStyle(
        fontSize: 16,
        color: isDark ? AppColors.white : AppColors.black,
      );

  static TextStyle primary(bool isDark) => TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.purple : AppColors.pink,
      );
}

/*
// 1 playfairDisplay
// 1 berkshireSwash
// 2 quicksand
// 3 zillaSlab - M

// amaticSc
*/
