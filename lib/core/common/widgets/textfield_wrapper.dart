import 'package:flutter/material.dart';
import 'package:reddit/core/constants/colors.dart';

class TextFieldWrapper extends StatelessWidget {
  const TextFieldWrapper(
    this.widget, {
    this.icon,
    this.bottomPad,
    this.borderAlpha,
    super.key,
  });

  final Widget widget;
  final IconData? icon;
  final double? bottomPad;
  final int? borderAlpha;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPad ?? 15),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: AppColors.dListTile,
          borderRadius: BorderRadius.circular(15),
          border: borderAlpha != null
              ? Border.all(color: AppColors.dBorder, width: 1.5)
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) Icon(icon, color: AppColors.purple),
            const SizedBox(width: 5),
            Expanded(child: widget),
          ],
        ),
      ),
    );
  }
}
