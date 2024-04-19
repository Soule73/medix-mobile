import 'package:get/get.dart';
import 'package:medix/controllers/notification_controller.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/models/link_model.dart';
import 'package:medix/models/notification_model.dart';
import 'package:medix/services/perform_request.dart';
import 'package:medix/utils/utils.dart';

class ApiNotification {
  /// Récupère la liste des notifications pour un patient.
  /// [urlFetch] L'URL optionnelle pour la pagination.
  /// Retourne une liste d'objets [Notification].
  Future<List<Notification>> fetchPatientNotification(
      {String? urlFetch}) async {
    String endpoint = urlFetch != null
        ? urlFetch.replaceAll('http', 'https')
        : '/notification';
    String? token = await getToken();

    try {
      return await performRequest(
        endpoint: endpoint,
        headers: buildHeader(token: token),
        onSuccess: (dynamic data, int statusCode) {
          final List<dynamic> notificationsList = data['data'];
          final List<Notification> notifications =
              notificationsList.map((e) => Notification.fromJson(e)).toList();
          // Gérer la pagination
          final List<dynamic> linkList = data['meta']['links'];

          final List<Link> pagiantion =
              linkList.map((e) => Link.fromJson(e)).toList();

          Get.find<NotificationController>().linksList.value = pagiantion;
          return notifications;
        },
        onError: (String data, int code) => [],
      );
    } catch (_) {}

    return [];
  }

  /// Trouve un rendez-vous spécifique par son identifiant concernant une notification.
  /// [appointmentId] L'identifiant du rendez-vous à trouver.
  /// Retourne un objet [Appointment] ou null en cas d'échec.
  Future<Appointment?> findAppointment({required int appointmentId}) async {
    String endpoint = '/appointment/$appointmentId';
    String? token = await getToken();

    return await performRequest(
      endpoint: endpoint,
      headers: buildHeader(token: token),
      onSuccess: (dynamic data, int statusCode) => Appointment.fromJson(data),
      onError: (String data, int code) => null,
    );
  }

  /// Marque une notification comme lue.
  /// [notificationId] L'identifiant de la notification à marquer comme lue.
  /// Retourne une liste mise à jour d'objets [Notification].
  Future<List<Notification>> notificationMarkAsRead(
      {required String notificationId}) async {
    String endpoint = '/notification/mark-as-read/$notificationId';
    String? token = await getToken();

    try {
      return await performRequest(
        endpoint: endpoint,
        headers: buildHeader(token: token),
        method: 'PATCH',
        onSuccess: (dynamic data, int statusCode) {
          final List<dynamic> notificationsList = data['data'];
          final List<Notification> notifications =
              notificationsList.map((e) => Notification.fromJson(e)).toList();
          // Gérer la pagination
          final List<dynamic> linkList = data['meta']['links'];

          final List<Link> pagiantion =
              linkList.map((e) => Link.fromJson(e)).toList();

          Get.find<NotificationController>().linksList.value = pagiantion;
          return notifications;
        },
        onError: (String data, int code) {
          // Gérer l'erreur
        },
      );
    } catch (_) {}
    return [];
  }

  /// Supprime une notification.
  /// [notificationId] L'identifiant de la notification à supprimer.
  /// Retourne une liste mise à jour d'objets [Notification].
  Future<List<Notification>> notificationDelete(
      {required String notificationId}) async {
    String endpoint = '/notification/delete/$notificationId';
    String? token = await getToken();
    Map<String, String> headers = buildHeader(token: token);

    try {
      return await performRequest(
        endpoint: endpoint,
        headers: headers,
        method: 'DELETE',
        onSuccess: (dynamic data, int statusCode) {
          final List<dynamic> notificationsList = data['data'];
          final List<Notification> notifications =
              notificationsList.map((e) => Notification.fromJson(e)).toList();
          // Gérer la pagination
          final List<dynamic> linkList = data['meta']['links'];

          final List<Link> pagiantion =
              linkList.map((e) => Link.fromJson(e)).toList();

          Get.find<NotificationController>().linksList.value = pagiantion;
          return notifications;
        },
        onError: (String error, int statusCode) {
          // Gérer l'erreur
        },
      );
    } catch (_) {}

    return [];
  }
}
