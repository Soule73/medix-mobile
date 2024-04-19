import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/book_appointment_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/models/doctor_model.dart';
import 'package:medix/models/schedule_model.dart';
import 'package:medix/screens/appointment/common_widget.dart';
import 'package:medix/screens/doctor/available_hour.dart';
import 'package:medix/utils/utils.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:mobkit_calendar/mobkit_calendar.dart';

class BookAppointmentScreen extends StatelessWidget {
  BookAppointmentScreen({super.key, required this.doctor});

  final Doctor doctor;

  final BookAppointmentController controller =
      Get.put(BookAppointmentController());

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        actions: const [],
        leading: const BackBtn(),
        title: "book-appointment".tr,
        body: SingleChildScrollView(
          child: Column(
            children: [
              buildInfoText(
                  '${doctor.professionalTitle} ', '${doctor.fullname}'),
              buildConsultationPrice(visitPrice: '${doctor.visitPrice}'),
              buildCalendar(
                  minDate: _minDate(),
                  onSelectionChange: _onSelectionChange,
                  mobkitCalendarController: _mobkitCalendarController()),
              _buildAvailableHours(),
              _buildAppointmentWorkPlaceInfo(),
              buildAppointmentReason(controller: controller.motif)
            ],
          ),
        ),
        bottomNavigationBar: Obx(() => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: buildSubmitBtn(
                title: 'book-appointment'.tr,
                onPressed: _submit,
                isLoad: controller.isLoad.value))));
  }

  DateTime _minDate() {
    DateTime now = DateTime.now();
    DateTime tomorrow = now.add(const Duration(days: 1));
    DateTime minDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    return minDate;
  }

  MobkitCalendarController _mobkitCalendarController() {
    return MobkitCalendarController(
      calendarDateTime: DateTime.now().add(const Duration(days: 1)),
      selectedDateTime: DateTime.now().add(const Duration(days: 1)),
      viewType: MobkitCalendarViewType.weekly,
      appointmentList: [],
    );
  }

  _onSelectionChange(
          List<MobkitCalendarAppointmentModel> models, DateTime date) =>
      controller.getAvailableSchedulesForDate(date);

  void _submit() {
    int? doctorId = doctor.id;
    if (doctorId != null) {
      controller.nextScreen(doctorId: doctorId);
    }
  }

  Padding _buildAppointmentWorkPlaceInfo() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Obx(() {
          final schedule = controller.schedule.value;
          return schedule != null
              ? workPlaceInfo(
                  workPlaceAddress: '${schedule.workPlaceAddress}',
                  workPlaceName: '${schedule.workPlaceName}')
              : const SizedBox.shrink();
        }));
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
}
