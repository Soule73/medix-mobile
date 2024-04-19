import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/auth/reset_password_controller.dart';
import 'package:medix/layouts/registe_layout.dart';
import 'package:medix/utils/form_validation.dart';
import 'package:medix/widgets/boutons/button.dart';
import 'package:medix/widgets/forms/faded_text_form_field.dart';
import 'package:medix/widgets/forms/icon_obscure_icon.dart';
import 'package:medix/widgets/large_icon_gradiant.dart';

class ResetPasswordObscure extends GetxController {
  RxBool passWordObscure = true.obs;
  RxBool passWordConfirmObscure = true.obs;

  void setPassWordObscure() {
    passWordObscure.value = !passWordObscure.value;
  }

  void setPassWordConfirmObscure() {
    passWordConfirmObscure.value = !passWordConfirmObscure.value;
  }
}

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  final ResetPasswordController resetPasswordController =
      Get.put(ResetPasswordController());
  final ResetPasswordObscure obscureText = Get.put(ResetPasswordObscure());
  @override
  Widget build(BuildContext context) {
    return RegisterLayout(
        division: 2,
        page: 2,
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      LargeIconWithGradiant(
                          colors: [Colors.blue[200]!, Colors.blue[700]!],
                          icon: FontAwesomeIcons.lock),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 18.0),
                          child: Text("new-password".tr,
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w600))),
                      Obx(() => FadedTextField(
                          label: 'new-password'.tr,
                          validator: validPassword,
                          controller: resetPasswordController.userPassword,
                          obscureText: obscureText.passWordObscure.value,
                          suffixIcon: GestureDetector(
                              onTap: obscureText.setPassWordObscure,
                              child: obscureIcon(
                                  context: context,
                                  isObscure:
                                      obscureText.passWordObscure.value)))),
                      Obx(() => FadedTextField(
                          label: 'confirm-password'.tr,
                          validator: (value) {
                            return validPassworddConfirm(
                                value: value,
                                compare:
                                    resetPasswordController.userPassword.text);
                          },
                          controller:
                              resetPasswordController.userPasswordConfirm,
                          obscureText: obscureText.passWordConfirmObscure.value,
                          suffixIcon: GestureDetector(
                              onTap: obscureText.setPassWordConfirmObscure,
                              child: obscureIcon(
                                  context: context,
                                  isObscure: obscureText
                                      .passWordConfirmObscure.value)))),
                      Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Obx(() => OutlinedBtn(
                              title: 'update'.tr,
                              onPressed: _validAndSubmitForm,
                              isLoad: resetPasswordController.isLoading.value)))
                    ])))));
  }

  void _validAndSubmitForm() {
    if (_formKey.currentState!.validate()) {
      resetPasswordController.resetUserPassword();
    }
  }
}
