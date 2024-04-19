import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/auth/register_controler.dart';
import 'package:medix/layouts/registe_layout.dart';
import 'package:medix/utils/form_validation.dart';
import 'package:medix/widgets/boutons/button.dart';
import 'package:medix/widgets/forms/custom_date_form_field.dart';
import 'package:medix/widgets/forms/cutom_select_form_field.dart';
import 'package:medix/widgets/forms/faded_text_form_field.dart';
import 'package:medix/widgets/forms/file_upload.dart';
import 'package:medix/widgets/forms/icon_obscure_icon.dart';
import 'package:medix/widgets/user_avatar.dart';
import 'package:select_form_field/select_form_field.dart';

class RegisterObscure extends GetxController {
  RxBool passWordObscure = true.obs;
  RxBool passWordConfirmObscure = true.obs;
  void setPassWordObscure() {
    passWordObscure.value = !passWordObscure.value;
  }

  void setPassWordConfirmObscure() {
    passWordConfirmObscure.value = !passWordConfirmObscure.value;
  }
}

class UserInformationsScreen extends StatelessWidget {
  UserInformationsScreen({super.key});
  final RegisterController registerController = Get.find<RegisterController>();
  final _formKey = GlobalKey<FormState>();

  final RegisterObscure obscureText = Get.put(RegisterObscure());

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> userSex = [
      {
        'value': 'M',
        'label': 'man'.tr,
      },
      {
        'value': 'F',
        'label': 'woman'.tr,
      },
    ];
    List<Map<String, dynamic>> city = [
      {
        'value': 1,
        'label': 'Nouakchott'.tr,
      },
      {
        'value': 2,
        'label': 'Nouadhibou'.tr,
      },
      {
        'value': 3,
        'label': 'Rosso'.tr,
      },
      {
        'value': 4,
        'label': 'Boghé'.tr,
      },
      {
        'value': 5,
        'label': 'Kiffa'.tr,
      },
      {
        'value': 6,
        'label': 'Zouerate'.tr,
      },
      {
        'value': 7,
        'label': 'Kaédi'.tr,
      },
      {
        'value': 8,
        'label': 'Boutilimit'.tr,
      },
      {
        'value': 9,
        'label': 'Atar'.tr,
      },
      {
        'value': 10,
        'label': 'Sélibaby'.tr,
      },
      {
        'value': 11,
        'label': 'Aleg'.tr,
      },
      {
        'value': 12,
        'label': 'Akjoujt'.tr,
      },
      {
        'value': 13,
        'label': 'Tidjikja'.tr,
      },
    ];

    return RegisterLayout(
        division: 2,
        page: 2,
        child: Column(children: [
          Text("your-informations".tr, style: const TextStyle(fontSize: 18)),
          UserAvatar(),
          Transform.translate(
              offset: const Offset(40, -25),
              child: UploadProfileImage(onSelectFile: (File file) {
                registerController.image.value = file;
              })),
          Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadedTextField(
                        controller: registerController.userFirstName,
                        hintText: "enter-your-firstname".tr,
                        label: "firstname".tr,
                        validator: validFisrtName),
                    FadedTextField(
                        controller: registerController.userLastName,
                        hintText: "enter-your-last-name".tr,
                        label: "last-name".tr,
                        validator: validLastName),
                    CustomDateFormField(
                        onChanged: (date) =>
                            registerController.userBirthday.value = date,
                        label: "birthday".tr,
                        hintText: "your-birthday".tr,
                        helperText: birthdayHelperText(),
                        validator: validBirthay),
                    Obx(() => FadedTextField(
                        controller: registerController.userPassword,
                        hintText: "password".tr,
                        label: "your-password".tr,
                        validator: validPassword,
                        obscureText: obscureText.passWordObscure.value,
                        suffixIcon: GestureDetector(
                            onTap: obscureText.setPassWordObscure,
                            child: obscureIcon(
                                context: context,
                                isObscure:
                                    obscureText.passWordObscure.value)))),
                    Obx(() => FadedTextField(
                        controller: registerController.userPasswordConfirm,
                        hintText: "confirm-password".tr,
                        label: "confirm-password".tr,
                        validator: validPasswordConfirm,
                        obscureText: obscureText.passWordConfirmObscure.value,
                        suffixIcon: GestureDetector(
                            onTap: obscureText.setPassWordConfirmObscure,
                            child: obscureIcon(
                                context: context,
                                isObscure: obscureText
                                    .passWordConfirmObscure.value)))),
                    CustomSelectFormField(
                        label: 'gender'.tr,
                        controller: registerController.userSex,
                        type: SelectFormFieldType.dropdown,
                        items: userSex,
                        validator: validUserSex),
                    CustomSelectFormField(
                        label: 'city'.tr,
                        controller: registerController.userCity,
                        type: SelectFormFieldType.dialog,
                        items: city,
                        validator: validCity),
                    Center(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: Obx(() => FadeBtn(
                                title: 'create-your-account'.tr,
                                isLoad: registerController.isLoading.value,
                                width: (Get.width / 4) * 3,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    registerController.registerr();
                                  }
                                }))))
                  ]))
        ]));
  }

  String? validPasswordConfirm(value) {
    if (value == null || value.isEmpty) {
      return "confirm-password".tr;
    }
    if (value != registerController.userPassword.text) {
      return "password-not-match".tr;
    }
    return null;
  }
}
