import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class LargeIconWithGradiant extends StatelessWidget {
  const LargeIconWithGradiant({
    super.key,
    required this.colors,
    required this.icon,
  });

  final List<Color> colors;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(18),
        margin: const EdgeInsets.symmetric(vertical: 25),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
                colors: colors,
                begin: Alignment.bottomLeft,
                end: Alignment.topRight)),
        child: SizedBox(
            width: 100,
            height: 100,
            child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: FaIcon(icon, color: Get.theme.canvasColor, size: 80))));
  }
}
