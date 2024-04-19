import 'package:medix/models/specility_model.dart';
import 'package:medix/services/perform_request.dart';
import 'package:medix/utils/utils.dart';

class ApiSpeciality {
  /// Récupère la liste des spécialités médicales.
  ///
  /// Effectue une requête GET vers l'endpoint '/doctor/specialities' pour obtenir les spécialités.
  /// Utilise un token d'authentification pour accéder à l'API.
  /// Retourne une liste d'objets [Speciality] ou une liste vide en cas d'erreur.
  Future<List<Speciality>> fetchSpecialities() async {
    // Définition de l'endpoint de l'API pour les spécialités.
    String endpoint = '/doctor/specialities';

    // Obtention du token d'authentification.
    String? token = await getToken();

    // Construction des headers pour la requête avec le token.
    Map<String, String> headers = buildHeader(token: token);

    // Vérification de la présence du token avant de faire la requête.
    if (token != null) {
      // Exécution de la requête et traitement de la réponse ou des erreurs.
      return await performRequest(
        endpoint: endpoint,
        headers: headers,
        onSuccess: (dynamic data, int statusCode) {
          // Conversion des données reçues en liste d'objets [Speciality].
          List<dynamic> specialityMaps = data;
          final List<Speciality> specialities =
              specialityMaps.map((e) => Speciality.fromJson(e)).toList();
          return specialities;
        },
        onError: (String error, int statusCode) => [],
      );
    }
    // Retour d'une liste vide si le token est null.
    return [];
  }
}
