import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/controllers/auth/login_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/screens/auth/login/forget_password_screen.dart';
import 'package:medix/screens/auth/register/phone_number_screen.dart';
import 'package:medix/utils/form_validation.dart';
import 'package:medix/widgets/boutons/button.dart';
import 'package:medix/widgets/forms/custom_phone_form_field.dart';
import 'package:medix/widgets/forms/faded_text_form_field.dart';
import 'package:medix/widgets/forms/icon_obscure_icon.dart';
import 'package:medix/widgets/switch_theme.dart';
import 'package:phone_form_field/phone_form_field.dart';

class LoginObscure extends GetxController {
  RxBool passWordObscure = true.obs;
  void setpassWordObscure() {
    passWordObscure.value = !passWordObscure.value;
  }
}

class LoginScreen extends StatelessWidget {
  LoginScreen({
    super.key,
  });
  final LoginObscure obscure = Get.put(LoginObscure());

  final Auth auth = Get.find<Auth>();

  final LoginController loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        actions: const [SwitchThemeMode()],
        body: SafeArea(
            child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                        key: _formKey,
                        child: Column(children: [
                          _buildSvgPicture(),
                          _buildLoginText(),
                          _buildPhoneFormField(context),
                          _buildPasswordField(context),
                          _forgetPassword(),
                          _buildLoginButton(),
                          _loginFooter()
                        ]))))));
  }

  Container _forgetPassword() {
    return Container(
        margin: const EdgeInsets.only(top: 10, right: 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Text("forget-password".tr),
          const SizedBox(width: 8),
          InkWell(
              onTap: () => Get.to(() => ForgetPasswordScreen()),
              child: Text("reset".tr, style: TextStyle(color: primary)))
        ]));
  }

  Container _loginFooter() {
    return Container(
        margin: const EdgeInsets.only(top: 50),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("dont-have-account".tr),
          const SizedBox(width: 8),
          InkWell(
              onTap: () => Get.to(() => GetPhoneNumberScreen()),
              child: Text("login-create-account".tr,
                  style: TextStyle(color: primary)))
        ]));
  }

  Obx _buildLoginButton() {
    return Obx(() => Padding(
        padding: const EdgeInsets.only(top: 18.0),
        child: FadeBtn(
            title: 'login-btn'.tr,
            color: loginController.phoneNumberIsvalid.value
                ? primary
                : Get.theme.dividerColor,
            isLoad: Get.find<Auth>().isLoading.value,
            onPressed: loginController.phoneNumberIsvalid.value
                ? () => loginController.login()
                : null)));
  }

  Obx _buildPasswordField(BuildContext context) {
    return Obx(() => FadedTextField(
        controller: loginController.userPassword,
        hintText: "password".tr,
        label: "your-password".tr,
        validator: validPassword,
        obscureText: obscure.passWordObscure.value,
        suffixIcon: GestureDetector(
            onTap: obscure.setpassWordObscure,
            child: obscureIcon(
                context: context, isObscure: obscure.passWordObscure.value))));
  }

  CustomPhoneFormField _buildPhoneFormField(BuildContext context) {
    return CustomPhoneFormField(
        label: "your-phone-number".tr,
        controller: loginController.phoneNumber,
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
      loginController.phoneNumberIsvalid.value = true;
      FocusScope.of(context).unfocus();
    } else {
      loginController.phoneNumberIsvalid.value = false;
    }
  }

  Widget _buildSvgPicture() {
    return SizedBox(
        width: (Get.width * 0.6),
        height: 300,
        child: SvgPicture.asset("assets/icons/login.svg",
            semanticsLabel: 'Login svg'));
  }

  Widget _buildLoginText() {
    return Text("login-to-your-account".tr,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700));
  }
}
