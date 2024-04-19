import 'package:flutter/material.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/widgets/forms/form_input_field_decoration.dart';

class FadedTextereaField extends StatelessWidget {
  const FadedTextereaField({
    super.key,
    this.controller,
    this.hintText,
    this.label,
    this.validator,
    this.initialValue,
    this.suffixIcon,
    this.prefixIcon,
    this.keyboardType,
    this.minLines,
    this.maxLines,
  });

  final TextEditingController? controller;
  final String? hintText;
  final String? label;
  final String? Function(String?)? validator;
  final String? initialValue;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: TextFormField(
            minLines: minLines,
            maxLines: maxLines,
            keyboardType: keyboardType,
            cursorColor: primary,
            cursorErrorColor: error,
            initialValue: initialValue,
            validator: validator,
            controller: controller,
            decoration: formInputFieldDecoration(
                hintText: hintText, label: Text('$label'))));
  }
}
