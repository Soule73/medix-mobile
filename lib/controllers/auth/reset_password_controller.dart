import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/controllers/notification_controller.dart';
import 'package:medix/controllers/speciality_controller.dart';
import 'package:medix/screens/auth/login/reset_password_sceen.dart';
import 'package:medix/screens/auth/register/verify_phone_number_screen.dart';
import 'package:medix/screens/welcome_screen.dart';
import 'package:medix/services/api_auth.dart';
import 'package:medix/utils/alert_dialog.dart';
import 'package:medix/utils/utils.dart';
import 'package:phone_form_field/phone_form_field.dart';

/// La classe " ResetPasswordController " dans Dart gère la réinitialisation des mots de passe des
/// utilisateurs, l'authentification via OTP et l'envoi d'OTP pour la vérification téléphonique.
class ResetPasswordController extends GetxController {
  final TextEditingController pin = TextEditingController();
  final TextEditingController userPassword = TextEditingController();
  final TextEditingController userPasswordConfirm = TextEditingController();
  final ApiAuth apiAuth = ApiAuth();
  final PhoneController userPhoneNumber = PhoneController(
      initialValue: const PhoneNumber(isoCode: IsoCode.MR, nsn: ''));
  final FirebaseAuth auth = FirebaseAuth.instance;

  final RxBool isLoading = false.obs;
  final RxBool otpVerifyPending = false.obs;
  final RxInt resendToken = 0.obs;
  final RxBool phoneNumberIsvalid = false.obs;

  /// La fonction " resetUserPassword " met à jour le mot de passe d'un utilisateur, déclenche divers
  /// appels d'API et met à jour les éléments de l'interface utilisateur en conséquence.
  Future<void> resetUserPassword() async {
    isLoading.value = true;
    final deviceId = await getDeviceId();
    Map<String, dynamic> data = {
      'password': userPassword.text,
      'phone': userPhoneNumber.value.nsn,
      'device_id': deviceId
    };
    final String? token = await apiAuth.resetUserPassword(credential: data);

    if (token != null) {
      Get.find<Auth>().user.value = await apiAuth.attempt(token: token);
      await storeToken(token);
      Get.find<Auth>().authenticated.value = true;
      Get.to(() => WelcomeScreen());
      successDialog(
        title: 'success'.tr,
        body: "password-updated".tr,
      );
    }
    isLoading.value = false;
    if (token != null) {
      await Get.find<DoctorController>().fetchDoctors();
      await Get.find<SpecialityController>().fetchSpecialities();
      await Get.find<NotificationController>().getPatientNotification();
      reset.call();
    }
  }

  /// La fonction " réinitialisation " dispose de champs de saisie utilisateur pour le mot de passe, le
  /// numéro de téléphone et la confirmation du mot de passe.
  void reset() {
    userPassword.dispose();
    userPhoneNumber.dispose();
    userPasswordConfirm.dispose();
  }

  /// La fonction " authentifier " dans Dart est utilisée pour vérifier un numéro de téléphone à l'aide
  /// d'OTP et connecter l'utilisateur avec les informations d'identification fournies, affichant une
  /// boîte de dialogue d'erreur si l'authentification échoue.
  ///
  /// Args:
  ///   verificationId (String): Le paramètre " verificationId " est un identifiant unique généré
  /// lorsqu'un utilisateur lance le processus de vérification du numéro de téléphone. Il est généralement
  /// envoyé au numéro de téléphone de l'utilisateur par SMS lors du flux d'authentification.
  /// L'utilisateur devra ensuite saisir ce code de vérification ainsi que son code SMS pour finaliser
  /// l'authentification.
  ///   smsCode (String): Le paramètre `smsCode` dans la fonction `authenticate` est le code que
  /// l'utilisateur reçoit par SMS pour l'authentification à deux facteurs. Ce code est utilisé pour
  /// vérifier l'identité de l'utilisateur lors du processus d'authentification.
  authenticate(String verificationId, String smsCode) async {
    otpVerifyPending.value = true;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      await auth.signInWithCredential(credential);
      Get.to(() => ResetPasswordScreen());
    } catch (e) {
      defaultErrorDialog();
      if (kDebugMode) {
        print('$e');
      }
    }
    otpVerifyPending.value = false;
  }

  /// La fonction " sendOTP " lance le processus d'envoi d'un mot de passe à usage unique (OTP) au numéro
  /// de téléphone d'un utilisateur pour vérification.
  sendOTP() async {
    isLoading.value = true;

    try {
      final bool? userExist = await apiAuth.verifyUser(credential: {
        'phone': userPhoneNumber.value.nsn,
      });
      if (userExist != null && userExist) {
        await FirebaseAuth.instance.verifyPhoneNumber(
            phoneNumber: '+222${userPhoneNumber.value.nsn}',
            timeout: const Duration(seconds: 60),
            verificationCompleted: _verificationCompleted,
            verificationFailed: _verificationFailed,
            codeSent: _codeSent,
            codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
            forceResendingToken: resendToken.value);
      } else {
        defaultErrorDialog();
      }
    } catch (e) {
      defaultErrorDialog();
    }
  }

  /// La fonction `_verificationCompleted` connecte l'utilisateur avec les informations d'authentification
  /// téléphonique fournies et met à jour le champ de texte PIN avec le code SMS reçu si disponible.
  ///
  /// Args:
  ///   credential (PhoneAuthCredential): Le paramètre `credential` dans la fonction
  /// `_verificationCompleted` est de type `PhoneAuthCredential`. Il est utilisé pour vérifier
  /// l'authentification du numéro de téléphone et connecter l'utilisateur avec les informations
  /// d'identification fournies.
  void _verificationCompleted(PhoneAuthCredential credential) async {
    await auth.signInWithCredential(credential);
    String? smsCode = credential.smsCode;
    if (smsCode != null) {
      pin.text = smsCode;
    }
    isLoading.value = false;
  }

  /// La fonction `_codeAutoRetrievalTimeout` définit la valeur de `isLoading` sur false.
  ///
  /// Args:
  ///   verificationId (String): Le paramètre `verificationId` dans la fonction
  /// `_codeAutoRetrievalTimeout` est généralement un identifiant unique utilisé pour vérifier le numéro
  /// de téléphone d'un utilisateur lors d'un processus d'authentification du numéro de téléphone. Il est
  /// généralement généré par le service d'authentification Firebase lors de l'envoi d'un code de
  /// vérification au numéro de téléphone de l'utilisateur.
  void _codeAutoRetrievalTimeout(String verificationId) {
    isLoading.value = false;
  }

  /// La fonction `_codeSent` de Dart gère l'envoi et la vérification des codes OTP pour la vérification
  /// du numéro de téléphone.
  ///
  /// Args:
  ///   verificationId (String): Le paramètre `verificationId` dans la fonction `_codeSent` est une chaîne
  /// qui représente l'ID de vérification généré lors du processus de vérification d'un numéro de
  /// téléphone à des fins d'authentification. Cet identifiant de vérification est généralement utilisé
  /// conjointement avec un OTP (mot de passe à usage unique) envoyé au numéro de téléphone de
  /// l'utilisateur pour vérification.
  ///   forceResendingToken (int): Le paramètre `forceResendingToken` dans la fonction `_codeSent` est une
  /// valeur entière facultative qui est utilisée pour forcer le renvoi du code de vérification pendant le
  /// processus de vérification du numéro de téléphone. Si le `forceResendingToken` n'est pas nul, il est
  /// stocké dans le `resendToken
  void _codeSent(String verificationId, int? forceResendingToken) async {
    if (forceResendingToken != null) {
      resendToken.value = forceResendingToken;
    }
    Get.to(() => Obx(() => VerifyPhoneNumberScreen(
        title: "tape-otp".tr,
        controller: pin,
        reSend: resendToken.value != 0
            ? () => sendOTP()
            : () =>
                errorDialog(title: "error".tr, body: "can-not-resend-otp".tr),
        verificationId: verificationId,
        otpVerifyPending: otpVerifyPending.value,
        onCompleted: (String smsCode) =>
            authenticate(verificationId, smsCode))));
    isLoading.value = false;
  }

  void _verificationFailed(FirebaseAuthException e) {
    isLoading.value = false;

    if (e.code == 'invalid-phone-number') {
      errorDialog(
          title: "something-went-wrong-title".tr,
          body: "invalid-phone-number".tr);
    } else {
      errorDialog(
          title: "something-went-wrong-title".tr,
          body: "something-went-wrong-try".tr);
    }
  }
}
