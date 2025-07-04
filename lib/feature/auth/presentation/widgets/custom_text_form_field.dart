import 'package:flutter/material.dart';
import 'package:prone/core/extensions/color_extension.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onEditingComplete;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged; // onChanged parametresi eklendi

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.validator,
    this.obscureText = false,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.onEditingComplete,
    this.focusNode,
    this.textInputAction,
    this.onChanged, // Constructor'a eklendi
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(color: theme.colorScheme.onSurfaceVariant),
        hintStyle: TextStyle(
          color: theme.colorScheme.onSurfaceVariant.withOpacityD(0.7),
        ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withOpacityD(0.5),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withOpacityD(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
        ),
        filled: true,
        fillColor: theme
            .colorScheme
            .surfaceContainerLowest, // Daha açık bir arka plan için
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
      ),
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
      onEditingComplete: onEditingComplete,
      focusNode: focusNode,
      textInputAction: textInputAction,
      onChanged: onChanged, // onChanged eklendi
    );
  }
}
