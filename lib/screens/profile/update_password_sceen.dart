import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/controllers/auth/update_password_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/utils/form_validation.dart';
import 'package:medix/widgets/boutons/button.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:medix/widgets/forms/faded_text_form_field.dart';
import 'package:medix/widgets/forms/icon_obscure_icon.dart';
import 'package:medix/widgets/large_icon_gradiant.dart';

class UpdatePasswordObscure extends GetxController {
  RxBool passWordObscure = true.obs;
  RxBool passWordConfirmObscure = true.obs;
  RxBool currentpassWordObscure = true.obs;

  void setPassWordObscure() {
    passWordObscure.value = !passWordObscure.value;
  }

  void setPassWordConfirmObscure() {
    passWordConfirmObscure.value = !passWordConfirmObscure.value;
  }

  void setCurrentpassWordObscure() {
    currentpassWordObscure.value = !currentpassWordObscure.value;
  }
}

class UpdatePasswordScreen extends StatelessWidget {
  UpdatePasswordScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  final UpdatePasswordController passwordController =
      Get.put(UpdatePasswordController());
  final UpdatePasswordObscure obscureText = Get.put(UpdatePasswordObscure());
  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        actions: const [],
        leading: const BackBtn(),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      LargeIconWithGradiant(
                          colors: [Colors.blue[200]!, Colors.blue[700]!],
                          icon: FontAwesomeIcons.lock),
                      Obx(() => FadedTextField(
                          label: 'current-password'.tr,
                          validator: validPassword,
                          obscureText: obscureText.currentpassWordObscure.value,
                          controller: passwordController.userCurrentPassword,
                          suffixIcon: GestureDetector(
                              onTap: obscureText.setCurrentpassWordObscure,
                              child: obscureIcon(
                                  context: context,
                                  isObscure: obscureText
                                      .currentpassWordObscure.value)))),
                      Obx(() => FadedTextField(
                          label: 'new-password'.tr,
                          validator: validPassword,
                          controller: passwordController.userPassword,
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
                                compare: passwordController.userPassword.text);
                          },
                          controller: passwordController.userPasswordConfirm,
                          obscureText: obscureText.passWordConfirmObscure.value,
                          suffixIcon: GestureDetector(
                              onTap: obscureText.setCurrentpassWordObscure,
                              child: obscureIcon(
                                  context: context,
                                  isObscure: obscureText
                                      .passWordConfirmObscure.value)))),
                      Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Obx(() => OutlinedBtn(
                              title: 'update'.tr,
                              onPressed: _validFormAndSubmit,
                              isLoad: Get.find<Auth>().isLoading.value)))
                    ])))),
        title: "edit-password".tr);
  }

  void _validFormAndSubmit() {
    if (_formKey.currentState!.validate()) {
      passwordController.updatePassword();
    }
  }
}
