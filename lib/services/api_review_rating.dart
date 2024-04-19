import 'package:get/get.dart';
import 'package:medix/controllers/review_rating_controller.dart';
import 'package:medix/models/link_model.dart';
import 'package:medix/models/review_ratings.dart';
import 'package:medix/services/perform_request.dart';
import 'package:medix/utils/utils.dart';

class ApiReviewRating {
  /// Récupère la liste des évaluations et commentaires.
  /// [search] Le terme de recherche pour filtrer les évaluations (facultatif).
  /// [specialitiesIds] Les identifiants des spécialités pour filtrer les évaluations (facultatif).
  /// [urlFetch] L'URL optionnelle pour la pagination.
  /// Retourne une liste d'objets [Review].
  Future<List<Review>> fetchReviews(
      {String? search = '',
      List<String>? specialitiesIds,
      String? urlFetch}) async {
    // Définition de l'endpoint en fonction de la présence d'une URL pour la pagination ou des paramètres de recherche.
    String endpoint = urlFetch != null
        ? urlFetch.replaceAll('http', 'https')
        : '/review-rating';

    // Obtention du token d'authentification.
    final String? token = await getToken();

    // Construction des headers pour la requête.
    Map<String, String> headers = buildHeader(token: token);

    // Exécution de la requête et traitement de la réponse ou des erreurs.
    return await performRequest(
          endpoint: endpoint,
          headers: headers,
          onSuccess: (dynamic data, int statusCode) {
            // Conversion des données reçues en liste d'objets [Review].
            final List<dynamic> reviewList = data['data'];
            final List<Review> reviews =
                reviewList.map((e) => Review.fromJson(e)).toList();

            // Gestion de la pagination en récupérant les liens depuis les métadonnées.
            final List<dynamic> linkList = data['meta']['links'];
            final List<Link> pagiantion =
                linkList.map((e) => Link.fromJson(e)).toList();

            // Mise à jour de la liste des liens de pagination dans le contrôleur [ReviewRatingController].
            Get.find<ReviewRatingController>().linksList.value = pagiantion;

            return reviews;
          },
          onError: (String error, int statusCode) => [],
        ) ??
        [];
  }
}
