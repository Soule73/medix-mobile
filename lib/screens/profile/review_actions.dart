import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/widgets/bottom_sheet_action_item.dart';

Widget reviewAction(
    {required Function onTapUpdate, required Function onTapDelete}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      bottomSheetActionItem(
          icon: Icons.edit_square,
          text: "update-this-review".tr,
          onTap: onTapUpdate),
      bottomSheetActionItem(
          icon: Icons.delete_forever,
          text: "delete-this-review".tr,
          onTap: onTapDelete)
    ],
  );
}
