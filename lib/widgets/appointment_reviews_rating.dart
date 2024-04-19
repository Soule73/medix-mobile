import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/screens/appointment/review_controller.dart';
import 'package:medix/screens/doctor/rate_doctor_screen.dart';
import 'package:medix/screens/profile/review_actions.dart';
import 'package:medix/utils/utils.dart';
import 'package:medix/widgets/buil_rate.dart';
import 'package:medix/widgets/doctor/bottom_sheet.dart';

class AppointmentReview extends StatelessWidget {
  AppointmentReview({
    super.key,
    required this.appointment,
  });
  final ReviewIsEmpty reviewIsEmpty = Get.find<ReviewIsEmpty>();
  final Appointment appointment;

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
                onTap: _actions(context),
                child: const Icon(Icons.more_horiz_outlined, size: 25))
          ]),
          Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Text('${appointment.reviewRating?.comment}')),
          Row(children: [
            ...builRate(appointment.reviewRating?.star),
            Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child:
                    Text(timeFromNow('${appointment.reviewRating?.createdAt}')))
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
    int? reviewId = appointment.reviewRating?.id;
    if (reviewId != null) {
      reviewIsEmpty.deleteReview(reviewId);
    }
  }
}
