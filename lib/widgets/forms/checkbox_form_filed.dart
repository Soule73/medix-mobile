import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart' as color;

class CheckBoxFormFieldWithErrorMessage extends FormField<bool> {
  final String labelText;
  final bool isChecked;
  final String error;
  final void Function(bool?) onChanged;

  CheckBoxFormFieldWithErrorMessage({
    super.key,
    required this.labelText,
    required this.isChecked,
    required this.onChanged,
    required super.validator,
    required this.error,
  }) : super(
            initialValue: isChecked,
            builder: (FormFieldState<bool> state) {
              return Column(children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(
                              value: isChecked,
                              onChanged: onChanged,
                              isError: true,
                              checkColor: Get.theme.primaryColor,
                              fillColor:
                                  MaterialStateColor.resolveWith((states) {
                                return states.contains(MaterialState.selected)
                                    ? color.success
                                    : Get.theme.canvasColor;
                              })),
                          Expanded(
                              child: Text(labelText.tr,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400)))
                        ])),
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          constraints: const BoxConstraints(minHeight: 16.0),
                          padding: const EdgeInsets.only(left: 20, right: 10),
                          child: Text((error.isNotEmpty) ? ' * $error' : '',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w400,
                                  color: color.error)))
                    ])
              ]);
            });
}
