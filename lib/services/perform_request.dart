import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:medix/constants/constants.dart';
import 'package:medix/controllers/lang_controller.dart';

/// Effectue une requête HTTP vers l'endpoint spécifié.
///
/// [endpoint] L'endpoint de l'API à appeler.
/// [headers] Les en-têtes de la requête HTTP.
/// [onSuccess] La fonction de rappel en cas de succès de la requête.
/// [body] Le corps de la requête pour les méthodes POST, PATCH, PUT, DELETE.
/// [onError] La fonction de rappel en cas d'erreur de la requête.
/// [method] La méthode HTTP à utiliser (par défaut 'POST').
/// Retourne une réponse dynamique ou null en cas d'échec.
Future<dynamic> performRequest(
    {required String endpoint,
    required Map<String, String> headers,
    required Function(dynamic data, int statusCode) onSuccess,
    String? body,
    Function(String error, int statusCode)? onError,
    String method = 'POST'}) async {
  try {
    // Construction de l'URI pour la requête.
    Uri uri = Uri.parse("$apiURL$endpoint");
    late final http.Response response;

    // Sélection de la méthode HTTP et exécution de la requête.
    switch (method) {
      case 'GET':
        response = await http.get(uri, headers: headers);
        break;
      case 'POST':
        response = await http.post(uri, headers: headers, body: body);
        break;
      case 'PATCH':
        response = await http.patch(uri, headers: headers, body: body);
        break;
      case 'PUT':
        response = await http.put(uri, headers: headers, body: body);
        break;
      case 'DELETE':
        response = await http.delete(uri, headers: headers, body: body);
        break;
      default:
        throw 'Method not supported';
    }

    // Traitement de la réponse en fonction du code de statut.
    if (response.statusCode.toString().startsWith("20")) {
      // Appel de la fonction de succès si le code de statut commence par "20".
      return onSuccess(jsonDecode(response.body), response.statusCode);
    } else if (response.statusCode.toString().startsWith("40") ||
        response.statusCode.toString().startsWith("50")) {
      // Appel de la fonction d'erreur si le code de statut commence par "40" ou "50".
      onError?.call(jsonDecode(response.body), response.statusCode);
    }
  } catch (e) {
    // Appel de la fonction d'erreur en cas d'exception.
    onError?.call("error", 500);
  }
  return null;
}

/// Construit les en-têtes pour une requête HTTP.
///
/// [token] Le jeton d'authentification à inclure dans les en-têtes.
/// Retourne un dictionnaire des en-têtes HTTP.
Map<String, String> buildHeader({String? token, String? local}) {
  String? lang = local;
  // Obtention de la langue actuelle à partir du contrôleur de langue.
  // String? lang = Get.find<LangController>().lang.value;
  if (local == null) {
    lang = Get.find<LangController>().lang.value;
  }

  // Construction des en-têtes avec le type de contenu, la langue et le jeton d'autorisation.
  return {
    'Content-Type': 'application/json',
    if (['ar', 'en', 'fr'].contains(lang)) 'Accept-Language': lang ?? 'fr',
    if (token != null) 'Authorization': 'Bearer $token'
  };
}
