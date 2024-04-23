import 'package:flutter/material.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/widgets/forms/form_input_field_decoration.dart';

class FadedTextField extends StatelessWidget {
  const FadedTextField({
    super.key,
    this.controller,
    this.hintText,
    this.label,
    this.validator,
    this.initialValue,
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.minLines,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? label;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final int? minLines;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
          minLines: minLines,
          keyboardType: keyboardType,
          obscureText: obscureText ?? false,
          cursorColor: primary,
          cursorErrorColor: error,
          initialValue: initialValue,
          validator: validator,
          controller: controller,
          decoration: formInputFieldDecoration(
              suffixIcon: suffixIcon,
              hintText: hintText,
              label: Text('$label')),
        ));
  }
}
