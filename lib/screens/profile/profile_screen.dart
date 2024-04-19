import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/controllers/auth/update_profile_controller.dart';
import 'package:medix/controllers/favoris_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/models/user.dart';
import 'package:medix/screens/profile/favorites_screen.dart';
import 'package:medix/screens/profile/reviews_screen.dart';
import 'package:medix/screens/profile/update_password_sceen.dart';
import 'package:medix/screens/profile/update_profile_screen.dart';
import 'package:medix/screens/setting/setting_screen.dart';
import 'package:medix/utils/alert_dialog.dart';
import 'package:medix/utils/utils.dart';
import 'package:medix/widgets/bottom_sheet_action_item.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:medix/widgets/doctor/bottom_sheet.dart';
import 'package:medix/widgets/forms/file_upload.dart';

class ProfileScreen extends StatelessWidget {
  final Auth auth = Get.find<Auth>();

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {
        'title': formatSettingItem("edit-profile".tr),
        'icon': FontAwesomeIcons.solidUser,
        'onTap': () => Get.to(() => UpdateProfileScreen()),
      },
      {
        'title': formatSettingItem("edit-password".tr),
        'icon': FontAwesomeIcons.lock,
        'onTap': () => Get.to(() => UpdatePasswordScreen()),
      },
      {
        'title': formatSettingItem("favorites".tr),
        'icon': FontAwesomeIcons.solidHeart,
        'onTap': () {
          Get.find<FavorisController>().getFavris();
          Get.to(() => FavoritesScreen());
        }
      },
      {
        'title': formatSettingItem("my-reviews".tr),
        'icon': FontAwesomeIcons.solidStar,
        'onTap': () => Get.to(() => ReviewsScreen()),
      },
      {
        'title': formatSettingItem("settings".tr),
        'icon': FontAwesomeIcons.wrench,
        'onTap': () => Get.to(() => SettingScreen()),
      },
    ];
    return ScaffoldDefault(
        actions: const [],
        leading: const BackBtn(),
        title: 'profile'.tr,
        body: Stack(alignment: Alignment.topCenter, children: [
          Column(children: [
            ProfileAvatar(auth: auth),
            UserFullNameAndPhone(auth: auth),
            ...actions.map((action) => ActionEdit(
                title: action['title'],
                icon: action['icon'],
                onTap: action['onTap'])),
            ActionEdit(
              title: 'logout'.tr,
              icon: (FontAwesomeIcons.doorOpen),
              onTap: () => bottomSheet(
                  context: context,
                  height: 100,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        bottomSheetActionItem(
                            icon: Icons.cancel_outlined,
                            text: 'canceled'.tr,
                            onTap: () => Get.back()),
                        bottomSheetActionItem(
                            icon: FontAwesomeIcons.doorOpen,
                            text: 'logout'.tr,
                            color: error,
                            onTap: () async => await auth.logout())
                      ])),
              color: error,
              textColor: error,
            ),
            ActionEdit(
                title: 'delete-account'.tr,
                icon: (FontAwesomeIcons.trash),
                onTap: () {
                  errorDialog(actions: [
                    TextButton(
                        onPressed: callDestroy,
                        child: Obx(
                          deleteAccount,
                        )),
                  ], title: "warning".tr, body: "warning-info".tr);
                },
                color: error,
                textColor: error,
                bgColor: error)
          ])
        ]));
  }

  void callDestroy() async {
    await auth.deleteUserAccount();
    Get.back();
  }

  Widget deleteAccount() => auth.isLoading.value
      ? SizedBox(
          width: 20, height: 20, child: CircularProgressIndicator(color: error))
      : Text("delete".tr, style: TextStyle(color: error));
}

String formatSettingItem(String item) {
  return item.length > 28 ? "${item.substring(0, 28)}..." : item;
}

class ActionEdit extends StatelessWidget {
  const ActionEdit({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
    this.color,
    this.textColor,
    this.bgColor,
  });

  final String title;
  final IconData icon;
  final void Function() onTap;
  final Color? color;
  final Color? textColor;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 50,
        width: double.infinity,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                margin: const EdgeInsets.symmetric(vertical: 2.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: bgColor?.withOpacity(0.1)),
                child: InkWell(
                    onTap: onTap,
                    child: Center(
                        child: Row(children: [
                      SizedBox(
                          width: 30,
                          height: 30,
                          child: CircleAvatar(
                              backgroundColor: color != null
                                  ? color?.withOpacity(0.1)
                                  : primary.withOpacity(0.1),
                              child: FaIcon(icon,
                                  size: 15, color: color ?? primary))),
                      Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(title,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)))
                    ]))))));
  }
}

class UserFullNameAndPhone extends StatelessWidget {
  const UserFullNameAndPhone({
    super.key,
    required this.auth,
  });

  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      User? user = auth.user.value;
      return Container(
          width: double.infinity,
          padding: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Get.theme.dividerColor.withOpacity(0.2),
                      width: 3))),
          child: Column(children: [
            Text('${user?.firstName} ${user?.name}',
                style: const TextStyle(fontSize: 20)),
            Text(user?.phone != '' ? '+222 ${user?.phone}' : "",
                style: TextStyle(fontSize: 14, color: Get.theme.dividerColor))
          ]));
    });
  }
}

class ProfileAvatar extends StatelessWidget {
  ProfileAvatar({
    super.key,
    required this.auth,
  });

  final Auth auth;

  final UpdateProfileController updateProfileController =
      Get.put(UpdateProfileController());
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(children: [
      SizedBox(
          width: 150,
          height: 150,
          child: Obx(() {
            return updateProfileController.isSetUserProfile.value
                ? SizedBox(
                    height: 150.0,
                    child: Stack(children: <Widget>[
                      const Center(
                          child: SizedBox(
                              width: 120,
                              height: 120,
                              child: CircularProgressIndicator())),
                      Center(
                          child: Obx(() => Text(
                              updateProfileController.progressState.value)))
                    ]))
                : auth.user.value?.avatar == "" ||
                        auth.user.value?.avatar == null
                    ? CircleAvatar(
                        child: ClipOval(
                            child: SvgPicture.asset('assets/icons/avatar.svg',
                                fit: BoxFit.contain)))
                    : CircleAvatar(
                        backgroundImage: NetworkImage(
                            networkImage('${auth.user.value?.avatar}')));
          })),
      Transform.translate(
          offset: const Offset(40, -25),
          child: UploadProfileImage(onSelectFile: (File file) {
            updateProfileController.updateUserAvatar(file);
          }))
    ]));
  }
}
