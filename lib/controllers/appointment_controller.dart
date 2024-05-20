import 'package:get/get.dart';
import 'package:medix/controllers/appointment_detail_controller.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/models/link_model.dart';
import 'package:medix/screens/appointment/appointment_screen.dart';
import 'package:medix/services/api_appointment.dart';
import 'package:medix/utils/alert_dialog.dart';

/// La classe `AppointmentController` dans Dart définit des variables et des fonctions pour gérer les utilisateurs
/// rendez-vous, y compris la récupération des rendez-vous en fonction du statut et la gestion des rendez-vous
/// annulations.
class AppointmentController extends GetxController {
  RxBool isLoad = false.obs;
  RxBool isLoadDeleting = false.obs;
  RxBool isLoadConfirm = false.obs;
  ApiAppointment apiAppointment = ApiAppointment();
  Rx<List<Appointment?>> appointmentList = Rx<List<Appointment?>>([]);
  RxList<Link> linksList = <Link>[].obs;

  /// La fonction `fetchUserAppointment` récupère les rendez-vous des utilisateurs avec un statut spécifié et les met à jour
  /// la liste de rendez-vous en conséquence.
  ///
  /// Arguments :
  /// status (String) : Le paramètre `status` dans la fonction `fetchUserAppointment` est un type String
  /// paramètre avec une valeur par défaut de "en attente". Il est utilisé pour spécifier le statut de l'utilisateur
  /// rendez-vous en cours de récupération. Si aucune valeur n'est fournie lors de l'appel de la fonction, elle sera
  /// par défaut "en attente". Par défaut, en attente
  /// url (String) : Le paramètre `url` dans la fonction `fetchUserAppointment` est un type String
  /// paramètre qui représente l'URL utilisée pour récupérer les rendez-vous des utilisateurs. C'est un paramètre facultatif,
  /// ce qui signifie qu'il peut être fourni lors de l'appel de la fonction mais n'est pas obligatoire.
  Future<void> fetchUserAppointment(
      {String? status = "pending", String? url}) async {
    isLoad.value = true;
    appointmentList.value = [];
    appointmentList.value =
        await apiAppointment.fetchUserAppointment(status: status);

    isLoad.value = false;
  }

  /// Cette fonction Dart gère l'annulation d'un rendez-vous, y compris sa suppression d'une liste et
  /// affichant les boîtes de dialogue de réussite ou d'erreur.
  ///
  /// Arguments :
  /// index (int) : Le paramètre `index` dans la fonction `canceledAppointment` est utilisé pour spécifier le
  /// position du rendez-vous dans la `appointmentList` que vous souhaitez annuler. C'est une valeur entière
  /// représentant l'index du rendez-vous dans la liste : Rx<List<Appointment?>>.
  /// nominationId (int) : Le paramètre `appointmentId` est une valeur entière qui représente l'unique
  /// identifiant du rendez-vous à annuler. Il est utilisé pour identifier le spécifique
  /// rendez-vous que l'utilisateur souhaite annuler dans la liste de rendez-vous.
  Future<void> canceledAppointment(
      {int? index, required int appointmentId}) async {
    isLoadDeleting.value = true;

    final bool delete =
        await apiAppointment.deleteAppointment(appointmentId: appointmentId);
    if (delete) {
      successDialog(
        title: "success".tr,
        body: "appointment-delete-success".tr,
      );
      Future.delayed(Duration.zero, () {
        Get.off(() => AppointmentScreen(
              back: false,
            ));
      });
      if (index != null) {
        if (appointmentList.value.contains(appointmentList.value[index])) {
          appointmentList.value.remove(appointmentList.value[index]);
        }
      }
    } else {
      defaultErrorDialog();
    }
    isLoadDeleting.value = false;
  }

  Future<void> confirmAppointment({required int appointmentId}) async {
    isLoadConfirm.value = true;
    Appointment? appointment =
        await apiAppointment.confirmAppointment(appointmentId: appointmentId);

    if (appointment != null) {
      successDialog(title: "success".tr, body: "Le rendez-vous est confirmé");
      Get.find<AppointmentDetailController>().appointment.value = appointment;
    } else {
      defaultErrorDialog();
    }
    isLoadConfirm.value = false;
  }
}
