import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/layouts/default_scaffold.dart';

void showFullScreenDialog(
    {required BuildContext context,
    required Widget body,
    required String title}) {
  Navigator.of(context).push(MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (BuildContext context) {
        return ScaffoldDefault(actions: [
          IconButton(icon: const Icon(Icons.close), onPressed: () => Get.back())
        ], leading: const SizedBox.shrink(), title: title, body: body);
      }));
}
