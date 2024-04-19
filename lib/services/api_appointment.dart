import 'dart:convert';

import 'package:get/get.dart';
import 'package:medix/controllers/appointment_controller.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/models/link_model.dart';
import 'package:medix/services/perform_request.dart';
import 'package:medix/utils/utils.dart';

class ApiAppointment {
  /// Récupère la liste des rendez-vous de l'utilisateur en fonction du statut.
  /// [status] Le statut des rendez-vous à récupérer (par défaut "pending").
  /// [urlFetch] L'URL optionnelle pour la pagination.
  /// Retourne une liste d'objets [Appointment].
  Future<List<Appointment>> fetchUserAppointment(
      {String? status = "pending", String? urlFetch}) async {
    String endpoint = urlFetch != null
        ? urlFetch.replaceFirst('http', 'https')
        : '/appointment?status=$status';
    String? token = await getToken();

    return await performRequest(
          endpoint: endpoint,
          headers: buildHeader(token: token),
          onSuccess: (dynamic data, int statusCode) {
            final List<dynamic> appointmentsList = data['data'];
            final List<Appointment> appointments =
                appointmentsList.map((e) => Appointment.fromJson(e)).toList();
            // Gérer la pagination
            final List<dynamic> linkList = data['meta']['links'];

            final List<Link> pagiantion =
                linkList.map((e) => Link.fromJson(e)).toList();

            Get.find<AppointmentController>().linksList.value = pagiantion;
            return appointments;
          },
          onError: (String error, int statusCode) => [],
        ) ??
        [];
  }

  /// Crée un nouveau rendez-vous avec les informations fournies.
  /// [credential] Les données nécessaires pour créer un rendez-vous.
  /// Retourne un objet [Appointment] ou null en cas d'échec.
  Future<Appointment?> newAppointment({required Map credential}) async {
    final body = json.encode(credential);
    String endpoint = '/appointment/store';
    String? token = await getToken();

    return await performRequest(
      endpoint: endpoint,
      headers: buildHeader(token: token),
      body: body,
      onSuccess: (dynamic data, int statusCode) => Appointment.fromJson(data),
      onError: (String error, int statusCode) => null,
    );
  }

  /// Met à jour un rendez-vous existant avec les informations fournies.
  /// [appointmentId] L'identifiant du rendez-vous à mettre à jour.
  /// [credential] Les données mises à jour pour le rendez-vous.
  /// Retourne un objet [Appointment] ou null en cas d'échec.
  Future<Appointment?> updateAppointment(
      {required int appointmentId, required Map credential}) async {
    final body = json.encode(credential);
    String endpoint = '/appointment/update/$appointmentId';
    String? token = await getToken();

    return await performRequest(
      endpoint: endpoint,
      headers: buildHeader(token: token),
      body: body,
      method: 'PATCH',
      onSuccess: (dynamic data, int statusCode) => Appointment.fromJson(data),
      onError: (String error, int statusCode) => null,
    );
  }

  /// Supprime un rendez-vous existant.
  /// [appointmentId] L'identifiant du rendez-vous à supprimer.
  /// Retourne un booléen indiquant le succès ou l'échec de l'opération.
  Future<bool> deleteAppointment({required int appointmentId}) async {
    String endpoint = '/appointment/delete/$appointmentId';
    String? token = await getToken();
    Map<String, String> headers = buildHeader(token: token);

    return await performRequest(
          endpoint: endpoint,
          headers: headers,
          method: 'DELETE',
          onSuccess: (dynamic data, int statusCode) => true,
          onError: (String error, int statusCode) => false,
        ) ??
        false;
  }
}
