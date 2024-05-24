import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/appointment_detail_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/services/api_doctor.dart';
import 'package:medix/utils/alert_dialog.dart';
import 'package:medix/utils/utils.dart';
import 'package:medix/widgets/boutons/button.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:medix/widgets/forms/faded_texterea_form_field.dart';

class RatingController extends GetxController {
  RxInt star = 0.obs;
  String? path;
  RxBool isLoad = false.obs;
  TextEditingController review = TextEditingController();
  ApiDoctor apiDoctor = ApiDoctor();

  Future<void> rateDoctor(Map<String, dynamic> data) async {
    isLoad.value = true;
    try {
      final ReviewRating? reviewRating =
          await apiDoctor.addOrUpdateDoctorRate(credential: data, path: path);

      if (reviewRating != null) {
        Future.delayed(Duration.zero, () async {
          successDialog(
              title: "success".tr,
              onClose: () => Get.back(),
              body: path != null
                  ? "review-update".tr
                  : "thank-for-your-feedback".tr);
          AppointmentDetailController controller =
              Get.find<AppointmentDetailController>();
          controller.reviewRating.value = reviewRating;
          if (controller.reviewRating.value != null) {
            path = "/review-rating/update/${controller.reviewRating.value?.id}";
          }
          isLoad.value = false;
        });
      } else {
        defaultErrorDialog();
      }
    } catch (_) {}
    isLoad.value = false;
  }
}

class RateDoctorScreen extends StatelessWidget {
  RateDoctorScreen({super.key});
  final AppointmentDetailController appointmentDetailController =
      Get.find<AppointmentDetailController>();
  final RatingController ratingController = Get.put(RatingController());
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      ReviewRating? reviewRating =
          appointmentDetailController.reviewRating.value;
      if (reviewRating != null) {
        int? star = reviewRating.star;
        ratingController.star.value = star ?? 0;
        ratingController.review.text = reviewRating.comment ?? '';
        ratingController.path = "/review-rating/update/${reviewRating.id}";

        return ScaffoldDefault(
            leading: const BackBtn(),
            title: "write-your-review".tr,
            actions: const [],
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      _header(),
                      _doctorInfo(),
                      _buildRatingStar(),
                      _writeYourRevie(),
                    ]))),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.only(bottom: 80.0, left: 50, right: 50),
              child: _submit(),
            ));
      } else {
        return const SizedBox();
      }
    });
  }

  Widget _submit() {
    return Obx(() => OutlinedBtn(
          isLoad: ratingController.isLoad.value,
          title: "submit".tr,
          onPressed: sumbitData,
        ));
  }

  void sumbitData() async {
    try {
      final Appointment appointment =
          appointmentDetailController.appointment.value;
      final Map<String, dynamic> data = {
        'appointment_id': '${appointment.id}',
        'patient_id': '${appointment.patientId}',
        'doctor_id': '${appointment.doctorId}',
        'star': '${ratingController.star.value}',
        'comment': ratingController.review.text
      };
      await ratingController.rateDoctor(data);
    } catch (_) {}
  }

  Padding _writeYourRevie() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(children: [
          Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 15.0, bottom: 5),
              child: Text("write-your-review".tr,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600))),
          FadedTextereaField(
              minLines: 5,
              label: "write-your-review".tr,
              hintText: "write-your-review".tr,
              controller: ratingController.review,
              keyboardType: TextInputType.multiline)
        ]));
  }

  Container _header() {
    return Container(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Column(children: [
          SizedBox(
              width: Get.width * 0.7,
              child: Text("appointment-session-ended".tr,
                  style: const TextStyle(fontSize: 22),
                  textAlign: TextAlign.center)),
          SizedBox(
              width: Get.width * 0.9,
              child: Text("what-is-your-experience".tr,
                  style: TextStyle(fontSize: 16, color: Get.theme.dividerColor),
                  textAlign: TextAlign.center))
        ]));
  }

  Center _doctorInfo() {
    final Appointment appointment =
        appointmentDetailController.appointment.value;
    return Center(
        child: Column(children: [
      SizedBox(
          width: 150,
          height: 150,
          child: CircleAvatar(
              backgroundImage:
                  NetworkImage(networkImage('${appointment.doctorAvatar}')))),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Text(
              '${appointment.doctorProfessionalTitle} ${appointment.doctorFullname}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)))
    ]));
  }

  Row _buildRatingStar() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      for (int i = 1; i <= 5; i++)
        GestureDetector(
            onTap: () => ratingController.star.value = i,
            child: Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: FaIcon(
                    ratingController.star.value >= i
                        ? FontAwesomeIcons.solidStar
                        : FontAwesomeIcons.star,
                    color: primary,
                    size: 40))))
    ]);
  }
}
