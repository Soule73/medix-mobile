import 'dart:convert';

import 'package:get/get.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/models/doctor_model.dart';
import 'package:medix/models/link_model.dart';
import 'package:medix/models/review_ratings.dart';
import 'package:medix/models/schedule_model.dart';
import 'package:medix/services/perform_request.dart';
import 'package:medix/utils/utils.dart';

class ApiDoctor {
  /// Récupère la liste des médecins en fonction des critères de recherche et de spécialité.
  /// [search] Le terme de recherche pour le nom du médecin.
  /// [specialitiesIds] Les identifiants des spécialités recherchées.
  /// [specialityId] L'identifiant de la spécialité spécifique.
  /// [urlFetch] L'URL optionnelle pour la pagination.
  /// Retourne une liste d'objets [Doctor].
  Future<List<Doctor>> fetchDoctors(
      {String? search = '',
      List<String>? specialitiesIds,
      String? specialityId,
      String? urlFetch}) async {
    String specialities =
        specialitiesIds!.isNotEmpty ? jsonEncode(specialitiesIds) : '';
    String endpoint = urlFetch != null
        ? urlFetch.replaceFirst('http', 'https')
        : '/doctor?name=$search&specialityId=$specialityId&specialities_ids=$specialities';
    String? token = await getToken();
    return await performRequest(
          endpoint: endpoint,
          headers: buildHeader(token: token),
          method: 'POST',
          onSuccess: (dynamic data, int statusCode) {
            final List<dynamic> doctorList = data['data'];
            final List<Doctor> doctors =
                doctorList.map((e) => Doctor.fromJson(e)).toList();
            // Gérer la pagination
            final List<dynamic> linkList = data['meta']['links'];

            final List<Link> pagiantion =
                linkList.map((e) => Link.fromJson(e)).toList();

            Get.find<DoctorController>().linksList.value = pagiantion;
            return doctors;
          },
          onError: (String error, int statusCode) => [],
        ) ??
        [];
  }

  /// Récupère la liste des médecins favoris de l'utilisateur.
  /// [favoris] La liste des identifiants des médecins favoris.
  /// Retourne une liste d'objets [Doctor].
  Future<List<Doctor>> fetchFavoris({List<String>? favoris}) async {
    return await performRequest(
          endpoint: '/auth/user/favoris?doctorsId=${jsonEncode(favoris)}',
          headers: buildHeader(token: await getToken()),
          method: 'POST',
          onSuccess: (dynamic data, int statusCode) {
            final List<dynamic> doctorList = data['data'];
            final List<Doctor> doctors =
                doctorList.map((e) => Doctor.fromJson(e)).toList();
            return doctors;
          },
          onError: (String error, int statusCode) => [],
        ) ??
        [];
  }

  /// Récupère les détails d'un médecin spécifique, y compris les horaires de travail et les évaluations.
  /// [doctorId] L'identifiant du médecin.
  /// [token] Le token d'authentification de l'utilisateur.
  /// Retourne `void`.
  Future<void> fetchDoctorDetails({String? doctorId = ''}) async {
    String? token = await getToken();
    await performRequest(
      endpoint: '/doctor/$doctorId',
      headers: buildHeader(token: token),
      method: 'POST',
      onSuccess: (dynamic data, int statusCode) {
        final Map<String, dynamic> workingHoursList =
            data['data']['working_hours'];
        final List<dynamic> reviewRatingsList = data['data']['review_ratings'];

        final List<Review> reviewRatings =
            reviewRatingsList.map((e) => Review.fromJson(e)).toList();

        WeeklySchedule weeklySchedule =
            WeeklySchedule.fromJson(workingHoursList);

        Get.find<DoctorController>().weeklySchedule.value = weeklySchedule;
        Get.find<DoctorController>().reviewRatings.value = reviewRatings;
      },
    );
  }

  /// Ajoute ou met à jour une évaluation pour un médecin.
  /// [credential] Les données nécessaires pour l'évaluation.
  /// [path] Le chemin de l'API pour l'ajout ou la mise à jour.
  /// [alert] Indique si un message d'alerte doit être affiché en cas d'erreur.
  /// [successMsg] Le message de succès personnalisé.
  /// Retourne un objet [ReviewRating] ou null en cas d'échec.
  Future<ReviewRating?> addOrUpdateDoctorRate(
      {required Map credential,
      String? path,
      bool alert = true,
      String? successMsg}) async {
    final body = json.encode(credential);
    final headers = buildHeader(token: await getToken());

    return await performRequest(
      endpoint: path ?? '/review-rating/store',
      headers: headers,
      body: body,
      method: path != null ? 'PATCH' : 'POST',
      onSuccess: (dynamic data, int statusCode) => ReviewRating.fromJson(data),
      onError: (String error, int statusCode) => null,
    );
  }

  /// Supprime une évaluation pour un médecin.
  /// [id] L'identifiant de l'évaluation à supprimer.
  /// Retourne un booléen indiquant le succès ou l'échec de l'opération.
  Future<bool> deleteRate({required int id}) async {
    final headers = buildHeader(token: await getToken());

    return await performRequest(
          endpoint: '/review-rating/delete/$id',
          headers: headers,
          method: 'DELETE',
          onSuccess: (dynamic data, int statusCode) => true,
          onError: (String error, int statusCode) => false,
        ) ??
        false;
  }
}
