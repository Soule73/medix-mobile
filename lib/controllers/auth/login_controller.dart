import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/controllers/notification_controller.dart';
import 'package:medix/controllers/speciality_controller.dart';
import 'package:phone_form_field/phone_form_field.dart';

/// La classe LoginController gère la fonctionnalité de connexion des utilisateurs, notamment la
/// validation du numéro de téléphone et du mot de passe avant de tenter de se connecter.
class LoginController extends GetxController {
  final PhoneController phoneNumber =
      PhoneController(initialValue: PhoneNumber.parse('+222'));
  final TextEditingController userPassword = TextEditingController();
  RxBool phoneNumberIsvalid = false.obs;

  /// La fonction " login " vérifie la longueur du mot de passe de l'utilisateur et du numéro de
  /// téléphone, puis tente de se connecter en utilisant les informations d'identification fournies et
  /// récupère les données si l'authentification réussit.
  Future<void> login() async {
    if (userPassword.text.length >= 8 && phoneNumber.value.nsn.length == 8) {
      await Get.find<Auth>().login(credential: {
        "phone": phoneNumber.value.nsn,
        "password": userPassword.text
      });
      if (Get.find<Auth>().authenticated.value) {
        await Get.find<DoctorController>().fetchDoctors();
        await Get.find<SpecialityController>().fetchSpecialities();
        await Get.find<NotificationController>().getPatientNotification();
      }
      reset.call();
    }
  }

  /// La fonction reset efface le mot de passe de l'utilisateur et définit le numéro de
  /// téléphone à une valeur par défaut si l'authentification réussit.
  void reset() {
    userPassword.text = '';
    phoneNumber.value = PhoneNumber.parse('+222');
  }
}
