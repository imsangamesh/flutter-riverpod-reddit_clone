import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/app_text_styles.dart';
import 'package:reddit/core/constants/colors.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/extensions/extensions.dart';
import 'package:reddit/core/theme/app_theme.dart';

class CustomDropdown extends ConsumerWidget {
  const CustomDropdown(
    this.selectedItem,
    this.items, {
    required this.setSelectedItem,
    super.key,
  });

  final String selectedItem;
  final List<String> items;
  final void Function(String item) setSelectedItem;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.listTile(ref.isDark),
        borderRadius: BorderRadius.circular(kBR),
      ),
      child: DropdownButton<String>(
        iconEnabledColor: AppTheme.primaryColor(ref.isDark),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
        borderRadius: BorderRadius.circular(kBR),
        underline: const SizedBox(),
        iconSize: 28,
        isExpanded: true,
        value: selectedItem,
        items: items
            .map(
              (e) => DropdownMenuItem<String>(
                value: e,
                child: Text(
                  e,
                  style: selectedItem == e
                      ? AppTStyles.primary(ref.isDark)
                      : AppTStyles.body,
                ),
              ),
            )
            .toList(),
        onChanged: (newVal) => setSelectedItem(newVal!),
      ),
    );
  }
}
