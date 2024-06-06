import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/auth/firebase_auth.dart';
import 'package:medix/models/user.dart';
import 'package:medix/screens/auth/login/login_screen.dart';
import 'package:medix/screens/profile/profile_screen.dart';
import 'package:medix/screens/welcome_screen.dart';
import 'package:medix/services/api_auth.dart';
import 'package:medix/utils/alert_dialog.dart';
import 'package:medix/utils/utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// La classe "Auth" de Dart gère l'authentification des utilisateurs, l'enregistrement, la connexion,
/// la mise à jour des informations utilisateur, la modification des mots de passe, la déconnexion et la
/// suppression des comptes d'utilisateurs à l'aide de FlutterSecureStorage et des appels API.
class Auth extends GetxController {
  final storage = const FlutterSecureStorage();
  final ApiAuth apiAuth = ApiAuth();
  RxBool authenticated = false.obs;
  RxBool isLoading = false.obs;
  RxBool isFirstOpenApp = true.obs;
  Rxn<User?> user = Rxn<User?>();
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  Future<void> setIsFisrtOpenApp() async {
    SharedPreferences pref = await prefs;
    await pref.setBool('isFirstOpenApp', false);
    isFirstOpenApp.value = false;
  }

  /// La fonction "onInit" recherche un jeton, authentifie l'utilisateur, récupère les données
  /// utilisateur, met à jour l'ID OneSignal de l'utilisateur si nécessaire et se déconnecte si aucun
  /// jeton n'est trouvé.
  @override
  void onInit() async {
    super.onInit();
    SharedPreferences pref = await prefs;
    await pref.setBool('isFirstOpenApp', true);

    isFirstOpenApp.value = pref.getBool("isFirstOpenApp") ?? true;
    final String? token = await getToken();
    if (token != null) {
      authenticated.value = true;
      final userData = await storage.read(key: 'user');
      if (userData != null) {
        user.value = User.fromJson(jsonDecode(userData));
      } else {
        await apiAuth.attempt(token: token);
      }
      if (user.value?.oneSignalId == null &&
          OneSignal.User.pushSubscription.id != null) {
        await updateUser(
            path: '/auth/user/update/one-signal-id',
            alert: false,
            credential: {'one_signal_id': OneSignal.User.pushSubscription.id});
      }
    } else {
      authenticated.value = false;
    }
  }

  /// La fonction "register" prend les informations d'identification de l'utilisateur, enregistre
  /// l'utilisateur auprès d'une API, stocke le jeton et met à jour l'état de l'utilisateur en
  /// conséquence.
  ///
  /// Args:
  ///   credential (Map<String, dynamic>): Le paramètre `credential` est une `Map` obligatoire qui
  /// contient des paires clé-valeur de type `String` et `dynamic`. Il est utilisé pour fournir les
  /// informations d’identification nécessaires au processus d’inscription.
  Future<void> register({required Map<String, dynamic> credential}) async {
    isLoading.value = true;
    String deviceId = await getDeviceId();
    final String? token = await apiAuth.register(
        credential: credential..addAll({'device_id': deviceId}));
    if (token != null) {
      await storeToken(token);
      user.value = await apiAuth.attempt(token: token);
      authenticated.value = true;
      successDialog(
          title: 'success'.tr,
          body: "login-success".tr,
          onClose: () => Get.to(() => WelcomeScreen()));
    }
    isLoading.value = false;
  }

  /// La fonction " login " dans Dart prend les informations d'identification de l'utilisateur, se
  /// connecte à l'aide d'une API avec un ID de périphérique, stocke le jeton et accède à l'écran
  /// d'accueil en cas de succès.
  ///
  /// Args:
  ///   credential (Map<String, dynamic>): Le paramètre " credential " est une " Map " obligatoire qui
  /// contient des paires clé-valeur d'informations d'identification utilisateur nécessaires au processus
  /// de connexion. Il peut inclure des informations telles que le nom d'utilisateur, le mot de passe ou
  /// toute autre donnée nécessaire à l'authentification.
  Future<void> login({required Map<String, dynamic> credential}) async {
    isLoading.value = true;

    String deviceId = await getDeviceId();
    final String? token = await apiAuth.login(
        credential: credential..addAll({'device_id': deviceId}));

    if (token != null) {
      user.value = await apiAuth.attempt(token: token);
      await storeToken(token);
      authenticated.value = true;
      Get.to(() => WelcomeScreen());
    }

    isLoading.value = false;
  }

  /// Cette fonction Dart met à jour les données utilisateur avec les informations d'identification
  /// fournies et affiche un message de réussite si la mise à jour réussit.
  ///
  /// Args:
  ///   credential (Map<String, dynamic>): Le paramètre `credential` est un `Map<String, Dynamic>`
  /// obligatoire qui contient les informations de l'utilisateur nécessaires pour mettre à jour son
  /// profil. Il comprend généralement des champs tels que le nom, l'e-mail, le mot de passe, etc.
  ///   path (String): Le paramètre `path` dans la fonction `updateUser` est un paramètre String avec une
  /// valeur par défaut de ``/auth/user/update'`. Ce paramètre est utilisé pour spécifier le chemin du
  /// point de terminaison de l'API pour la mise à jour des informations utilisateur. Si aucune valeur
  /// n'est fournie lors de l'appel de la fonction, elle sera par défaut ``/auth. Defaults to
  /// /auth/user/update
  ///   onClose (Function?): Le paramètre `onClose` dans la fonction `updateUser` est une fonction de
  /// rappel qui peut être fournie pour être exécutée lorsqu'une certaine action est terminée. Dans ce
  /// cas, il est utilisé pour naviguer vers `ProfileScreen` après une mise à jour utilisateur réussie si
  /// aucune fonction `onClose` spécifique n'est disponible.
  ///   alert (bool): Le paramètre `alert` dans la fonction `updateUser` est un paramètre booléen qui
  /// détermine s'il faut afficher une boîte de dialogue de réussite après la mise à jour de
  /// l'utilisateur. Si `alert` est défini sur `true`, une boîte de dialogue de réussite sera affichée
  /// avec le message de réussite spécifié ou un message par défaut si `successMsg` est. Defaults to true
  ///   successMsg (String): Le paramètre `successMsg` dans la fonction `updateUser` est une chaîne qui
  /// représente le message de réussite à afficher lorsque l'opération de mise à jour de l'utilisateur
  /// réussit. Si aucun `successMsg` n'est fourni, un message de réussite par défaut sera utilisé
  /// ("profile-update-success").
  Future<void> updateUser(
      {required Map<String, dynamic> credential,
      String path = '/auth/user/update',
      Function? onClose,
      bool alert = true,
      String? successMsg}) async {
    isLoading.value = true;

    final User? data = await apiAuth.updateUser(
        credential: credential, path: path, alert: alert);
    if (data != null) {
      user.value = data;
      await storage.write(key: 'user', value: jsonEncode(data.toJson()));
      if (alert) {
        successDialog(
            title: 'success'.tr,
            body: successMsg ?? 'profile-update-success'.tr,
            onClose: () => onClose ?? Get.to(() => ProfileScreen()));
      }
      update();
    }
    isLoading.value = false;
  }

  /// La fonction `updateUserPassword` met à jour le mot de passe de l'utilisateur à l'aide des
  /// informations d'identification fournies et affiche une boîte de dialogue de réussite si l'opération
  /// réussit.
  ///
  /// Args:
  ///   credential (Map<String, dynamic>): La fonction `updateUserPassword` prend un paramètre obligatoire
  /// `credential`, qui est un Map<String, Dynamic> contenant les informations d'identification de
  /// l'utilisateur nécessaires pour mettre à jour le mot de passe. Cette carte comprend probablement des
  /// informations telles que le mot de passe actuel de l'utilisateur et le nouveau mot de passe qu'il
  /// souhaite définir.
  ///
  /// Returns:
  ///   La fonction `updateUserPassword` renvoie une valeur `Future<bool>`.
  Future<bool> updateUserPassword(
      {required Map<String, dynamic> credential}) async {
    isLoading.value = true;
    final bool success =
        await apiAuth.updateUserPassword(credential: credential);
    if (success) {
      successDialog(
          title: 'success'.tr,
          body: "password-updated".tr,
          onClose: () => Get.to(() => ProfileScreen()));
      return true;
    }

    isLoading.value = false;
    return false;
  }

  /// La fonction " logout " déconnecte l'utilisateur en effaçant le statut d'authentification, en
  /// supprimant les jetons, en accédant à l'écran de connexion, en se déconnectant de Firebase, en
  /// réinitialisant les données utilisateur et en déclenchant une mise à jour.
  Future<void> logout() async {
    await apiAuth.logout();
    authenticated.value = false;
    await deleteToken();
    await Get.off(() => LoginScreen());
    await firebaseSignOutUser();
    user.value = User();
    update();
  }

  /// La fonction `deleteUserAccount` supprime le compte utilisateur, déconnecte l'utilisateur, efface les
  /// données utilisateur et accède à l'écran de connexion.
  Future<void> deleteUserAccount() async {
    isLoading.value = true;
    await apiAuth.destroy();
    authenticated.value = false;
    await deleteToken();
    isLoading.value = false;
    await Get.off(() => LoginScreen());
    user.value = User();
    update();
    await firebaseDestroyUser();
  }
}
