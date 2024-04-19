import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/controllers/auth/register_controler.dart';

class UserAvatar extends StatelessWidget {
  UserAvatar({
    super.key,
    this.color,
  });

  final Auth auth = Get.find<Auth>();
  final RegisterController registerController = Get.find<RegisterController>();
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
                width: 150,
                height: 150,
                child: Obx(() => registerController.image.value == null
                    ? CircleAvatar(
                        child: ClipOval(
                            child: SvgPicture.asset('assets/icons/avatar.svg',
                                fit: BoxFit.scaleDown)))
                    : CircleAvatar(
                        backgroundColor: color ?? Get.theme.primaryColor,
                        child: ClipOval(
                            child: Image.file(
                                fit: BoxFit.cover,
                                File(registerController
                                    .image.value!.path))))))));
  }
}
