import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/review_rating_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/models/review_ratings.dart';
import 'package:medix/utils/utils.dart';
import 'package:medix/widgets/boutons/button.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:medix/widgets/forms/faded_texterea_form_field.dart';

class EditReviewScreen extends StatelessWidget {
  EditReviewScreen({super.key, required this.review});

  final Review review;
  final ReviewRatingController controller = Get.find<ReviewRatingController>();

  @override
  Widget build(BuildContext context) {
    int? star = review.star;
    controller.star.value = star ?? 0;
    controller.comment.text = '${review.comment}';

    return ScaffoldDefault(
        leading: const BackBtn(),
        actions: const [],
        title: "Modifier votre avis",
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.only(bottom: 80.0, left: 50, right: 50),
            child: _submit()),
        body: SingleChildScrollView(
            child: Column(children: [
          _header(),
          _doctorInfo(),
          _buildRatingStar(),
          _writeYourRevie()
        ])));
  }

  Widget _submit() {
    return Obx(() => OutlinedBtn(
        isLoad: controller.isLoad.value,
        title: "saved".tr,
        onPressed: sumbitData));
  }

  void sumbitData() async {
    int? reviewId = review.id;
    if (reviewId != null) {
      final Map<String, dynamic> data = {
        'patient_id': '${review.patientId}',
        'doctor_id': '${review.doctorId}',
        'star': '${controller.star.value}',
        'comment': controller.comment.text
      };
      await controller.rateDoctor(id: reviewId, data: data);
    }
  }

  Center _doctorInfo() {
    return Center(
        child: Column(children: [
      SizedBox(
          width: 150,
          height: 150,
          child: CircleAvatar(
              backgroundImage:
                  NetworkImage(networkImage('${review.doctorAvatar}')))),
      Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Text('Dr. ${review.doctorFullname}',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)))
    ]));
  }

  Container _header() {
    return Container(
        padding: const EdgeInsets.only(bottom: 15.0, top: 50),
        child: Column(children: [
          SizedBox(
              width: Get.width * 0.9,
              child: Text(
                "what-is-your-experience".tr,
                style: TextStyle(fontSize: 16, color: Get.theme.dividerColor),
                textAlign: TextAlign.center,
              ))
        ]));
  }

  Row _buildRatingStar() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      for (int i = 1; i <= 5; i++)
        GestureDetector(
            onTap: () => controller.star.value = i,
            child: Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: FaIcon(
                    controller.star.value >= i
                        ? FontAwesomeIcons.solidStar
                        : FontAwesomeIcons.star,
                    color: primary,
                    size: 40))))
    ]);
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
              hintText: "write-your-review".tr,
              controller: controller.comment,
              keyboardType: TextInputType.multiline)
        ]));
  }
}
