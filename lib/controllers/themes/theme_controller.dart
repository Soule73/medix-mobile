import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Contrôleur pour la gestion du thème de l'application.
///
/// Permet de changer le thème de l'application et de sauvegarder la préférence
/// de thème de l'utilisateur. Utilise le package GetX pour la gestion d'état et
/// SharedPreferences pour la persistance des données.
class ThemeController extends GetxController {
  /// Observable pour le statut du thème (clair ou sombre).
  final RxBool isLightTheme = false.obs;

  /// Future pour l'instance de SharedPreferences.
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /// Observable pour le mode de thème actuel.
  Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  /// Initialisation du contrôleur.
  ///
  /// Charge le mode de thème sauvegardé depuis les préférences partagées ou utilise
  /// le mode système par défaut si aucun mode n'est sauvegardé.
  @override
  onInit() {
    super.onInit();
    SharedPreferences.getInstance().then((prefs) {
      var storedThemeMode = prefs.getString('themeMode');
      if (storedThemeMode == null) {
        themeMode.value = ThemeMode.system;
      } else {
        themeMode.value =
            storedThemeMode == 'dark' ? ThemeMode.dark : ThemeMode.light;
      }
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: storedThemeMode == 'dark' ? darkBg : primary,
      ));

      update();
      FlutterNativeSplash.remove();
    });
  }

  /// Bascule entre le thème clair et sombre.
  ///
  /// Sauvegarde le nouveau mode de thème dans les préférences partagées et met à jour
  /// l'interface utilisateur du système en conséquence.
  void toggleTheme() async {
    var prefs = await SharedPreferences.getInstance();
    if (themeMode.value == ThemeMode.dark) {
      prefs.setString('themeMode', 'light');
      themeMode.value = ThemeMode.light;
    } else {
      prefs.setString('themeMode', 'dark');
      themeMode.value = ThemeMode.dark;
    }
    Get.changeThemeMode(themeMode.value);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: themeMode.value == ThemeMode.dark ? darkBg : primary,
    ));
    update();
  }

  /// Sauvegarde le statut du thème (clair ou sombre) dans les préférences partagées.
  saveThemeStatus() async {
    SharedPreferences pref = await _prefs;
    pref.setBool('theme', isLightTheme.value);
  }

  /// Récupère le statut du thème depuis les préférences partagées.
  getThemeStatus() async {
    var isLight = _prefs.then((SharedPreferences prefs) {
      return prefs.getBool('theme') ?? true;
    }).obs;
    isLightTheme.value = (await isLight.value);
  }
}
