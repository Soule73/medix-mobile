import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medix/widgets/forms/form_input_field_decoration.dart';

class CustomDateFormField extends StatelessWidget {
  const CustomDateFormField({
    super.key,
    this.hintText,
    required this.label,
    this.helperText,
    this.onChanged,
    this.validator,
    this.initialValue,
  });

  final String? hintText;
  final String? helperText;
  final String label;
  final String? Function(DateTime?)? validator;
  final void Function(DateTime?)? onChanged;
  final DateTime? initialValue;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: DateTimeFormField(
            initialValue: initialValue,
            decoration: formInputFieldDecoration(
                helperText: helperText, hintText: hintText, label: Text(label)),
            validator: validator,
            lastDate: DateTime(DateTime.now().year - 18, DateTime.now().month,
                DateTime.now().day),
            dateFormat: DateFormat.yMd(),
            mode: DateTimeFieldPickerMode.date,
            onChanged: onChanged));
  }
}
