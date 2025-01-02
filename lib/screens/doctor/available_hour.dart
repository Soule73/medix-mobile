import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/models/schedule_model.dart';
import 'package:medix/utils/utils.dart';

class AvailableHours extends StatelessWidget {
  const AvailableHours({
    super.key,
    required this.onSelectHour,
    required this.listSchedule,
    required this.currentHour,
    required this.unavailableMessage,
  });

  final void Function(Schedule schedule, String hour) onSelectHour;
  final List<Schedule?> listSchedule;
  final String currentHour;
  final String unavailableMessage;
  @override
  Widget build(BuildContext context) {
    return listSchedule.isNotEmpty
        ? _buildAvailableHours()
        : _buildUnavailable();
  }

  Widget _buildAvailableHours() {
    return Column(children: [
      Text("select-appointment-time".tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
      Wrap(
          children: listSchedule.expand((schedule) {
        if (schedule != null) {
          return _generateHourWidgets(schedule);
        }
        return [const SizedBox.shrink()];
      }).toList())
    ]);
  }

  List<Widget> _generateHourWidgets(Schedule schedule) {
    return generateHourList('${schedule.startAt}', '${schedule.endAt}')
        .map((hour) => _hourButton(schedule, hour))
        .toList();
  }

  Widget _hourButton(Schedule schedule, String hour) {
    final isSelected = currentHour == hour;
    return GestureDetector(
        onTap: () => onSelectHour.call(schedule, hour),
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4.0),
            decoration: BoxDecoration(
                color: isSelected ? primary : null,
                border: Border.all(
                    color:
                        Get.theme.primaryColor.withAlpha((0.2 * 255).toInt())),
                borderRadius: BorderRadius.circular(25)),
            child: Text(hour,
                style: TextStyle(color: isSelected ? white : null))));
  }

  Widget _buildUnavailable() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                  width: Get.width * 0.6,
                  height: 150,
                  child: SvgPicture.asset('assets/icons/taken_empty.svg'))),
          Text("not-available".tr,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70.0),
              child: Text(unavailableMessage, textAlign: TextAlign.center))
        ]));
  }
}
