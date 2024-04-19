import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/lang_controller.dart';
import 'package:medix/controllers/themes/theme_controller.dart';
import 'package:medix/langs/languages.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SettingScreen extends StatelessWidget {
  SettingScreen({super.key});
  final themeController = Get.find<ThemeController>();
  final LangController langController = Get.find<LangController>();
  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        title: 'settings'.tr,
        leading: const BackBtn(),
        actions: const <Widget>[],
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(8),
            child: Column(children: [
              Obx(() => SettingItemSwitch(
                  title: "dark-mode".tr,
                  value: themeController.themeMode.value == ThemeMode.dark,
                  onChanged: (bool value) => themeController.toggleTheme())),
              NotificationItem(),
              LangSetting(langController: langController)
            ])));
  }
}

class LangSetting extends StatelessWidget {
  const LangSetting({
    super.key,
    required this.langController,
  });

  final LangController langController;

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('app-language'.tr,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      Obx(() => DropdownButton<String>(
          isExpanded: false,
          value: langController.lang.value != ""
              ? langController.lang.value
              : null,
          onChanged: (value) =>
              value != null ? langController.onChnage(value) : null,
          items: languages.map((LanguageModel language) {
            return DropdownMenuItem<String>(
                value: language.symbol, child: Text(language.language));
          }).toList()))
    ]);
  }
}

class NotificationPermissionController extends GetxController {
  var permission = false.obs;

  @override
  void onInit() {
    permission.value = OneSignal.Notifications.permission;
    super.onInit();
  }

  void requestPermission() {
    OneSignal.Notifications.requestPermission(true).then((_) {
      permission.value = OneSignal.Notifications.permission;
    });
  }
}

class NotificationItem extends StatelessWidget {
  NotificationItem({super.key});

  final NotificationPermissionController controller =
      Get.put(NotificationPermissionController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => SettingItemSwitch(
        title: "notifications".tr,
        value: controller.permission.value,
        onChanged: (bool value) {
          controller.requestPermission();
        }));
  }
}

class SettingItemSwitch extends StatelessWidget {
  const SettingItemSwitch({
    super.key,
    required this.onChanged,
    required this.value,
    required this.title,
  });

  final void Function(bool) onChanged;
  final bool value;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 5,
          child: Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
      Expanded(
          flex: 1,
          child:
              Switch(value: value, activeColor: primary, onChanged: onChanged))
    ]);
  }
}
