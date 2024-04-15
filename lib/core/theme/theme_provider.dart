import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/services/providers.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, bool>(
  (ref) => ThemeNotifier(box: ref.watch(getStorageProvider)),
);

class ThemeNotifier extends StateNotifier<bool> {
  ThemeNotifier({
    required GetStorage box,
  })  : _box = box,
        super(false) {
    _setUp();
  }

  final GetStorage _box;

  void _setUp() {
    if (_box.read<bool>(BoxKeys.isDark) ?? true) {
      state = true;
    } else {
      state = false;
    }
    log(' - - - - - - THEME SetUp complete: $state - - - - - - ');
  }

  void toggleTheme() {
    if (state) {
      state = false;
      _box.write(BoxKeys.isDark, false);
    } else {
      state = true;
      _box.write(BoxKeys.isDark, true);
    }
  }
}
