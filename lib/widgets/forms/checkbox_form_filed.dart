import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart' as color;

class CheckBoxFormFieldWithErrorMessage extends FormField<bool> {
  final Widget label;
  final bool isChecked;
  final String error;
  final void Function(bool?) onChanged;

  CheckBoxFormFieldWithErrorMessage(
      {super.key,
      required this.label,
      required this.isChecked,
      required this.onChanged,
      required super.validator,
      required this.error,
      void Function()? labelOnTap})
      : super(
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
                              fillColor: WidgetStateColor.resolveWith((states) {
                                return states.contains(WidgetState.selected)
                                    ? color.success
                                    : Get.theme.canvasColor;
                              })),
                          Expanded(
                              child: GestureDetector(
                            onTap: labelOnTap,
                            child: label,
                          )),
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
