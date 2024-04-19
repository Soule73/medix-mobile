import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/screens/appointment/appointment_screen.dart';
import 'package:medix/screens/events/notification_screen.dart';
import 'package:medix/screens/profile/profile_screen.dart';
import 'package:medix/screens/welcome_screen.dart';
import 'package:medix/utils/utils.dart';

class DrawerController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void onElementTapped(int index) => selectedIndex.value = index;
}

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  static final Auth auth = Get.find<Auth>();

  final DrawerController drawerController = Get.put(DrawerController());

  @override
  Widget build(BuildContext context) {
    final List<MenuElement> drawerElementAuth = [
      MenuElement("/WelcomeScreen", 'home'.tr, 'assets/icons/home.svg',
          () => Get.to(() => WelcomeScreen())),
      MenuElement("/ProfileScreen", 'profile'.tr,
          'assets/icons/user_circle.svg', () => Get.to(() => ProfileScreen())),
      MenuElement(
          "/AppointmentScreen",
          'my-appointments'.tr,
          'assets/icons/calendar-days.svg',
          () => Get.to(() => AppointmentScreen())),
      MenuElement(
          "/NotificationScreen",
          'notifications'.tr,
          'assets/icons/notification.svg',
          () => Get.to(() => NotificationScreen())),
    ];
    return Drawer(child: DrawerListElement(drawerElement: drawerElementAuth));
  }
}

class DrawerListElement extends StatelessWidget {
  final List<MenuElement> drawerElement;
  final DrawerController drawerController = Get.find<DrawerController>();
  final Auth auth = Get.find<Auth>();
  DrawerListElement({super.key, required this.drawerElement});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: primary,
          ),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: SizedBox(
                width: 150,
                height: 150,
                child: Obx(
                  () => auth.user.value?.avatar == null ||
                          auth.user.value?.avatar == ""
                      ? CircleAvatar(
                          child: ClipOval(
                            child: SvgPicture.asset(
                              'assets/icons/avatar.svg',
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                              networkImage('${auth.user.value?.avatar}')),
                          backgroundColor: primary,
                        ),
                )),
          )),
        ),
        ...drawerElement.map((element) {
          return DrawerElement(
            isSelected: Get.currentRoute == element.id,
            onTap: () {
              element.action();
            },
            title: element.text,
            assetName: element.assetName,
          );
        })
      ],
    );
  }
}

class DrawerElement extends StatelessWidget {
  final bool isSelected;
  final String title;
  final Function onTap;
  final String assetName;
  const DrawerElement(
      {super.key,
      required this.isSelected,
      required this.onTap,
      required this.title,
      required this.assetName});

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: isSelected ? primary : null,
      child: ListTile(
        leading: SvgPicture.asset(assetName,
            colorFilter: ColorFilter.mode(
              isSelected ? white : Get.theme.primaryColor,
              BlendMode.srcIn,
            )),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? white : Theme.of(context).primaryColor,
          ),
        ),
        selected: isSelected,
        onTap: () => onTap(),
      ),
    );
  }
}

class MenuElement {
  final String id;
  final String text;
  final String assetName;
  final Function action;

  MenuElement(this.id, this.text, this.assetName, this.action);
}
