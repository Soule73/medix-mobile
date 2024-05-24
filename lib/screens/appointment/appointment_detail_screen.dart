import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:medix/constants/constants.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/appointment_controller.dart';
import 'package:medix/controllers/appointment_detail_controller.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/controllers/location_controller.dart';
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
  AppointmentDetailScreen({super.key, this.back = true, this.index});

  final int? index;

  final AppointmentController appointmentController =
      Get.find<AppointmentController>();
  final bool back;
  final AppointmentDetailController appointmentDetailController =
      Get.find<AppointmentDetailController>();
  final Map<String, Color> statusColor = {
    "pending": warning,
    "finished": primary,
    "accepted": success,
    "denied": error
  };
  @override
  Widget build(BuildContext context) {
    final Appointment appointment =
        appointmentDetailController.appointment.value;

    return Obx(() {
      if (appointment.reviewRating != null) {
        appointmentDetailController.reviewRating.value =
            appointment.reviewRating;
      }
      final Map<String, String> status = {
        "pending": "appointment-pending".tr,
        "finished": "appointment-finished".tr,
        "accepted": "appointment-accepted".tr,
        "denied": "appointment-denied".tr
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
                  _routePolyLine(appointment),
                  _rateDoctorBtn()
                ]))),
        bottomNavigationBar: appointment.rescheduleDate != null ||
                '${appointment.status}' == "pending"
            ? _appointmentAction()
            : null,
      );
    });
  }

  Widget _routePolyLine(Appointment appointment) {
    LocationController locationController = Get.find<LocationController>();
    double? workPlaceLongitude = appointment.workPlaceLongitude;
    double? workPlaceLatitude = appointment.workPlaceLatitude;

    if (workPlaceLatitude != null && workPlaceLongitude != null) {
      List<Widget> children = <Widget>[];
      children.add(
        SizedBox(height: 500, child: RoutePolyLine(appointment: appointment)),
      );

      children.add(Obx(() {
        if (locationController.segmentsDistance.value > 0) {
          return TitleWithValue(
              title: "distance".tr, value: locationController.distance());
        }
        return const SizedBox();
      }));
      children.add(Obx(() {
        if (locationController.segmentsDuration.value > 0) {
          return TitleWithValue(
              title: "duration".tr, value: locationController.duration());
        }
        return const SizedBox();
      }));
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color:
                (statusColor['${appointment.status}'] ?? Get.theme.primaryColor)
                    .withOpacity(0.2)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        margin: const EdgeInsets.symmetric(vertical: 15),
        width: double.infinity,
        child: Column(
          children: children,
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _rateDoctorBtn() {
    final Appointment appointment =
        appointmentDetailController.appointment.value;
    return Obx(() {
      // Vérifiez l'état de la revue et l'état de l'appointment
      if (appointmentDetailController.reviewRating.value != null) {
        return _buildReviewed();
      } else if (appointment.status == 'finished') {
        return _buildAddReviewButton();
      }
      return const SizedBox.shrink();
    });
  }

  Widget _buildReviewed() {
    // Construisez le bouton pour les rendez-vous évalués
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
          onTap: () {
            // Utilisez un callback pour gérer la navigation
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.to(() => RateDoctorScreen());
            });
          },
          child: AppointmentReview()),
    );
  }

  Widget _buildAddReviewButton() {
    final Appointment appointment =
        appointmentDetailController.appointment.value;

    // Construisez le bouton pour écrire une nouvelle revue
    return Padding(
        padding: const EdgeInsets.only(top: 28.0, left: 50, right: 50),
        child: OutlinedBtn(
            height: 40,
            onPressed: () {
              Get.find<AppointmentDetailController>().appointment.value =
                  appointment;
              Get.to(() => RateDoctorScreen());
            },
            title: "write-your-review".tr));
  }

  Widget _appointmentAction() {
    final Appointment appointment =
        appointmentDetailController.appointment.value;
    List<Widget> children = [];
    if (appointment.status == "pending" || appointment.rescheduleDate != null) {
      children.add(Obx(() => OutlinedBtn(
          isLoad: appointmentController.isLoadDeleting.value,
          title: "canceled".tr,
          color: error,
          width: Get.width * 0.4,
          height: 40,
          onPressed: () => _deleteAppointment())));
    }
    if (appointment.status == "pending" && appointment.rescheduleDate == null) {
      children.add(FadeBtn(
          title: "reschedule".tr,
          width: Get.width * 0.4,
          height: 40,
          onPressed: _handleTapReSchedule));
    }
    if (appointment.rescheduleDate != null) {
      children.add(FadeBtn(
          title: "confirme".tr,
          width: Get.width * 0.4,
          height: 40,
          onPressed: _confirmAppointment));
    }
    Widget isRescheduleDate() {
      if (appointment.rescheduleDate != null) {
        bool addByDoctor = appointment.addByDoctor ?? false;
        return Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
            decoration:
                BoxDecoration(color: Get.theme.primaryColor.withOpacity(0.2)),
            child: Text(
                textAlign: TextAlign.center,
                '${addByDoctor ? "follow-up-appointment-with-your-doctor".tr : "the-doctor-postponed-the-appointment".tr} : \n${appointment.rescheduleDate}'));
      }
      return const SizedBox.shrink();
    }

    return Container(
        height: appointment.rescheduleDate != null ? 100 : 50,
        margin: const EdgeInsets.only(bottom: 50.0),
        child: Column(
          children: [
            isRescheduleDate(),
            Row(
                mainAxisAlignment: children.length == 2
                    ? MainAxisAlignment.spaceEvenly
                    : MainAxisAlignment.center,
                children: children),
          ],
        ));
  }

  void _confirmAppointment() {
    return successDialog(
        title: "confirmer".tr,
        body: "are-your-sur-to-confirm".tr,
        actions: [
          TextButton(
              onPressed: _confirm,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  decoration: BoxDecoration(
                      color: success.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10)),
                  child: SizedBox(
                      width: 50,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx(() => appointmentController.isLoadConfirm.value
                                ? Container(
                                    margin: const EdgeInsets.only(right: 5),
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: success))
                                : const SizedBox.shrink()),
                            Text("yes".tr,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: success))
                          ]))))
        ]);
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
    final Appointment appointment =
        appointmentDetailController.appointment.value;

    int? appointmentId = appointment.id;
    if (appointmentId != null) {
      await appointmentController.canceledAppointment(
          index: index, appointmentId: appointmentId);
    }
  }

  void _confirm() async {
    final Appointment appointment =
        appointmentDetailController.appointment.value;

    int? appointmentId = appointment.id;
    if (appointmentId != null) {
      await appointmentController.confirmAppointment(
          appointmentId: appointmentId);
    }
  }

  void _handleTapReSchedule() async {
    final Appointment appointment =
        appointmentDetailController.appointment.value;
    int? doctorId = appointment.doctorId;
    if (doctorId != null) {
      await Get.find<DoctorController>().fetchDoctorDetails(doctorId);
    }

    Get.to(() => ReScheduleAppointmentScreen(appointment: appointment));
  }

  Widget _motif() {
    final Appointment appointment =
        appointmentDetailController.appointment.value;

    String? motif = appointment.motif;

    return motif != null
        ? AppointmentMessage(title: "appointment-motif".tr, message: motif)
        : const SizedBox.shrink();
  }

  Widget _acceptedMsg() {
    final Appointment appointment =
        appointmentDetailController.appointment.value;

    String? acceptedMessage = appointment.acceptedMessage;

    return acceptedMessage != null
        ? AppointmentMessage(
            title: "appointment-accepted-message".tr, message: acceptedMessage)
        : const SizedBox.shrink();
  }

  Widget _refusedMesg() {
    final Appointment appointment =
        appointmentDetailController.appointment.value;

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

class RoutePolyLine extends StatelessWidget {
  RoutePolyLine({super.key, required this.appointment});

  final Appointment appointment;
  final LocationController locationController = Get.find<LocationController>();

  @override
  Widget build(BuildContext context) {
    locationController.getCoordinates();
    return Obx(() {
      if (locationController.isLoadToGetCurrentPosition.value &&
          locationController.currentPosition.value == null) {
        return const Center(child: CircularProgressIndicator());
      }
      if (locationController.currentPosition.value != null) {
        return _buildMap();
      }
      return const SizedBox();
    });
  }

  Widget _buildMap() {
    final currentPosition = locationController.currentPosition.value!;
    final startPoint =
        LatLng(currentPosition.latitude, currentPosition.longitude);
    final endPoint =
        LatLng(appointment.workPlaceLatitude!, appointment.workPlaceLongitude!);

    return FlutterMap(
      options: MapOptions(initialZoom: 12.3, initialCenter: startPoint),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: applicationId,
        ),
        MarkerLayer(markers: _buildMarkers(startPoint, endPoint)),
        Obx(() => locationController.points.isNotEmpty
            ? PolylineLayer(
                polylineCulling: false,
                polylines: [
                  Polyline(
                      points: locationController.points,
                      color: Colors.black,
                      strokeWidth: 5),
                ],
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  List<Marker> _buildMarkers(LatLng startPoint, LatLng endPoint) {
    return [
      Marker(
        point: startPoint,
        width: 80,
        height: 80,
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.location_on),
          color: Colors.green,
          iconSize: 45,
        ),
      ),
      Marker(
        point: endPoint,
        width: 80,
        height: 80,
        child: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.location_on),
          color: Colors.red,
          iconSize: 45,
        ),
      ),
    ];
  }
}
