import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/auth/auth.dart';

/// Contrôleur pour la mise à jour du mot de passe utilisateur.
///
/// Permet de mettre à jour le mot de passe de l'utilisateur après avoir vérifié
/// le mot de passe actuel. Utilise le package GetX pour la gestion d'état.
class UpdatePasswordController extends GetxController {
  /// Contrôleur pour le nouveau mot de passe.
  final TextEditingController userPassword = TextEditingController();

  /// Contrôleur pour le mot de passe actuel.
  final TextEditingController userCurrentPassword = TextEditingController();

  /// Contrôleur pour la confirmation du nouveau mot de passe.
  final TextEditingController userPasswordConfirm = TextEditingController();

  /// Met à jour le mot de passe de l'utilisateur.
  ///
  /// Prend le nouveau mot de passe et le mot de passe actuel, puis appelle
  /// [Auth.updateUserPassword] pour effectuer la mise à jour. Si la mise à jour
  /// est réussie, réinitialise les contrôleurs de texte.
  Future<void> updatePassword() async {
    Map<String, dynamic> user = {
      'password': userPassword.text,
      'current_password': userCurrentPassword.text,
    };

    // Appel à la méthode d'authentification pour mettre à jour le mot de passe.
    bool success = await Get.find<Auth>().updateUserPassword(credential: user);

    // Si la mise à jour est réussie, réinitialise les valeurs des contrôleurs.
    if (success) {
      userCurrentPassword.text = '';
      userPasswordConfirm.text = '';
      userPassword.text = '';
    }
  }
}
