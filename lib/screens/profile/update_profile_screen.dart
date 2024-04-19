import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/controllers/auth/update_profile_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/utils/form_validation.dart';
import 'package:medix/widgets/boutons/button.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:medix/widgets/forms/custom_date_form_field.dart';
import 'package:medix/widgets/forms/cutom_select_form_field.dart';
import 'package:medix/widgets/forms/faded_text_form_field.dart';
import 'package:select_form_field/select_form_field.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});
  final _formKey = GlobalKey<FormState>();

  final UpdateProfileController updateProfileController =
      Get.put(UpdateProfileController());

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

    return ScaffoldDefault(
        title: "edit-profile".tr,
        actions: const [],
        leading: const BackBtn(),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                    key: _formKey,
                    child: Column(children: [
                      FadedTextField(
                          label: 'firstname'.tr,
                          hintText: 'enter-your-firstname'.tr,
                          validator: validFisrtName,
                          controller:
                              updateProfileController.userUpdateFirstName),
                      FadedTextField(
                          label: 'last-name'.tr,
                          hintText: 'enter-your-last-name'.tr,
                          validator: validLastName,
                          controller:
                              updateProfileController.userUpdateLastName),
                      CustomSelectFormField(
                        validator: validUserSex,
                        label: "gender".tr,
                        items: userSex,
                        hintText: 'gender'.tr,
                        type: SelectFormFieldType.dropdown,
                        controller: updateProfileController.userUpdateSex,
                      ),
                      CustomSelectFormField(
                          validator: validCity,
                          label: "city".tr,
                          controller: updateProfileController.userUpdateCity,
                          items: city,
                          hintText: 'enter-your-city'.tr),
                      FadedTextField(
                          label: 'appointment-address'.tr,
                          hintText: 'enter-your-address'.tr,
                          controller:
                              updateProfileController.userUpdateAddress),
                      CustomDateFormField(
                          initialValue:
                              updateProfileController.userUpdateBirthday.value,
                          onChanged: (date) {
                            updateProfileController.userUpdateBirthday.value =
                                date;
                          },
                          validator: validBirthay,
                          helperText: birthdayHelperText(),
                          label: 'birthday'.tr),
                      Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Obx(() => OutlinedBtn(
                              title: 'saved'.tr,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  updateProfileController.updateUserInfo();
                                }
                              },
                              isLoad: Get.find<Auth>().isLoading.value)))
                    ])))));
  }
}
