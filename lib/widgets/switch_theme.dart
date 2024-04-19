import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/themes/theme_controller.dart';

class SwitchThemeMode extends StatelessWidget {
  const SwitchThemeMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
        padding: const EdgeInsets.only(right: 18.0),
        child: GestureDetector(
            onTap: () => Get.find<ThemeController>().toggleTheme(),
            child: Container(
                decoration: _decoration(context),
                width: 40,
                height: 40,
                child: Center(
                    child: FaIcon(
                  Get.find<ThemeController>().themeMode.value == ThemeMode.dark
                      ? FontAwesomeIcons.moon
                      : FontAwesomeIcons.sun,
                  size: 28,
                  color: Theme.of(context).primaryColor,
                ))))));
  }

  BoxDecoration _decoration(BuildContext context) {
    return BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: BorderRadius.circular(30));
  }
}
