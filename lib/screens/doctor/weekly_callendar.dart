import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/lang_controller.dart';
import 'package:mobkit_calendar/mobkit_calendar.dart';

class WeeklyCallendar extends StatelessWidget {
  const WeeklyCallendar(
      {super.key,
      required this.onSelectionChange,
      this.minDate,
      this.mobkitCalendarController});

  final dynamic Function(List<MobkitCalendarAppointmentModel>, DateTime)
      onSelectionChange;
  final DateTime? minDate;
  final MobkitCalendarController? mobkitCalendarController;

  MobkitCalendarConfigModel getConfig(
      MobkitCalendarViewType mobkitCalendarViewType) {
    return MobkitCalendarConfigModel(
        cellConfig: CalendarCellConfigModel(
            disabledStyle: CalendarCellStyle(
                textStyle: TextStyle(
                    fontSize: 14, color: Colors.grey.withOpacity(0.5)),
                color: Colors.transparent),
            enabledStyle: CalendarCellStyle(
                textStyle:
                    TextStyle(fontSize: 14, color: Get.theme.primaryColor),
                border:
                    Border.all(color: Colors.grey.withOpacity(0.2), width: 1)),
            selectedStyle: CalendarCellStyle(
                color: primary,
                textStyle: const TextStyle(fontSize: 14, color: Colors.white)),
            currentStyle: CalendarCellStyle(
                textStyle: TextStyle(color: primary),
                border: Border.all(color: primary))),
        calendarPopupConfigModel: CalendarPopupConfigModel(
          popUpBoxDecoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(25))),
          popUpOpacity: true,
          animateDuration: 500,
          verticalPadding: 30,
          popupSpace: 10,
          popupHeight: Get.height * 0.6,
          popupWidth: Get.size.width,
          viewportFraction: 0.9,
        ),
        topBarConfig: CalendarTopBarConfigModel(
            isVisibleHeaderWidget:
                mobkitCalendarViewType == MobkitCalendarViewType.monthly ||
                    mobkitCalendarViewType == MobkitCalendarViewType.agenda,
            isVisibleTitleWidget: true,
            isVisibleMonthBar: false,
            isVisibleYearBar: false,
            isVisibleWeekDaysBar: true,
            weekDaysStyle:
                TextStyle(fontSize: 14, color: Get.theme.primaryColor)),
        weekDaysBarBorderColor: Colors.transparent,
        locale: Get.find<LangController>().lang.value,
        disableOffDays: true,
        disableWeekendsDays: false,
        monthBetweenPadding: 20,
        primaryColor: Colors.lightBlue,
        popupEnable: mobkitCalendarViewType == MobkitCalendarViewType.monthly
            ? true
            : false);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 230,
        child: MobkitCalendarWidget(
            minDate: minDate,
            key: UniqueKey(),
            config: getConfig(MobkitCalendarViewType.weekly),
            dateRangeChanged: (datetime) {
              return null;
            },
            headerWidget: (List<MobkitCalendarAppointmentModel> models,
                DateTime datetime) {
              return HeaderWidget(datetime: datetime, models: models);
            },
            titleWidget: (List<MobkitCalendarAppointmentModel> models,
                    DateTime datetime) =>
                TitleWidget(datetime: datetime, models: models),
            onSelectionChange: onSelectionChange,
            eventTap: (model) => null,
            onDateChanged: (DateTime datetime) {
              return null;
            },
            mobkitCalendarController: mobkitCalendarController));
  }
}

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.datetime, required this.models});

  final DateTime datetime;
  final List<MobkitCalendarAppointmentModel> models;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(children: [
          Obx(() => Text(
              DateFormat("MMMM", Get.find<LangController>().lang.value)
                  .format(datetime),
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Get.theme.primaryColor)))
        ]));
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
    required this.datetime,
    required this.models,
  });

  final DateTime datetime;
  final List<MobkitCalendarAppointmentModel> models;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(children: [
          Obx(() => Text(
              DateFormat("MMMM yyyy", Get.find<LangController>().lang.value)
                  .format(datetime),
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Get.theme.primaryColor)))
        ]));
  }
}
