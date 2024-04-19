import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';

Widget buildEmptyResult({double height = 300}) {
  return Center(
      child: Column(children: [
    SizedBox(
        width: (Get.width / 3) * 2,
        height: height,
        child: SvgPicture.asset('assets/icons/taken_empty.svg')),
    Text('empty-result'.tr,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600))
  ]));
}

Widget buildLoadingIndicator({double height = 300}) {
  return SizedBox(
      width: Get.width,
      height: height,
      child: Center(child: CircularProgressIndicator(color: primary)));
}
