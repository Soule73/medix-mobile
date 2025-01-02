import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';

Future<void> bottomSheet(
    {required BuildContext context,
    required Widget child,
    double height = 90}) {
  return showModalBottomSheet<void>(
      backgroundColor: Get.theme.canvasColor,
      barrierColor: primary.withAlpha((0.1 * 255).toInt()),
      context: context,
      builder: (BuildContext context) {
        return Container(
            width: double.infinity,
            height: height + 40,
            decoration: BoxDecoration(
                color: Get.theme.primaryColor.withAlpha((0.1 * 255).toInt()),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15))),
            margin: const EdgeInsets.only(bottom: 48.0),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                      child: Container(
                          height: 4,
                          width: Get.width / 4,
                          decoration: BoxDecoration(
                              color: Get.theme.primaryColor
                                  .withAlpha((0.7 * 255).toInt()),
                              borderRadius: BorderRadius.circular(5)))),
                  SizedBox(height: height, width: double.infinity, child: child)
                ]));
      });
}
