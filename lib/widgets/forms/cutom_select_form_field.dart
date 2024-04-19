import 'package:flutter/material.dart';
import 'package:medix/widgets/forms/form_input_field_decoration.dart';
import 'package:select_form_field/select_form_field.dart';

class CustomSelectFormField extends StatelessWidget {
  const CustomSelectFormField({
    super.key,
    this.controller,
    required this.label,
    this.hintText,
    this.items,
    this.initialValue,
    this.validator,
    this.type,
  });

  final TextEditingController? controller;
  final String label;
  final String? hintText;
  final List<Map<String, dynamic>>? items;
  final String? initialValue;
  final String? Function(String?)? validator;
  final SelectFormFieldType? type;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: SelectFormField(
          controller: controller,
          type: type ?? SelectFormFieldType.dialog, // or can be dialog
          initialValue: initialValue,
          items: items,
          validator: validator,
          decoration:
              formInputFieldDecoration(hintText: hintText, label: Text(label)),
        ));
  }
}
