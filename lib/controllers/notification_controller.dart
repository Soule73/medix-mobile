import 'package:get/get.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/models/link_model.dart';
import 'package:medix/models/notification_model.dart';
import 'package:medix/screens/appointment/appointment_detail_screen.dart';
import 'package:medix/screens/appointment/review_controller.dart';
import 'package:medix/services/api_notification.dart';
import 'package:medix/utils/alert_dialog.dart';

/// Contrôleur pour la gestion des notifications des patients.
///
/// Permet de récupérer et de gérer les notifications liées aux rendez-vous des patients.
/// Utilise le package GetX pour la gestion d'état.
class NotificationController extends GetxController {
  /// Instance de l'API pour les requêtes concernant les notifications.
  ApiNotification apiNotification = ApiNotification();

  /// Liste observable des liens de pagination.
  RxList<Link> linksList = <Link>[].obs;

  /// Liste observable des notifications.
  Rx<List<Notification?>> notificationList = Rx<List<Notification?>>([]);

  /// Observable pour l'état de chargement des notifications.
  RxBool isLoad = false.obs;

  /// Observable pour le nombre de notifications non lues.
  RxInt unreadCount = 0.obs;

  /// Initialisation du contrôleur.
  ///
  /// Lance la récupération des notifications du patient dès l'initialisation du contrôleur.
  @override
  void onInit() {
    super.onInit();

    getPatientNotification();
  }

  /// Récupère les notifications du patient.
  ///
  /// [url] L'URL optionnelle pour la pagination.
  /// Retourne `void`.
  Future<void> getPatientNotification([String? url]) async {
    isLoad.value = true;
    notificationList.value =
        await apiNotification.fetchPatientNotification(urlFetch: url);
    notificationList.value =
        await apiNotification.fetchPatientNotification(urlFetch: url);
    isLoad.value = false;
    unreadCount.value = countUnreadNotifications(notificationList.value);
  }

  /// Trouve un rendez-vous à partir d'une notification.
  ///
  /// [notificationId] L'identifiant de la notification.
  /// [appointmentId] L'identifiant du rendez-vous.
  /// [index] L'index de la notification dans la liste.
  /// Retourne `void`.
  Future<void> findAppointment(
      {required String notificationId,
      required int appointmentId,
      required int index}) async {
    Appointment? appointment =
        await apiNotification.findAppointment(appointmentId: appointmentId);
    if (appointment != null) {
      Get.find<ReviewIsEmpty>().appointment.value = appointment;

      Get.to(() => AppointmentDetailScreen());
      notificationMarkAsRead(notificationId: notificationId, index: index);
    } else {
      errorDialog(
          title: 'something-went-wrong-title'.tr,
          body: "something-went-wrong".tr);
      await notificationDelete(notificationId: notificationId, index: index);
    }
  }

  /// Marque une notification comme lue.
  ///
  /// [notificationId] L'identifiant de la notification à marquer comme lue.
  /// [index] L'index de la notification dans la liste.
  /// Retourne `void`.
  Future<void> notificationMarkAsRead(
      {required String notificationId, required int index}) async {
    if (notificationList.value[index]?.readAt == null) {
      notificationList.value[index]?.readAt = DateTime.now().toString();

      final List<Notification> notifications = await apiNotification
          .notificationMarkAsRead(notificationId: notificationId);
      if (notifications.isNotEmpty) {
        notificationList.value = notifications;
      }
      unreadCount.value = countUnreadNotifications(notificationList.value);
    }
  }

  /// Supprime une notification.
  ///
  /// [notificationId] L'identifiant de la notification à supprimer.
  /// [index] L'index de la notification dans la liste.
  /// Retourne `void`.
  Future<void> notificationDelete(
      {required String notificationId, required int index}) async {
    if (notificationList.value[index] != null) {
      notificationList.value.removeAt(index);

      notificationList.value = await apiNotification.notificationDelete(
          notificationId: notificationId);

      unreadCount.value = countUnreadNotifications(notificationList.value);
    }
  }

  /// Compte le nombre de notifications non lues.
  ///
  /// [notifications] La liste des notifications à vérifier.
  /// Retourne `int` qui est le nombre de notifications non lues.
  int countUnreadNotifications(List<Notification?> notifications) {
    return notifications
        .where((notification) => notification?.readAt == null)
        .length;
  }
}
