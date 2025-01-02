import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpecialityBadge extends StatelessWidget {
  const SpecialityBadge({
    super.key,
    required this.specialities,
    this.fontSize,
    this.alignment,
  });

  final List<String> specialities;
  final double? fontSize;
  final WrapAlignment? alignment;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Wrap(
            alignment: alignment ?? WrapAlignment.start,
            spacing: 5.0,
            children: specialities
                .take(4)
                .map((speciality) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    margin: const EdgeInsets.only(bottom: 5.0),
                    decoration: _decoration(),
                    child: Text(
                      speciality.tr,
                      style: TextStyle(fontSize: fontSize ?? 10),
                    )))
                .toList()));
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color: Get.theme.dividerColor.withAlpha((0.7 * 255).toInt())));
  }
}
