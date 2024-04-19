import 'package:flutter/material.dart';
import 'package:flutter_stepindicator/flutter_stepindicator.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';

class StepperWidget extends StatelessWidget {
  const StepperWidget(
      {super.key,
      required this.division,
      required this.page,
      required this.list,
      this.onClickItem});

  final int division;
  final int page;
  final List list;
  final dynamic Function(int)? onClickItem;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 30,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: FlutterStepIndicator(
                onClickItem: onClickItem,
                height: 25,
                list: list,
                onChange: (int index) {},
                page: page,
                positiveColor: success,
                negativeColor: Get.theme.dividerColor,
                progressColor: primary,
                durationScroller: const Duration(seconds: 3),
                durationCheckBulb: const Duration(seconds: 2),
                division: division)));
  }
}
