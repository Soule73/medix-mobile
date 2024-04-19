import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/layouts/registe_layout.dart';
import 'package:medix/widgets/forms/pin_put_code.dart';

class VerifyPhoneNumberScreen extends StatelessWidget {
  const VerifyPhoneNumberScreen(
      {super.key,
      required this.verificationId,
      required this.onCompleted,
      this.controller,
      required this.reSend,
      this.otpVerifyPending = false,
      this.title});
  final String verificationId;
  final void Function() reSend;
  final String? title;
  final bool otpVerifyPending;

  final void Function(String) onCompleted;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return RegisterLayout(
        division: 2,
        page: 1,
        child: otpVerifyPending
            ? SizedBox(
                width: Get.width,
                height: Get.height / 2,
                child: Center(child: CircularProgressIndicator(color: primary)))
            : PinPutCode(
                title: title,
                onCompleted: onCompleted,
                controller: controller,
                reSend: reSend));
  }
}
