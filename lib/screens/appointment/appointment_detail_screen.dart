import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/appointment_controller.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/screens/appointment/appointment_screen.dart';
import 'package:medix/screens/appointment/re_schedule_appointment_screen.dart';
import 'package:medix/screens/doctor/rate_doctor_screen.dart';
import 'package:medix/utils/alert_dialog.dart';
import 'package:medix/utils/utils.dart';
import 'package:medix/widgets/appointment_reviews_rating.dart';
import 'package:medix/widgets/boutons/button.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:medix/widgets/doctor/doc_info.dart';

class AppointmentDetailScreen extends StatelessWidget {
  AppointmentDetailScreen(
      {super.key, this.back = true, this.index, required this.appointment});

  final int? index;

  final AppointmentController appointmentController =
      Get.find<AppointmentController>();
  final bool back;
  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final Map<String, String> status = {
        "pending": "appointment-pending".tr,
        "finished": "appointment-finished".tr,
        "accepted": "appointment-accepted".tr,
        "denied": "appointment-denied".tr
      };
      final Map<String, Color> statusColor = {
        "pending": warning,
        "finished": primary,
        "accepted": success,
        "denied": error
      };
      final List<Map<String, dynamic>> titleValue = [
        {
          'title': 'Id : ',
          'value': '#${appointment.id.toString().padLeft(8, '0')}',
          'color': null
        },
        {
          'title': '${'appointment-place'.tr} : ',
          'value': '${appointment.workPlaceName}',
          'color': null
        },
        {
          'title': '${'appointment-address'.tr} : ',
          'value': '${appointment.workPlaceAddress}',
          'color': null
        },
        {
          'title': '${'appointment-date'.tr} : ',
          'value': formatDateTime('${appointment.dateAppointment}'),
          'color': null
        },
        {
          'title': '${'appointment-price'.tr} : ',
          'value': '${appointment.amount} MRU',
          'color': null
        },
        {
          'title': '${'appointment-payment'.tr} : ',
          'value': appointment.payed!
              ? "appointment-payment-true".tr
              : "appointment-payment-false".tr,
          'color': null
        },
        {
          'title': '${'appointment'.tr} : ',
          'value': status['${appointment.status}'],
          'color': statusColor['${appointment.status}']
        },
      ];
      return ScaffoldDefault(
        title: "appointment-details".tr,
        leading: BackBtn(
            onPressed: back
                ? null
                : () => Get.to(() => AppointmentScreen(back: false))),
        actions: const [],
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(children: [
                  DoctorInfo(
                      tags: appointment.doctorId,
                      avatar: networkImage('${appointment.doctorAvatar}'),
                      fullName:
                          '${appointment.doctorProfessionalTitle} ${(appointment.doctorFullname)}',
                      phone: '${'phone'.tr} : ${appointment.doctorPhone}',
                      email: '${'email'.tr} : ${appointment.doctorEmail}',
                      title: 'contact'.tr),
                  const SizedBox(height: 10),
                  ...titleValue.map((titleValue) => TitleWithValue(
                        title: titleValue['title'],
                        value: titleValue['value'],
                        color: titleValue['color'],
                      )),
                  _motif(),
                  _acceptedMsg(),
                  _refusedMesg(),
                  _buildReviewedButton(),
                  _buildReviewButton()
                  // _rateDoctorBtn()
                ]))),
        bottomNavigationBar:
            '${appointment.status}' == "pending" ? _appointmentAction() : null,
      );
    });
  }

  Widget _rateDoctorBtn() {
    // Vérifiez l'état de la revue et l'état de l'appointment
    if (appointment.reviewRating != null) {
      return _buildReviewedButton();
    } else if (appointment.status == 'finished') {
      return _buildReviewButton();
    }
    return const SizedBox.shrink();
  }

  Widget _buildReviewedButton() {
    // Construisez le bouton pour les rendez-vous évalués
    return Column(children: [
      Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text("your-review".tr,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w600))),
      GestureDetector(
          onTap: () {
            // Utilisez un callback pour gérer la navigation
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.to(() => RateDoctorScreen());
            });
          },
          child: AppointmentReview(appointment: appointment))
    ]);
  }

  Widget _buildReviewButton() {
    // Construisez le bouton pour écrire une nouvelle revue
    return Padding(
        padding: const EdgeInsets.only(top: 28.0, left: 50, right: 50),
        child: OutlinedBtn(
            height: 40,
            onPressed: () {
              // Utilisez un callback pour gérer la navigation
              // WidgetsBinding.instance.addPostFrameCallback((_) {
              //   Get.to(() => RateDoctorScreen());
              // });
            },
            title: "write-your-review".tr));
  }

  Widget _appointmentAction() {
    return Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Row(
            mainAxisAlignment: index != null
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.center,
            children: [
              index != null
                  ? Obx(() => OutlinedBtn(
                      isLoad: appointmentController.isLoadDeleting.value,
                      title: "canceled".tr,
                      color: error,
                      width: Get.width * 0.4,
                      height: 40,
                      onPressed: () => _deleteAppointment()))
                  : const SizedBox.shrink(),
              FadeBtn(
                  title: "reschedule".tr,
                  width: index != null ? Get.width * 0.4 : Get.width * 0.8,
                  height: 40,
                  onPressed: _handleTapReSchedule)
            ]));
  }

  void _deleteAppointment() {
    return errorDialog(
        title: "canceled".tr,
        body: "are-you-sur-to-canceled".tr,
        actions: [
          TextButton(
              onPressed: _delete,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                      color: error.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)),
                  child: SizedBox(
                      width: 50,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => appointmentController.isLoadDeleting.value
                                ? Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: error))
                                : const SizedBox.shrink()),
                            Text("yes".tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, color: error))
                          ]))))
        ]);
  }

  void _delete() async {
    int? appointmentId = appointment.id;
    int? deletIndex = index;
    if (deletIndex != null && appointmentId != null) {
      await appointmentController.canceledAppointment(
          deletIndex, appointmentId);
    }
  }

  void _handleTapReSchedule() async {
    await Get.find<DoctorController>()
        .fetchDoctorDetails(appointment.doctorId.toString());
    Get.to(() => ReScheduleAppointmentScreen(appointment: appointment));
  }

  Widget _motif() {
    String? motif = appointment.motif;

    return motif != null
        ? AppointmentMessage(title: "appointment-motif".tr, message: motif)
        : const SizedBox.shrink();
  }

  Widget _acceptedMsg() {
    String? acceptedMessage = appointment.acceptedMessage;

    return acceptedMessage != null
        ? AppointmentMessage(
            title: "appointment-accepted-message".tr, message: acceptedMessage)
        : const SizedBox.shrink();
  }

  Widget _refusedMesg() {
    String? reasonForRefusal = appointment.reasonForRefusal;

    return reasonForRefusal != null
        ? AppointmentMessage(
            title: "appointment-refused-message".tr, message: reasonForRefusal)
        : const SizedBox.shrink();
  }
}

class AppointmentMessage extends StatelessWidget {
  const AppointmentMessage({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
          width: double.infinity,
          child: Text(title,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w700))),
      SizedBox(
          width: double.maxFinite,
          child: Text(message,
              textAlign: TextAlign.start, style: const TextStyle(fontSize: 16)))
    ]);
  }
}

class TitleWithValue extends StatelessWidget {
  const TitleWithValue({
    super.key,
    required this.title,
    required this.value,
    this.color,
  });

  final String title;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: color?.withOpacity(0.3),
            borderRadius: color != null ? BorderRadius.circular(5) : null),
        margin: EdgeInsets.symmetric(vertical: color != null ? 5 : 0),
        padding: EdgeInsets.symmetric(
            horizontal: 10.0, vertical: color != null ? 15 : 10.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Get.theme.primaryColor)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.normal))
        ]));
  }
}
