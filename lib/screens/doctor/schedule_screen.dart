import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/models/schedule_model.dart';

class ScheduleWidget extends StatelessWidget {
  final WeeklySchedule weeklySchedule;

  const ScheduleWidget({super.key, required this.weeklySchedule});
  @override
  Widget build(BuildContext context) {
    final List<String> tableHead = [
      'hours'.tr,
      'monday'.tr,
      'tuesday'.tr,
      'wednesday'.tr,
      'thursday'.tr,
      'friday'.tr,
      'saturday'.tr,
      'sunday'.tr
    ];
    const minColumnWidth =
        MinColumnWidth(FixedColumnWidth(100.0), FlexColumnWidth());
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
            width: 800,
            child: Table(
                columnWidths: const {
                  0: FixedColumnWidth(80.0),
                  1: minColumnWidth,
                  2: minColumnWidth,
                  3: minColumnWidth,
                  4: minColumnWidth,
                  5: minColumnWidth,
                  6: minColumnWidth,
                  7: minColumnWidth,
                },
                border: TableBorder.all(color: primary),
                children: [
                  TableRow(children: [
                    ...tableHead.map((e) => Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12),
                        child: Text(e)))
                  ]),
                  ..._buildTimeRows()
                ])));
  }

  List<TableRow> _buildTimeRows() {
    // Cette fonction construit les lignes de la table pour les heures et les horaires de travail
    List<TableRow> rows = [];

    List<String> hours = [
      '08:00',
      '09:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00',
      '18:00',
      '19:00',
      '20:00',
      '21:00',
      '22:00',
      '23:00',
    ];
    for (String hour in hours) {
      rows.add(TableRow(children: [
        TableCell(
            child: Center(child: Text(hour, textAlign: TextAlign.center))),
        _buildScheduleCell(weeklySchedule.monday, hour),
        _buildScheduleCell(weeklySchedule.tuesday, hour),
        _buildScheduleCell(weeklySchedule.wednesday, hour),
        _buildScheduleCell(weeklySchedule.thursday, hour),
        _buildScheduleCell(weeklySchedule.friday, hour),
        _buildScheduleCell(weeklySchedule.saturday, hour),
        _buildScheduleCell(weeklySchedule.sunday, hour)
      ]));
    }
    return rows;
  }

  Widget _buildScheduleCell(List<Schedule>? daySchedule, String hour) {
    // Trouvez l'horaire qui correspond à l'heure donnée
    Schedule? matchingSchedule = daySchedule?.firstWhere((schedule) {
      String? startAt = schedule.startAt;
      String? endAt = schedule.endAt;
      if (startAt != null && endAt != null) {
        return startAt.compareTo(hour) <= 0 && endAt.compareTo(hour) > 0;
      }
      return false;
    },
        orElse: () => Schedule(
            id: 0,
            startAt: '',
            endAt: '',
            workPlaceName: '',
            workPlaceAddress: ''));

    // Si un horaire correspondant est trouvé, affichez son workPlaceName, sinon affichez une chaîne vide
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: matchingSchedule != null && matchingSchedule.workPlaceName != ''
            ? Column(children: [
                Text('${matchingSchedule.workPlaceName}'),
                Text('${matchingSchedule.workPlaceAddress}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 8))
              ])
            : Container());
  }
}
