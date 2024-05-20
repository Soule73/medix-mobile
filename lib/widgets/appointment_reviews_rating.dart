import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/appointment_detail_controller.dart';
import 'package:medix/models/appointment_model.dart';
// import 'package:medix/screens/appointment/review_controller.dart';
import 'package:medix/screens/doctor/rate_doctor_screen.dart';
import 'package:medix/screens/profile/review_actions.dart';
import 'package:medix/services/api_doctor.dart';
import 'package:medix/utils/alert_dialog.dart';
import 'package:medix/utils/utils.dart';
import 'package:medix/widgets/buil_rate.dart';
import 'package:medix/widgets/doctor/bottom_sheet.dart';

class ReviewDeleteController extends GetxController {
  Rx<Appointment?> appointment = Rx<Appointment?>(null);

  Future<void> deleteReview(int id) async {
    final ReviewRating? rating = appointment.value?.reviewRating;
    ApiDoctor apiDoctor = ApiDoctor();
    final bool success = await apiDoctor.deleteRate(id: id);
    if (success) {
      successDialog(title: "success".tr, body: "review-delete".tr);
      Get.find<AppointmentDetailController>().reviewRating.value = null;
    } else {
      appointment.value?.reviewRating = rating;
      defaultErrorDialog();
    }
    update();
  }
}

class AppointmentReview extends StatelessWidget {
  AppointmentReview({
    super.key,
    // required this.appointment,
  });
  final ReviewDeleteController reviewDeleteController =
      Get.put(ReviewDeleteController());

  // final Appointment appointment;

  final AppointmentDetailController appointmentDetailController =
      Get.find<AppointmentDetailController>();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.only(top: 5.0, bottom: 50),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Get.theme.primaryColor.withOpacity(0.1)),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            GestureDetector(
                onTap: () => _actions(context),
                child: const Icon(Icons.more_horiz_outlined, size: 25))
          ]),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text(
                  '${appointmentDetailController.reviewRating.value?.comment}')),
          Row(children: [
            ...builRate(appointmentDetailController.reviewRating.value?.star),
            Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(timeFromNow(
                    '${appointmentDetailController.reviewRating.value?.createdAt}')))
          ])
        ]));
  }

  _actions(BuildContext context) {
    bottomSheet(
        context: context,
        child:
            reviewAction(onTapUpdate: _onTapUpdate, onTapDelete: _onTapDelete));
  }

  _onTapUpdate() => Get.to(() => RateDoctorScreen());

  _onTapDelete() {
    int? reviewId = appointmentDetailController.reviewRating.value?.id;
    if (reviewId != null) {
      reviewDeleteController.deleteReview(reviewId);
    }
  }
}
