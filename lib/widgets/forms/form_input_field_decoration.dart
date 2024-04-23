import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';

InputDecoration formInputFieldDecoration(
    {String? hintText, String? helperText, Widget? label, Widget? suffixIcon}) {
  return InputDecoration(
      filled: true,
      suffixIcon: suffixIcon,
      fillColor:
          Get.theme.primaryColor.withOpacity(0.1), // Couleur de fond estompée
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(8.0)),
      errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: error),
          borderRadius: BorderRadius.circular(8.0)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary),
          borderRadius: BorderRadius.circular(8.0)),
      hintText: hintText,
      helperText: helperText,
      label: label);
}
