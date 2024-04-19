import 'package:flutter/material.dart';
import 'package:medix/widgets/forms/form_input_field_decoration.dart';
import 'package:phone_form_field/phone_form_field.dart';

class CustomPhoneFormField extends StatelessWidget {
  const CustomPhoneFormField({
    super.key,
    this.controller,
    this.hintText,
    this.helperText,
    required this.label,
    this.validator,
    this.initialValue,
    this.onChanged,
  });

  final PhoneController? controller;
  final String? hintText;
  final String? helperText;
  final String label;
  final String? Function(PhoneNumber?)? validator;
  final String? initialValue;
  final dynamic Function(PhoneNumber)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: PhoneFormField(
          decoration: formInputFieldDecoration(
              helperText: helperText, hintText: hintText, label: Text(label)),
          controller: controller,
          validator: validator,
          countrySelectorNavigator: const CountrySelectorNavigator.bottomSheet(
              countries: [IsoCode.MR]),
          onChanged: onChanged,
          enabled: true,
          isCountrySelectionEnabled: false,
          isCountryButtonPersistent: true,
        ));
  }
}
