import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/controllers/notification_controller.dart';
import 'package:medix/controllers/speciality_controller.dart';
import 'package:medix/screens/auth/register/user_informations_screen.dart';
import 'package:medix/screens/auth/register/verify_phone_number_screen.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/services/api_auth.dart';
import 'package:medix/utils/alert_dialog.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path/path.dart' as p;

/// Cette classe est un contrôleur permettant de gérer la fonctionnalité d'enregistrement
class RegisterController extends GetxController {
  final PhoneController phoneNumber =
      PhoneController(initialValue: PhoneNumber.parse('+222'));
  final TextEditingController pin = TextEditingController();
  final TextEditingController userPasswordConfirm = TextEditingController();
  final TextEditingController userFirstName = TextEditingController();
  final TextEditingController userLastName = TextEditingController();
  final TextEditingController userSex = TextEditingController();
  final Rx<DateTime?> userBirthday = Rx<DateTime?>(null);
  final TextEditingController userCity = TextEditingController();
  final ApiAuth apiAuth = ApiAuth();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController userPassword = TextEditingController();

  final Rx<File?> image = Rx<File?>(null);
  final RxInt resendToken = 0.obs;
  final RxString imageUrl = ''.obs;
  final RxString progressState = "upload-pending".obs;
  final RxString agreeError = ''.obs;
  final RxBool agreeTerms = false.obs;
  final RxBool isChanged = false.obs;
  final RxBool otpVerifyPending = false.obs;
  final RxBool phoneNumberIsvalid = false.obs;
  final RxBool otpVerified = false.obs;
  final RxBool loading = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSetUserProfile = false.obs;

  setProgress(String val) => progressState.value = val;

  /// La fonction " registerr " gère l'enregistrement des utilisateurs en téléchargeant une image, en
  /// créant un objet utilisateur avec divers détails, en enregistrant l'utilisateur avec authentification
  /// et en récupérant les données des médecins, des spécialités et des notifications si l'authentification réussit.
  void registerr() async {
    isLoading.value = true;
    File? file = image.value;
    if (file != null) {
      await uploadFile(file);
    }
    FirebaseAuth auth = FirebaseAuth.instance;
    Map<String, dynamic> user = {
      'name': userLastName.text,
      'first_name': userFirstName.text,
      'phone': auth.currentUser?.phoneNumber != null
          ? auth.currentUser?.phoneNumber?.replaceAll("+222", "")
          : phoneNumber.value.nsn,
      'avatar': imageUrl.value != "" ? imageUrl.value : null,
      'city_id': userCity.text,
      'birthday': userBirthday.value.toString(),
      'password': userPassword.text,
      'sex': userSex.text,
      'one_signal_id': OneSignal.User.pushSubscription.id
    };
    await Get.find<Auth>().register(credential: user);
    isLoading.value = false;

    await Get.find<DoctorController>().fetchDoctors();
    await Get.find<SpecialityController>().fetchSpecialities();
    await Get.find<NotificationController>().getPatientNotification();
    reset.call();
  }

  /// La fonction " réinitialiser " efface tous les champs de saisie utilisateur et définit les valeurs
  /// par défaut pour le numéro de téléphone et l'URL de l'image si l'authentification réussit.
  void reset() {
    userFirstName.text = '';
    userLastName.text = '';
    phoneNumber.value = PhoneNumber.parse('+222');
    userCity.text = '';
    userSex.text = '';
    userPassword.text = '';
    userPasswordConfirm.text = '';
    imageUrl.value = "";
  }

  /// La fonction " sendOTP " vérifie si un utilisateur existe, puis envoie un OTP via la vérification du
  /// numéro de téléphone si l'utilisateur n'existe pas, affichant les messages d'erreur appropriés si
  /// nécessaire.
  Future<void> sendOTP() async {
    loading.value = true;
    final bool? userExist = await apiAuth.verifyUser(alert: false, credential: {
      'phone': phoneNumber.value.nsn,
    });
    if (userExist != null) {
      if (!userExist) {
        try {
          await FirebaseAuth.instance.verifyPhoneNumber(
              timeout: const Duration(seconds: 60),
              phoneNumber: '+222${phoneNumber.value.nsn}',
              verificationCompleted: _verificationCompleted,
              verificationFailed: _verificationFailed,
              codeSent: codeSent,
              codeAutoRetrievalTimeout: _codeAutoRetrievalTimeout,
              forceResendingToken: resendToken.value);
        } catch (e) {
          defaultErrorDialog();
        }
      } else {
        errorDialog(title: "error".tr, body: "phone-number-already-used".tr);
      }
    } else {
      defaultErrorDialog();
    }
  }

  /// La fonction _verificationCompleted connecte l'utilisateur avec les informations d'authentification
  /// téléphonique fournies et met à jour le champ de texte PIN avec le code SMS si disponible.
  ///
  /// Args:
  ///   credential (PhoneAuthCredential): Le paramètre `credential` dans la fonction
  /// `_verificationCompleted` est de type `PhoneAuthCredential`. Il est utilisé pour vérifier
  /// l'authentification du numéro de téléphone et connecter l'utilisateur avec les informations
  /// d'identification fournies.
  Future<void> _verificationCompleted(PhoneAuthCredential credential) async {
    await auth.signInWithCredential(credential);
    String? smsCode = credential.smsCode;
    if (smsCode != null) {
      pin.text = smsCode;
    }
    loading.value = false;
  }

  /// La fonction `_codeAutoRetrievalTimeout` définit la valeur de `loading` sur false.
  ///
  /// Args:
  ///   verificationId (String): Le paramètre `verificationId` dans la fonction
  /// `_codeAutoRetrievalTimeout` est une chaîne qui représente l'identifiant unique associé à un
  /// processus de vérification. Il est généralement utilisé dans les flux d'authentification, tels que la
  /// vérification du numéro de téléphone à l'aide de codes SMS.
  void _codeAutoRetrievalTimeout(String verificationId) {
    loading.value = false;
  }

  /// La fonction `_verificationFailed` gère les exceptions d'authentification Firebase et affiche les
  /// messages d'erreur appropriés en fonction du code d'exception.
  ///
  /// Args:
  ///   e (FirebaseAuthException): Le paramètre `e` dans la fonction `_verificationFailed` est de type
  /// `FirebaseAuthException`. Il est utilisé pour gérer les exceptions qui peuvent survenir pendant le
  /// processus de vérification, par exemple en cas de problème avec le numéro de téléphone fourni.
  void _verificationFailed(FirebaseAuthException e) {
    loading.value = false;

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

  /// La fonction " codeSent " de Dart gère le processus de vérification des numéros de téléphone, y
  /// compris l'envoi d'OTP, la vérification d'OTP et l'affichage des boîtes de dialogue d'erreur.
  ///
  /// Args:
  ///   verificationId (String): Le paramètre `verificationId` dans la fonction `codeSent` est une chaîne
  /// qui représente l'ID de vérification généré lors du processus de vérification d'un numéro de
  /// téléphone à l'aide d'OTP (mot de passe à usage unique). Cet identifiant de vérification est
  /// généralement obtenu à partir d'un service tel que Firebase Authentication lors de l'envoi d'un OTP
  /// au numéro de téléphone d'un utilisateur pour
  ///   forceResendingToken (int): Le paramètre " forceResendingToken " dans la fonction " codeSent " est
  /// une valeur entière facultative qui est utilisée pour renvoyer le code de vérification. Si le
  /// `forceResendingToken` n'est pas nul, cela indique qu'un nouveau jeton doit être utilisé pour
  /// renvoyer le code de vérification.
  void codeSent(String verificationId, int? forceResendingToken) async {
    if (forceResendingToken != null) {
      resendToken.value = forceResendingToken;
    }
    Get.to(() => Obx(() => VerifyPhoneNumberScreen(
        otpVerifyPending: otpVerifyPending.value,
        controller: pin,
        reSend: resendToken.value != 0
            ? () => sendOTP()
            : () =>
                errorDialog(title: "error".tr, body: "can-not-resend-otp".tr),
        verificationId: verificationId,
        onCompleted: (String smsCode) =>
            authenticate(verificationId, smsCode))));
    loading.value = false;
  }

  /// La fonction " authentifier " dans Dart est utilisée pour vérifier un numéro de téléphone à l'aide
  /// d'OTP et connecter l'utilisateur avec les informations d'identification fournies, affichant une
  /// boîte de dialogue d'erreur si l'authentification échoue.
  ///
  /// Args:
  ///   verificationId (String): Le paramètre " verificationId " est un identifiant unique généré
  /// lorsqu'un utilisateur lance le processus de vérification du numéro de téléphone à l'aide d'OTP
  /// (One-Time Password). Il est généralement envoyé au numéro de téléphone de l'utilisateur par SMS ou
  /// par d'autres méthodes et est utilisé pour vérifier l'identité de l'utilisateur pendant le processus
  /// d'authentification.
  ///   smsCode (String): Le paramètre `smsCode` dans la fonction `authenticate` est le code que
  /// l'utilisateur reçoit par SMS pour l'authentification à deux facteurs. Ce code est saisi par
  /// l'utilisateur pour vérifier son identité lors du processus d'authentification.
  authenticate(String verificationId, String smsCode) async {
    otpVerifyPending.value = true;

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      await auth.signInWithCredential(credential);
      Get.to(() => UserInformationsScreen());
    } catch (e) {
      defaultErrorDialog();
      debugPrint('$e');
    }
    otpVerifyPending.value = false;
  }

  /// La fonction " uploadFile " télécharge un fichier sur Firebase Storage et met à jour la progression
  /// et l'état en conséquence.
  ///
  /// Args:
  ///   file (File): Le paramètre " file " dans la fonction " uploadFile " représente le fichier image
  /// que vous souhaitez télécharger sur Firebase Storage. Ce fichier doit être de type " Fichier ", qui
  /// contient généralement le chemin d'accès au fichier image sur l'appareil.
  Future<void> uploadFile(File file) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    String? uid = auth.currentUser?.uid;

    isSetUserProfile.value = true;

    try {
      final FirebaseStorage storage = FirebaseStorage.instance;

      final String fileExtension = p.extension(file.path);

      /// Le code Dart ci-dessus crée une référence à un emplacement dans le stockage Firebase. Il spécifie le
      /// chemin d'accès à un fichier dans le bucket de stockage à l'aide de la méthode " enfant ". Le chemin
      /// est construit à l'aide des variables " uid " et " fileExtension ", qui sont probablement utilisées
      /// pour identifier de manière unique le fichier.
      Reference ref = storage.ref().child('profile_images/$uid$fileExtension');

      /// Le code Dart ci-dessus crée un objet " UploadTask " en téléchargeant un fichier vers un emplacement
      /// spécifié. La méthode `putFile` est utilisée pour télécharger le `fichier` avec des métadonnées
      /// supplémentaires fournies à l'aide de `SettableMetadata`. Dans ce cas, le type de contenu du fichier
      /// est défini en fonction de l'extension du fichier.
      UploadTask uploadTask = ref.putFile(
          file,
          SettableMetadata(
            contentType: "image/${p.extension(file.path).replaceAll('.', '')}",
          ));

      /// Le code Dart ci-dessus configure un écouteur pour les événements d'instantané d'une tâche de
      /// téléchargement. En fonction de l'état de l'instantané de la tâche, différentes actions sont
      /// entreprises :
      /// - Si la tâche est en cours d'exécution, elle calcule le pourcentage de progression et met à jour le
      /// message de progression.
      /// - Si la tâche est en pause, il définit le message de progression pour indiquer que la tâche est
      /// suspendue.
      /// - Si la tâche est annulée, il définit le message de progression pour indiquer que la tâche est
      /// annulée.
      /// - Si la tâche rencontre une erreur, elle définit le message de progression pour indiquer une erreur
      /// et définit un indicateur booléen `isSetUserProfile` sur true.
      /// -
      uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            var progress = 100.0 *
                (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            setProgress("${progress.toStringAsFixed(1)}% ${'finished'.tr}.");
            break;
          case TaskState.paused:
            setProgress("suspended".tr);
            break;
          case TaskState.canceled:
            setProgress("canceled".tr);
            break;
          case TaskState.error:
            {
              setProgress("error".tr);
              isSetUserProfile.value = true;
            }
            break;
          case TaskState.success:
            {
              setProgress("completed".tr);

              break;
            }
        }
      });

      String url = await (await uploadTask).ref.getDownloadURL();
      imageUrl.value = url;

      isSetUserProfile.value = false;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      isSetUserProfile.value = true;
      errorDialog(
          title: "something-went-wrong-title".tr,
          body: "something-went-wrong".tr);
    }
  }
}
