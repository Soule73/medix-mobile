import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/auth/auth.dart';

/// Contrôleur pour la gestion des paramètres de langue dans l'application.
///
/// Permet de changer la langue de l'application et de sauvegarder la préférence
/// de langue de l'utilisateur. Utilise le package GetX pour la gestion d'état et
/// FlutterSecureStorage pour le stockage sécurisé.
class LangController extends GetxController {
  /// Observable pour la langue actuelle.
  RxString lang = ''.obs;

  /// Instance de stockage sécurisé pour sauvegarder la langue.
  final storage = const FlutterSecureStorage();

  /// Initialisation du contrôleur.
  ///
  /// Charge la langue actuelle depuis le stockage sécurisé ou utilise la langue
  /// par défaut du dispositif si aucune langue n'est sauvegardée.
  @override
  onInit() async {
    super.onInit();

    final String? currentLang = await storage.read(key: 'currentLang');
    if (currentLang != null && currentLang != "") {
      Locale locale = Locale(currentLang);
      lang.value = currentLang;
      if (currentLang != Get.locale?.languageCode &&
          Get.find<Auth>().authenticated.value) {
        Get.updateLocale(locale);

        await updateLang(currentLang);
      }
    } else {
      final value = Get.deviceLocale?.languageCode;
      if (value != null) {
        lang.value = value;
      }
      storage.write(key: "currentLang", value: value);
    }
  }

  /// Obtient la langue actuelle de l'application.
  ///
  /// Retourne `Future<Locale>` qui est la locale actuelle de l'application.
  Future<Locale> get appLang async {
    final String? currentLang = await storage.read(key: 'currentLang');
    if (currentLang != null && currentLang != "") {
      return Locale(currentLang);
    }
    Locale? deviceLocale = Get.deviceLocale;
    if (deviceLocale != null) {
      return deviceLocale;
    }
    return const Locale('fr');
  }

  /// Change la langue de l'application.
  ///
  /// [value] valeur de la nouvelle langue à utiliser.
  /// Retourne `void`.
  Future<void> onChnage(String value) async {
    lang.value = value;
    Locale locale = Locale(value);
    await Get.updateLocale(locale);
    await storage.write(key: "currentLang", value: value);
    update();

    await updateLang(value);
  }

  /// Met à jour la langue par défaut de l'utilisateur sur le serveur.
  ///
  /// [lang] valeur de la nouvelle langue à enregistrer.
  /// Retourne `void`.
  Future<void> updateLang(String lang) async {
    await Get.find<Auth>().updateUser(
        path: '/auth/user/update/default-lang',
        alert: false,
        credential: {'default_lang': lang});
  }
}
