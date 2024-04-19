import 'dart:convert';

import 'package:get/get.dart';
import 'package:medix/models/user.dart';
import 'package:medix/services/perform_request.dart';
import 'package:medix/utils/alert_dialog.dart';
import 'package:medix/utils/utils.dart';

class ApiAuth {
  /// Enregistre un nouvel utilisateur avec les informations fournies.
  /// [credential] Les données nécessaires pour l'enregistrement.
  /// Retourne le token d'authentification ou null en cas d'échec.
  Future<String?> register({required Map<String, dynamic> credential}) async {
    final body = json.encode(credential);

    return await performRequest(
        endpoint: '/user/register',
        headers: buildHeader(token: null),
        body: body,
        onSuccess: (dynamic data, int statusCode) => data['token'],
        onError: (String error, int statusCode) {
          errorDialog(title: 'something-went-wrong-title'.tr, body: error);
          return null;
        });
  }

  /// Connecte un utilisateur avec les informations fournies.
  /// [credential] Les données nécessaires pour la connexion.
  /// Retourne le token d'authentification ou null en cas d'échec.
  Future<String?> login({required Map<String, dynamic> credential}) async {
    final String body = json.encode(credential);

    return await performRequest(
        endpoint: '/auth/token',
        headers: buildHeader(token: null),
        body: body,
        onSuccess: (dynamic data, int statusCode) => data['token'],
        onError: (data, code) {
          if (code == 401 || code == 402) {
            errorDialog(title: 'something-went-wrong-title'.tr, body: data);
          } else {
            defaultErrorDialog();
          }
          return null;
        });
  }

  /// Met à jour les informations d'un utilisateur.
  /// [credential] Les données mises à jour de l'utilisateur.
  /// [path] Le chemin de l'API pour la mise à jour.
  /// [alert] Indique si un message d'alerte doit être affiché en cas d'erreur.
  /// Retourne un objet [User] ou null en cas d'échec.
  Future<User?> updateUser({
    required Map<String, dynamic> credential,
    String path = '/auth/user/update',
    bool alert = true,
  }) async {
    final body = json.encode(credential);
    final String? token = await getToken();

    return await performRequest(
        endpoint: path,
        headers: buildHeader(token: token),
        body: body,
        method: 'PATCH',
        onSuccess: (dynamic data, int statusCode) => User.fromJson(data),
        onError: alert
            ? (String error, int statusCode) {
                errorDialog(
                    title: 'something-went-wrong-title'.tr, body: error);
              }
            : null);
  }

  /// Met à jour le mot de passe de l'utilisateur.
  /// [credential] Les données nécessaires pour la mise à jour du mot de passe.
  /// Retourne un booléen indiquant le succès ou l'échec de l'opération.
  Future<bool> updateUserPassword(
      {required Map<String, dynamic> credential}) async {
    final body = json.encode(credential);
    final String? token = await getToken();

    return await performRequest(
            endpoint: '/auth/user/update/password',
            headers: buildHeader(token: token),
            body: body,
            method: 'PATCH',
            onSuccess: (dynamic data, int statusCode) => true,
            onError: (String error, int statusCode) {
              errorDialog(title: 'something-went-wrong-title'.tr, body: error);
            }) ??
        false;
  }

  /// Vérifie l'utilisateur avec les informations fournies.
  /// [credential] Les données nécessaires pour la vérification.
  /// [alert] Indique si un message d'alerte doit être affiché en cas d'erreur.
  /// Retourne un booléen indiquant le succès ou l'échec de la vérification.
  Future<bool?> verifyUser(
      {required Map<String, dynamic> credential, bool alert = true}) async {
    final body = json.encode(credential);

    return await performRequest(
        endpoint: '/auth/verify',
        headers: buildHeader(token: null),
        body: body,
        method: 'POST',
        onSuccess: (dynamic data, int statusCode) => data['success'],
        onError: (String error, int statusCode) {
          if (alert) {
            errorDialog(title: 'something-went-wrong-title'.tr, body: error);
          }
        });
  }

  /// Réinitialise le mot de passe de l'utilisateur.
  /// [credential] Les données nécessaires pour la réinitialisation du mot de passe.
  /// Retourne le token d'authentification ou null en cas d'échec.
  Future<String?> resetUserPassword(
      {required Map<String, dynamic> credential}) async {
    final body = json.encode(credential);

    return await performRequest(
        endpoint: '/auth/reset-password',
        headers: buildHeader(token: null),
        body: body,
        method: 'PATCH',
        onSuccess: (dynamic data, int statusCode) => data['token'],
        onError: (data, code) {
          if (code == 401 || code == 402) {
            errorDialog(
              title: 'something-went-wrong-title'.tr,
              body: data,
            );
          } else {
            defaultErrorDialog();
          }
        });
  }

  /// Tente de récupérer les informations de l'utilisateur avec le token fourni.
  /// [token] Le token d'authentification de l'utilisateur.
  /// Retourne un objet [User] ou null en cas d'échec.
  Future<User?> attempt({String? token}) async {
    return await performRequest(
        endpoint: '/auth/user',
        headers: buildHeader(token: token),
        method: 'POST',
        onSuccess: (dynamic data, int statusCode) => User.fromJson(data),
        onError: (error, statusCode) => null);
  }

  /// Déconnecte l'utilisateur.
  /// Retourne un booléen indiquant le succès ou l'échec de l'opération.
  Future<bool> logout() async {
    final String? token = await getToken();

    return await performRequest(
            endpoint: '/auth/user/token/delete',
            headers: buildHeader(token: token),
            method: 'DELETE',
            onSuccess: (dynamic data, int statusCode) => true,
            onError: (error, statusCode) => false) ??
        false;
  }

  /// Supprime le compte de l'utilisateur.
  /// Retourne un booléen indiquant le succès ou l'échec de l'opération.
  Future<bool> destroy() async {
    final String? token = await getToken();

    return await performRequest(
            endpoint: '/auth/user/delete',
            headers: buildHeader(token: token),
            method: 'DELETE',
            onSuccess: (dynamic data, int statusCode) => statusCode == 204,
            onError: (error, statusCode) => false) ??
        false;
  }
}
