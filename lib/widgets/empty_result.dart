import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';

Widget buildEmptyResult(
    {String? title, String? subTitle, double height = 300}) {
  return Center(
      child: Column(children: [
    SizedBox(
        width: (Get.width / 3) * 2,
        height: height,
        child: SvgPicture.asset('assets/icons/taken_empty.svg')),
    Text(title ?? 'empty-result'.tr,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28.0),
      child: Text(subTitle ?? "",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w300)),
    )
  ]));
}

Widget buildLoadingIndicator({double height = 300}) {
  return SizedBox(
      width: Get.width,
      height: height,
      child: Center(child: CircularProgressIndicator(color: primary)));
}
