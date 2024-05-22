import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/auth/register_controler.dart';
import 'package:medix/layouts/registe_layout.dart';
import 'package:medix/screens/auth/login/login_screen.dart';
import 'package:medix/widgets/boutons/button.dart';
import 'package:medix/widgets/forms/checkbox_form_filed.dart';
import 'package:medix/widgets/forms/custom_phone_form_field.dart';
import 'package:medix/widgets/full_modal.dart';
import 'package:phone_form_field/phone_form_field.dart';

class GetPhoneNumberScreen extends StatelessWidget {
  GetPhoneNumberScreen({super.key});

  final RegisterController registerC = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    return RegisterLayout(
        division: 2,
        page: 0,
        child: Column(children: [
          SizedBox(
              height: 200,
              width: (Get.width / 6) * 5,
              child: SvgPicture.asset("assets/icons/profile_data.svg",
                  semanticsLabel: 'Login svg')),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(children: [
                _phoneFormField(context),
                _termAndCondition(context)
              ])),
          _nextBtn(),
          _footer()
        ]));
  }

  CustomPhoneFormField _phoneFormField(BuildContext context) {
    return CustomPhoneFormField(
        label: "your-phone-number".tr,
        controller: registerC.phoneNumber,
        onChanged: (phoneNumber) => _validatePhoneNumber(phoneNumber, context),
        validator: PhoneValidator.compose([
          PhoneValidator.required(context,
              errorText: "phone-number-required".tr)
        ]));
  }

  _validatePhoneNumber(PhoneNumber phoneNumber, BuildContext context) {
    int nsn = phoneNumber.nsn.length;
    String nsnString = phoneNumber.nsn.toString();

    if (nsn == 8 &&
        (nsnString.startsWith("2") ||
            nsnString.startsWith("3") ||
            nsnString.startsWith("4"))) {
      registerC.phoneNumberIsvalid.value = true;
      FocusScope.of(context).unfocus();
    } else {
      registerC.phoneNumberIsvalid.value = false;
    }
  }

  Obx _termAndCondition(BuildContext context) {
    return Obx(() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CheckBoxFormFieldWithErrorMessage(
            label: SizedBox(
              width: Get.width * 0.6,
              child: Text(
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: primary,
                    color: primary),
                "term-and-condition".tr,
              ),
            ),
            isChecked: registerC.agreeTerms.value,
            onChanged: _termOnChanged,
            validator: _validAgreeTerm,
            labelOnTap: () => showFullScreenDialog(
                context: context, body: _conditions(), title: ""),
            error: registerC.agreeError.value)));
  }

  Container _conditions() {
    List<Map<String, dynamic>> conditions = [
      {
        "title": "medix-term-and-condition",
        "style": const TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        "textAlign": TextAlign.center,
      },
      {
        "title": "accept-term-and-condition",
        "style": const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        "textAlign": TextAlign.center,
      },
      {
        "title": "if-create-account-in-medix",
        "style": const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        "textAlign": TextAlign.justify,
      },
      {
        "title": "collection-of-personal-information",
        "style": const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        "textAlign": TextAlign.center,
      },
      {
        "title": "yout-personal-information",
        "style": const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        "textAlign": TextAlign.justify,
      },
      {
        "title": "medical-records",
        "style": const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        "textAlign": TextAlign.center,
      },
      {
        "title":
            "the-doctors-you-consult-through-medix-can-manage-your-medical-file",
        "style": const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        "textAlign": TextAlign.justify,
      },
      {
        "title": "privacy-and-Security",
        "style": const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        "textAlign": TextAlign.center,
      },
      {
        "title": "your-personal-and-medical-information",
        "style": const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
        "textAlign": TextAlign.justify,
      },
      // Continuez à ajouter d'autres éléments ici
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: conditions.map((condition) {
          return Text(
            '${condition["title"]}'.tr,
            textAlign: condition["textAlign"],
            style: condition["style"],
          );
        }).toList(),
      ),
    );
  }

  String? _validAgreeTerm(value) {
    if (!registerC.agreeTerms.value) {
      registerC.agreeError.value = 'term-accepted-required-checkbox'.tr;
    }
    return null;
  }

  void _termOnChanged(bool? value) {
    registerC.isChanged.value = true;
    registerC.agreeTerms.value = value!;
    if (registerC.agreeTerms.value) {
      registerC.agreeError.value = '';
    } else {
      registerC.agreeError.value = 'term-accepted-required-checkbox'.tr;
    }
  }

  Container _footer() {
    return Container(
        margin: const EdgeInsets.only(top: 50),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('already-registerededed'.tr),
          const SizedBox(width: 8),
          InkWell(
              onTap: () => Get.to(() => LoginScreen()),
              child: Text("have-account-signin".tr,
                  style: TextStyle(color: primary)))
        ]));
  }

  Obx _nextBtn() {
    return Obx(() => FadeBtn(
        title: 'next'.tr,
        onPressed:
            registerC.phoneNumberIsvalid.value && registerC.agreeTerms.value
                ? () => registerC.sendOTP()
                : null,
        color: registerC.phoneNumberIsvalid.value && registerC.agreeTerms.value
            ? primary
            : Get.theme.dividerColor,
        width: Get.width / 4,
        isLoad: registerC.loading.value));
  }
}
