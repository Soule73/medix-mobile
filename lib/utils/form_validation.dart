import 'package:get/get.dart';
import 'package:medix/controllers/lang_controller.dart';

/// Valide le mot de passe en vérifiant s'il est non vide et d'au moins 8 caractères.
///
/// [value] La valeur du mot de passe à valider.
/// Retourne une chaîne localisée indiquant l'erreur ou null si le mot de passe est valide.
String? validPassword(value) {
  if (value == null || value.isEmpty) {
    return "password-required".tr;
  }
  if (value.length < 8) {
    return "password-min".trParams({'min': '8'});
  }
  return null;
}

/// Valide la confirmation du mot de passe en vérifiant si elle correspond au mot de passe.
///
/// [value] La valeur de la confirmation du mot de passe à valider.
/// [compare] La valeur du mot de passe original à comparer.
/// Retourne une chaîne localisée indiquant l'erreur ou null si les mots de passe correspondent.
String? validPassworddConfirm({String? value, String? compare}) {
  if (value == null || value.isEmpty) {
    return "confirm-password".tr;
  }
  if (value != compare) {
    return "password-not-match".tr;
  }
  return null;
}

/// Fournit le texte d'aide pour le format de la date de naissance en fonction de la langue.
///
/// Retourne une chaîne indiquant le format de la date de naissance attendu.
String birthdayHelperText() {
  return Get.find<LangController>().lang.value == 'en'
      ? 'yyyy/MM/DD'
      : 'DD/MM/yyyy';
}

/// Valide la date de naissance en vérifiant si elle est non nulle.
///
/// [value] La valeur de la date de naissance à valider.
/// Retourne une chaîne localisée indiquant l'erreur ou null si la date de naissance est valide.
String? validBirthay(DateTime? value) {
  if (value == null || value.toString() == '') {
    return "your-birthday".tr;
  }
  return null;
}

/// Valide le sexe de l'utilisateur en vérifiant s'il est non vide.
///
/// [value] La valeur du sexe à valider.
/// Retourne une chaîne localisée indiquant l'erreur ou null si le sexe est valide.
String? validUserSex(value) => valid(value, 'your-gender'.tr);

/// Valide le prénom de l'utilisateur en vérifiant s'il est non vide.
///
/// [value] La valeur du prénom à valider.
/// Retourne une chaîne localisée indiquant l'erreur ou null si le prénom est valide.
String? validFisrtName(value) => valid(value, "enter-your-firstname".tr);

/// Valide le nom de famille de l'utilisateur en vérifiant s'il est non vide.
///
/// [value] La valeur du nom de famille à valider.
/// Retourne une chaîne localisée indiquant l'erreur ou null si le nom de famille est valide.
String? validLastName(value) => valid(value, "enter-your-last-name".tr);

/// Valide la ville de l'utilisateur en vérifiant si elle est non vide.
///
/// [value] La valeur de la ville à valider.
/// Retourne une chaîne localisée indiquant l'erreur ou null si la ville est valide.
String? validCity(value) => valid(value, "enter-your-city".tr);

/// Valide une valeur en vérifiant si elle est non vide.
///
/// [value] La valeur à valider.
/// [errorText] Le texte d'erreur à retourner si la valeur est vide.
/// Retourne une chaîne localisée indiquant l'erreur ou null si la valeur est valide.
String? valid(value, errorText) {
  if (value == null || value.isEmpty) {
    return errorText;
  }
  return null;
}
