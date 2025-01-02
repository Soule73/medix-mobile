import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:medix/screens/doctor/weekly_callendar.dart';
import 'package:medix/widgets/boutons/button.dart';
import 'package:medix/widgets/forms/faded_texterea_form_field.dart';
import 'package:mobkit_calendar/mobkit_calendar.dart';

Widget buildInfoText(String title, String? value) {
  return RichText(
      text: TextSpan(
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Get.theme.primaryColor),
          text: title,
          children: <InlineSpan>[
        TextSpan(
            style: const TextStyle(fontWeight: FontWeight.normal),
            text: value ?? 'not-available'.tr)
      ]));
}

Container buildConsultationPrice({required String visitPrice}) {
  return Container(
      margin: const EdgeInsets.only(top: 5.0),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Get.theme.primaryColor.withAlpha((0.1 * 255).toInt())),
      child: Text("${'consultation-price'.tr} : $visitPrice MRU",
          style: const TextStyle(fontWeight: FontWeight.w600)));
}

Padding buildSubmitBtn(
    {required String title,
    required void Function()? onPressed,
    bool isLoad = false}) {
  return Padding(
      padding: const EdgeInsets.only(bottom: 50.0, left: 20, right: 20.0),
      child: FadeBtn(
          isLoad: isLoad, height: 40, title: title, onPressed: onPressed));
}

WeeklyCallendar buildCalendar(
    {required dynamic Function(List<MobkitCalendarAppointmentModel>, DateTime)
        onSelectionChange,
    required MobkitCalendarController? mobkitCalendarController,
    DateTime? minDate}) {
  return WeeklyCallendar(
      mobkitCalendarController: mobkitCalendarController,
      minDate: minDate,
      onSelectionChange: onSelectionChange);
}

Padding buildAppointmentReason({required TextEditingController controller}) {
  return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: FadedTextereaField(
          minLines: 5,
          hintText: "appointment-reason".tr,
          label: "appointment-reason".tr,
          controller: controller,
          keyboardType: TextInputType.multiline));
}

Column workPlaceInfo(
    {required String workPlaceName, required String workPlaceAddress}) {
  return Column(children: [
    buildInfoText('${'appointment-place'.tr} : ', workPlaceName),
    buildInfoText('${'appointment-address'.tr} : ', workPlaceAddress)
  ]);
}
