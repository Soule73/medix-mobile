import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

/// Affiche un dialogue d'erreur par défaut avec un titre et un corps traduits.
void defaultErrorDialog() {
  errorDialog(
      title: 'something-went-wrong-title'.tr,
      body: "something-went-wrong-try".tr);
}

/// Affiche un dialogue de succès avec des options personnalisables.
///
/// [title] Le titre du dialogue.
/// [actions] Les actions à inclure dans le dialogue (facultatif).
/// [body] Le corps du dialogue.
/// [onClose] La fonction à exécuter lorsque le dialogue est fermé (facultatif).
void successDialog(
    {required String title,
    List<Widget>? actions,
    required String body,
    void Function()? onClose}) {
  alertDialog(
      actions: actions,
      title: title,
      body: body,
      colors: [Colors.green[200]!, Colors.green[700]!],
      icon: FontAwesomeIcons.check,
      onClose: onClose);
}

/// Affiche un dialogue d'erreur avec des options personnalisables.
///
/// [title] Le titre du dialogue.
/// [actions] Les actions à inclure dans le dialogue (facultatif).
/// [body] Le corps du dialogue.
/// [onClose] La fonction à exécuter lorsque le dialogue est fermé (facultatif).
void errorDialog(
    {required String title,
    List<Widget>? actions,
    required String body,
    void Function()? onClose}) {
  alertDialog(
      actions: actions,
      title: title,
      body: body,
      colors: [Colors.red[200]!, Colors.red[700]!],
      icon: FontAwesomeIcons.circleExclamation);
}

/// Affiche un dialogue d'avertissement avec un titre et un corps personnalisés.
///
/// [title] Le titre du dialogue.
/// [body] Le corps du dialogue.
/// [onClose] La fonction à exécuter lorsque le dialogue est fermé (facultatif).
void warningDialog(
    {required String title, required String body, void Function()? onClose}) {
  alertDialog(
      title: title,
      body: body,
      colors: [Colors.amber[200]!, Colors.amber[700]!],
      icon: FontAwesomeIcons.circleExclamation);
}

/// Crée et affiche un dialogue d'alerte avec des paramètres personnalisables.
///
/// [title] Le titre du dialogue.
/// [body] Le corps du dialogue.
/// [colors] Les couleurs à utiliser pour l'icône du dialogue.
/// [icon] L'icône à afficher dans le dialogue.
/// [actions] Les actions à inclure dans le dialogue (facultatif).
/// [onClose] La fonction à exécuter lorsque le dialogue est fermé (facultatif).
Future<dynamic> alertDialog(
    {required String title,
    required String body,
    required List<Color> colors,
    required IconData icon,
    List<Widget>? actions,
    void Function()? onClose}) {
  return Get.dialog(
    AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      contentPadding: const EdgeInsets.only(top: 10, left: 15, right: 15),
      titlePadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      iconPadding: const EdgeInsets.only(bottom: 5, top: 15),
      actionsPadding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
      icon: Center(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: FaIcon(
                icon,
                color: Get.theme.canvasColor,
                size: 45,
              ),
            ),
          ),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      content: Text(
        body,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      actions: [
        ...?actions,
        TextButton(
          child: Text("close".tr),
          onPressed: () {
            Get.back();
            onClose?.call();
          },
        ),
      ],
    ),
  );
}
