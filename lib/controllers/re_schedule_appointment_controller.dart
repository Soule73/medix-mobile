import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/models/schedule_model.dart';
import 'package:medix/screens/appointment/appointment_detail_screen.dart';
import 'package:medix/services/api_appointment.dart';
import 'package:medix/utils/alert_dialog.dart';

/// Contrôleur pour la reprogrammation des rendez-vous médicaux.
///
/// Permet aux utilisateurs de reprogrammer des rendez-vous existants en fonction
/// des horaires disponibles. Utilise le package GetX pour la gestion d'état et
/// intègre un mixin pour le contrôle d'animation.
class ReScheduleAppointmentController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Observable pour la liste des horaires disponibles.
  Rx<List<Schedule?>> scheduleChange = Rx<List<Schedule>>([]);

  /// Observable pour l'heure actuelle sélectionnée.
  RxString currentHour = ''.obs;

  /// Observable pour la date actuelle sélectionnée.
  RxString currentDate = ''.obs;

  /// Observable pour la date sélectionnée pour le reprogrammation.
  RxString selectDate = ''.obs;

  /// Observable pour l'identifiant du lieu de travail.
  RxString workPlaceId = ''.obs;

  /// Observable pour l'état de chargement.
  RxBool isLoad = false.obs;

  /// Observable pour l'horaire sélectionné.
  Rx<Schedule?> schedule = Rx<Schedule?>(null);

  /// Observable pour le message à afficher lors de la sélection.
  RxString messageOnSelect = "".obs;

  /// Contrôleur pour le motif du rendez-vous.
  TextEditingController motif = TextEditingController();

  /// Navigue vers l'écran suivant après la reprogrammation du rendez-vous.
  ///
  /// [doctorId] L'identifiant du médecin pour le rendez-vous.
  /// [appointmentId] L'identifiant du rendez-vous à reprogrammer.
  /// Retourne `void`.
  void nextScreen({required int doctorId, required int appointmentId}) async {
    if (selectDate.value != '') {
      isLoad.value = true;
      ApiAppointment apiAppointment = ApiAppointment();
      final patientId = Get.find<Auth>().user.value?.patienId;
      final data = {
        "work_place_id": schedule.value?.workPlaceId ?? workPlaceId.value,
        "patient_id": patientId,
        "doctor_id": doctorId,
        "motif": motif.text,
        "date_appointment": selectDate.value
      };

      final Appointment? appointment = await apiAppointment.updateAppointment(
          appointmentId: appointmentId, credential: data);
      if (appointment != null) {
        successDialog(
            title: "success".tr,
            body: "appointment-reschedule-success".tr,
            onClose: () {
              Get.off(() => AppointmentDetailScreen(
                    back: false,
                    appointment: appointment,
                  ));
            });
      } else {
        defaultErrorDialog();
      }
      isLoad.value = false;
    } else {
      errorDialog(
          title: "error".tr,
          body: "please-select-date-and-hour-for-appointment".tr);
    }
  }

  /// Obtient les horaires disponibles pour une date donnée.
  ///
  /// [date] La date pour laquelle vérifier les horaires disponibles.
  /// Retourne `void`.
  void getAvailableSchedulesForDate(DateTime date) {
    currentDate.value = date.toString();
    currentHour.value = '';
    selectDate.value = '';
    workPlaceId.value = '';
    schedule.value = null;

    // Convertir le DateTime en nom de jour
    Map<int, String> dayNames = {
      1: 'monday',
      2: 'tuesday',
      3: 'wednesday',
      4: 'thursday',
      5: 'friday',
      6: 'saturday',
      7: 'sunday',
    };
    WeeklySchedule? weeklySchedule =
        Get.find<DoctorController>().weeklySchedule.value;
    String dayName = dayNames[date.weekday] ?? '';

    // Obtenir la liste des horaires pour le jour donné
    var schedules = <Schedule>[];
    if (date.isAfter(DateTime.now())) {
      messageOnSelect.value = "doctor-not-available-on-this-day".tr;
      switch (dayName) {
        case 'monday':
          schedules = weeklySchedule?.monday ?? [];
          break;
        case 'tuesday':
          schedules = weeklySchedule?.tuesday ?? [];
          break;
        case 'wednesday':
          schedules = weeklySchedule?.wednesday ?? [];
          break;
        case 'thursday':
          schedules = weeklySchedule?.thursday ?? [];
          break;
        case 'friday':
          schedules = weeklySchedule?.friday ?? [];
          break;
        case 'saturday':
          schedules = weeklySchedule?.saturday ?? [];
          break;
        case 'sunday':
          schedules = weeklySchedule?.sunday ?? [];
          break;
        default:
          break;
      }
    } else {
      messageOnSelect.value = "date-chosen-has-passed".tr;
    }

    scheduleChange.value = schedules;
  }
}
