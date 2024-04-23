import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/controllers/auth/reset_password_controller.dart';
import 'package:medix/layouts/registe_layout.dart';
import 'package:medix/widgets/boutons/button.dart';
import 'package:medix/widgets/forms/custom_phone_form_field.dart';
import 'package:medix/widgets/large_icon_gradiant.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});

  final Auth auth = Get.find<Auth>();
  final ResetPasswordController resetPasswordController =
      Get.put(ResetPasswordController());
  @override
  Widget build(BuildContext context) {
    return RegisterLayout(
        division: 2,
        page: 0,
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(children: [
                  LargeIconWithGradiant(
                      icon: FontAwesomeIcons.phone,
                      colors: [Colors.blue[200]!, Colors.blue[700]!]),
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text("reset-your-password".tr,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600))),
                  CustomPhoneFormField(
                      label: 'phone-number'.tr,
                      controller: resetPasswordController.userPhoneNumber,
                      onChanged: (phoneNumber) =>
                          _validePhoneNumber(phoneNumber, context)),
                  Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Obx(() => FadeBtn(
                          title: 'next'.tr,
                          isLoad: resetPasswordController.isLoading.value,
                          color:
                              resetPasswordController.phoneNumberIsvalid.value
                                  ? primary
                                  : Get.theme.dividerColor,
                          onPressed:
                              resetPasswordController.phoneNumberIsvalid.value
                                  ? () => resetPasswordController.sendOTP()
                                  : null)))
                ]))));
  }

  _validePhoneNumber(phoneNumber, context) {
    int nsn = phoneNumber.nsn.length;
    String nsnString = phoneNumber.nsn.toString();

    if (nsn == 8 &&
        (nsnString.startsWith("2") ||
            nsnString.startsWith("3") ||
            nsnString.startsWith("4"))) {
      resetPasswordController.phoneNumberIsvalid.value = true;
      FocusScope.of(context).unfocus();
    } else {
      resetPasswordController.phoneNumberIsvalid.value = false;
    }
  }
}
