import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/models/schedule_model.dart';
import 'package:medix/screens/appointment/appointment_detail_screen.dart';
import 'package:medix/screens/appointment/review_controller.dart';
import 'package:medix/services/api_appointment.dart';
import 'package:medix/utils/alert_dialog.dart';

/// Contrôleur pour la prise de rendez-vous médicaux.
///
/// Permet aux utilisateurs de réserver des rendez-vous avec des médecins en fonction
/// des horaires disponibles. Utilise le package GetX pour la gestion d'état et
/// intègre un mixin pour le contrôle d'animation.
class BookAppointmentController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Observable pour la liste des horaires disponibles.
  Rx<List<Schedule?>> scheduleChange = Rx<List<Schedule>>([]);

  /// Observable pour l'heure actuelle sélectionnée.
  RxString currentHour = ''.obs;

  /// Observable pour la date actuelle sélectionnée.
  RxString currentDate = ''.obs;

  /// Observable pour la date sélectionnée pour le rendez-vous.
  RxString selectDate = ''.obs;

  /// Observable pour l'état de chargement.
  RxBool isLoad = false.obs;

  /// Observable pour l'horaire sélectionné.
  Rx<Schedule?> schedule = Rx<Schedule?>(null);

  /// Observable pour le message à afficher lors de la sélection.
  RxString messageOnSelect = "".obs;

  /// Contrôleur pour le motif du rendez-vous.
  TextEditingController motif = TextEditingController();

  /// Navigue vers l'écran suivant après la prise de rendez-vous.
  ///
  /// [doctorId] L'identifiant du médecin pour le rendez-vous.
  /// Retourne `void`.
  Future<void> nextScreen({required int doctorId}) async {
    if (selectDate.value != '' || schedule.value?.workPlaceId != null) {
      isLoad.value = true;
      ApiAppointment apiAppointment = ApiAppointment();
      final patientId = Get.find<Auth>().user.value?.patienId;
      final data = {
        "work_place_id": schedule.value?.workPlaceId,
        "patient_id": patientId,
        "doctor_id": doctorId,
        "motif": motif.text,
        "date_appointment": selectDate.value
      };

      final Appointment? appointment =
          await apiAppointment.newAppointment(credential: data);

      if (appointment != null) {
        successDialog(
            title: "success".tr,
            body: "appointment-saved-and-awaiting".tr,
            onClose: () {
              Get.find<ReviewIsEmpty>().appointment.value = appointment;
              Get.off(() => AppointmentDetailScreen(back: false));
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

  /// Initialisation du contrôleur.
  ///
  /// Configure les valeurs initiales et récupère les horaires disponibles.
  @override
  void onInit() {
    super.onInit();
    getAvailableSchedulesForDate(DateTime.now().add(const Duration(days: 1)));
  }
}
