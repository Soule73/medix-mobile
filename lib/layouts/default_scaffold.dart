import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/auth/auth.dart';
import 'package:medix/controllers/notification_controller.dart';
import 'package:medix/layouts/app_bar.dart';
import 'package:medix/layouts/drawer.dart';
import 'package:badges/badges.dart' as badges;
import 'package:medix/screens/events/notification_screen.dart';
import 'package:medix/utils/utils.dart';

class ScaffoldDefault extends StatelessWidget {
  ScaffoldDefault({
    super.key,
    required this.body,
    this.actions,
    this.title,
    this.leading,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.titleWidget,
  });

  final Auth auth = Get.find<Auth>();

  final List<Widget>? actions;
  final Widget body;
  final Widget? leading;
  final Widget? floatingActionButton;
  final String? title;
  final Widget? bottomNavigationBar;
  final Widget? titleWidget;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: floatingActionButton,
        drawer: AppDrawer(),
        appBar: buildAppBar(context,
            leading: leading ??
                Builder(
                  builder: (BuildContext context) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 45,
                        height: 45,
                      ),
                    );
                  },
                ),
            // leading: const FaIcon(FontAwesomeIcons.bars),
            title: title,
            titleWidget: titleWidget,
            actions: actions ??
                <Widget>[const AppBarNotification(), AppBarAvatar(auth: auth)]),
        bottomNavigationBar: bottomNavigationBar,
        extendBody: true,
        body: SafeArea(child: body));
  }
}

class AppBarNotification extends StatelessWidget {
  const AppBarNotification({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => NotificationScreen()),
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Get.theme.primaryColor.withOpacity(0.2)),
        child: const NotificationCount(),
      ),
    );
  }
}

class AppBarAvatar extends StatelessWidget {
  const AppBarAvatar({
    super.key,
    required this.auth,
  });

  final Auth auth;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50))),
      child: Builder(
        builder: (BuildContext context) {
          return SizedBox(
            width: 35,
            child: GestureDetector(
                onTap: Scaffold.of(context).openDrawer,
                child: Obx(() => ClipOval(
                    child: auth.user.value?.avatar != null &&
                            auth.user.value?.avatar != ''
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(
                                networkImage('${auth.user.value?.avatar}')),
                          )
                        : CircleAvatar(
                            child: SvgPicture.asset(
                              'assets/icons/avatar.svg',
                              fit: BoxFit.contain,
                            ),
                          )))),
          );
        },
      ),
    );
  }
}

class NotificationCount extends StatelessWidget {
  const NotificationCount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => Get.find<NotificationController>().unreadCount.value <= 0
        ? SvgPicture.asset("assets/icons/notification.svg")
        : badges.Badge(
            badgeContent: Text(
              '${Get.find<NotificationController>().unreadCount.value}',
              style: TextStyle(color: white),
            ),
            child: const Icon(Icons.notifications),
          ));
  }
}
