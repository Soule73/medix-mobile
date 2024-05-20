import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/models/link_model.dart';
import 'package:medix/models/review_ratings.dart';
import 'package:medix/screens/profile/reviews_screen.dart';
import 'package:medix/services/api_doctor.dart';
import 'package:medix/services/api_review_rating.dart';
import 'package:medix/utils/alert_dialog.dart';

/// Contrôleur pour la gestion des évaluations et commentaires des médecins.
///
/// Permet aux utilisateurs de soumettre des évaluations et des commentaires sur les médecins,
/// ainsi que de gérer les évaluations existantes. Utilise le package GetX pour la gestion d'état.
class ReviewRatingController extends GetxController {
  /// Instance de l'API pour les requêtes concernant les évaluations.
  ApiReviewRating apiReviewRating = ApiReviewRating();

  /// Observable pour l'état de chargement des évaluations.
  RxBool isLoad = false.obs;

  /// Liste observable des évaluations.
  Rx<List<Review>> reviewsList = Rx<List<Review>>([]);

  /// Liste observable des liens de pagination.
  RxList<Link> linksList = <Link>[].obs;

  /// Récupère les évaluations des médecins dès l'initialisation du contrôleur.
  @override
  void onInit() async {
    super.onInit();
    await fetchReview();
  }

  /// Récupère les évaluations des médecins.
  ///
  /// Retourne `void`.
  Future<void> fetchReview() async {
    isLoad.value = true;
    reviewsList.value = await apiReviewRating.fetchReviews();
    isLoad.value = false;
  }

  /// Observable pour le nombre d'étoiles donné par l'utilisateur.
  RxInt star = 0.obs;

  /// Contrôleur pour le commentaire de l'utilisateur.
  TextEditingController comment = TextEditingController();

  /// Instance de l'API pour les requêtes concernant les médecins.
  ApiDoctor apiDoctor = ApiDoctor();

  /// Évalue un médecin en ajoutant ou en mettant à jour une évaluation.
  ///
  /// [id] L'identifiant du médecin à évaluer.
  /// [data] Les données de l'évaluation à soumettre.
  /// Retourne `void`.
  Future<void> rateDoctor(
      {required int id, required Map<String, dynamic> data}) async {
    isLoad.value = true;
    final ReviewRating? review = await apiDoctor.addOrUpdateDoctorRate(
        credential: data, path: "/review-rating/update/$id");
    if (review != null) {
      successDialog(
          onClose: () => Get.to(() => ReviewsScreen()),
          title: "success".tr,
          body: "review-update".tr);
    } else {
      defaultErrorDialog();
    }
    isLoad.value = false;

    await fetchReview();
  }

  /// Supprime une évaluation.
  ///
  /// [review] L'évaluation à supprimer.
  /// Retourne `void`.
  Future<void> deleteReview({required Review review}) async {
    reviewsList.value.remove(review);
    int? reviewId = review.id;
    if (reviewId != null) {
      final bool success = await apiDoctor.deleteRate(id: reviewId);
      if (success) {
        successDialog(title: "success".tr, body: "review-delete".tr);
        await fetchReview();
      } else {
        defaultErrorDialog();
        reviewsList.value.add(review);
      }
    } else {
      defaultErrorDialog();
    }
  }
}
