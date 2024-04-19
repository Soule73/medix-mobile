import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/re_schedule_appointment_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/models/schedule_model.dart';
import 'package:medix/screens/appointment/common_widget.dart';
import 'package:medix/screens/doctor/available_hour.dart';
import 'package:medix/utils/utils.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:mobkit_calendar/mobkit_calendar.dart';

class ReScheduleAppointmentScreen extends StatelessWidget {
  ReScheduleAppointmentScreen({super.key, required this.appointment});
  final ReScheduleAppointmentController controller =
      Get.put(ReScheduleAppointmentController());
  final Appointment appointment;
  @override
  Widget build(BuildContext context) {
    controller.motif.text = appointment.motif ?? '';
    controller.getAvailableSchedulesForDate(
        DateTime.parse('${appointment.dateAppointment}'));
    controller.currentDate.value =
        getDateFromUTC('${appointment.dateAppointment}');
    controller.currentHour.value =
        getHourFromUTC('${appointment.dateAppointment}');
    controller.workPlaceId.value = appointment.workPlaceId.toString();
    controller.selectDate.value = addHourToDate(
      controller.currentDate.value,
      controller.currentHour.value,
    );
    return ScaffoldDefault(
        leading: const BackBtn(),
        actions: const [],
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("reschedule-your-appointment".tr,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w600))),
          buildInfoText('${appointment.doctorProfessionalTitle} ',
              '${appointment.doctorFullname}'),
          buildConsultationPrice(visitPrice: '${appointment.amount}'),
          buildCalendar(
              minDate: _minDate(),
              onSelectionChange: _onSelectionChange,
              mobkitCalendarController: _mobkitCalendarController()),
          _buildAvailableHours(),
          _buildAppointmentWorkPlaceInfo(),
          buildAppointmentReason(controller: controller.motif)
        ])),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Obx(() => buildSubmitBtn(
                isLoad: controller.isLoad.value,
                title: 'reschedule-appointment'.tr,
                onPressed: _submit))));
  }

  DateTime _minDate() {
    DateTime now = DateTime.now();
    DateTime tomorrow = now.add(const Duration(days: 1));
    DateTime minDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    return minDate;
  }

  MobkitCalendarController _mobkitCalendarController() {
    return MobkitCalendarController(
        calendarDateTime: DateTime.parse('${appointment.dateAppointment}'),
        selectedDateTime: DateTime.parse('${appointment.dateAppointment}'),
        viewType: MobkitCalendarViewType.weekly,
        appointmentList: []);
  }

  _onSelectionChange(
          List<MobkitCalendarAppointmentModel> models, DateTime date) =>
      controller.getAvailableSchedulesForDate(date);

  void _submit() {
    int? appointmentId = appointment.id;
    int? doctorId = appointment.doctorId;
    if (appointmentId != null && doctorId != null) {
      controller.nextScreen(doctorId: doctorId, appointmentId: appointmentId);
    }
  }

  Obx _buildAvailableHours() {
    return Obx(() => AvailableHours(
        currentHour: controller.currentHour.value,
        unavailableMessage: controller.messageOnSelect.value,
        listSchedule: controller.scheduleChange.value.isNotEmpty
            ? controller.scheduleChange.value
            : [],
        onSelectHour: _onSelectHour));
  }

  void _onSelectHour(Schedule schedule, String hour) {
    controller.schedule.value = schedule;
    controller.currentHour.value = hour;
    controller.selectDate.value =
        addHourToDate(controller.currentDate.value, hour);
  }

  Padding _buildAppointmentWorkPlaceInfo() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Obx(() {
          final schedule = controller.schedule.value;
          return workPlaceInfo(
              workPlaceAddress: schedule?.workPlaceAddress ??
                  '${appointment.workPlaceAddress}',
              workPlaceName:
                  schedule?.workPlaceName ?? '${appointment.workPlaceName}');
        }));
  }
}
