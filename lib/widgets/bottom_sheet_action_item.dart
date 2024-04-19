import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

Widget bottomSheetActionItem(
    {required IconData icon,
    required String text,
    required Function onTap,
    Color? color}) {
  return GestureDetector(
      onTap: () {
        Get.back();
        onTap.call();
      },
      child: Row(children: [
        FaIcon(icon, color: color),
        const SizedBox(width: 15),
        Text(text,
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 16, color: color))
      ]));
}

Widget buildLoadingIndicatorSmall({Color? color}) {
  return SizedBox(
      width: 25,
      height: 25,
      child: CircularProgressIndicator(strokeWidth: 2, color: color));
}
