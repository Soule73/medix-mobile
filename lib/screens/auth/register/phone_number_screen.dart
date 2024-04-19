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
              child: Column(
                  children: [_phoneFormField(context), _termAndCondition()])),
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

  Obx _termAndCondition() {
    return Obx(() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CheckBoxFormFieldWithErrorMessage(
            labelText: "term-and-condition".tr,
            isChecked: registerC.agreeTerms.value,
            onChanged: _termOnChanged,
            validator: _validAgreeTerm,
            error: registerC.agreeError.value)));
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
