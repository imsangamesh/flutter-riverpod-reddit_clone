import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit/core/constants/colors.dart';
import 'package:reddit/core/constants/constants.dart';
import 'package:reddit/core/extensions/extensions.dart';

class CustomTextField extends ConsumerWidget {
  const CustomTextField(
    this.controller,
    this.label, {
    this.maxLines = 1,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixFun,
    this.inputType,
    this.maxLength,
    this.radius,
    this.onSubmit,
    this.bottomPadding,
    this.autoFocus = false,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final int? maxLines;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType? inputType;
  final VoidCallback? suffixFun;
  final int? maxLength;
  final double? radius;
  final bool autoFocus;
  final VoidCallback? onSubmit;
  final double? bottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding ?? 15),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        maxLength: maxLength,
        autofocus: autoFocus,
        style: const TextStyle(fontSize: 16),
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        keyboardType: inputType ?? TextInputType.text,
        cursorColor: AppColors.purple,
        //
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          suffixIcon: suffixIcon != null
              ? IconButton(onPressed: suffixFun, icon: Icon(suffixIcon))
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: AppColors.transparent, width: 0),
            borderRadius: BorderRadius.circular(radius ?? kBR),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.prim(ref.isDark), width: 2),
            borderRadius: BorderRadius.circular(radius ?? kBR),
          ),
        ),
        //
        onSubmitted: onSubmit == null ? null : (_) => onSubmit!(),
      ),
    );
  }
}
