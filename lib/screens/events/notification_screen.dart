import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/notification_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/models/notification_model.dart';
import 'package:medix/widgets/bottom_sheet_action_item.dart';
import 'package:medix/widgets/doctor/bottom_sheet.dart';
import 'package:medix/widgets/empty_result.dart';
import 'package:medix/widgets/links.dart';

class CheckNew extends GetxController {
  NotificationController notificationController =
      Get.find<NotificationController>();
  @override
  void onInit() async {
    super.onInit();
    await notificationController.getPatientNotification();
  }
}

class NotificationScreen extends StatelessWidget {
  NotificationScreen({super.key});

  final NotificationController notificationController =
      Get.find<NotificationController>();
  final CheckNew checkNew = Get.put(CheckNew());

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        title: 'notifications'.tr,
        body: _buildBody(),
        floatingActionButton: _buildFloatingActionButton(),
        bottomNavigationBar: _buildBottomNavigationBar());
  }

  Widget _buildBody() {
    return SingleChildScrollView(
        child: Column(children: [
      Obx(() => notificationController.isLoad.value
          ? buildLoadingIndicator()
          : _buildNotificationList())
    ]));
  }

  Widget _buildNotificationList() {
    return notificationController.notificationList.value.isNotEmpty
        ? AllNotifiatiions(
            notificationList: notificationController.notificationList.value)
        : _buildNoNotifications();
  }

  Widget _buildNoNotifications() {
    return Center(
        child: Column(children: [
      SizedBox(
          width: Get.width * 0.6,
          height: Get.height * 0.6,
          child: SvgPicture.asset('assets/svg/notification_ullustration.svg')),
      Text('no-notifications'.tr,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600))
    ]));
  }

  Widget _buildFloatingActionButton() {
    return Obx(() => GestureDetector(
        onTap: () => notificationController.isLoad.value
            ? null
            : notificationController.getPatientNotification(),
        child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Get.theme.primaryColor.withOpacity(0.3)),
            child: notificationController.isLoad.value
                ? buildLoadingIndicatorSmall(color: primary)
                : Icon(Icons.refresh, color: primary))));
  }

  Widget _buildBottomNavigationBar() {
    return Obx(() => (notificationController.linksList.length > 3
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Links(
                linksList: notificationController.linksList,
                onLinkClick: notificationController.getPatientNotification))
        : const SizedBox.shrink()));
  }
}

class AllNotifiatiions extends StatelessWidget {
  const AllNotifiatiions({
    super.key,
    required this.notificationList,
  });

  final List<Notification?> notificationList;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListView.builder(
          shrinkWrap: true,
          itemCount: notificationList.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return NotificationItem(
                index: index,
                notification: notificationList[index]!,
                last: index == notificationList.length - 1);
          })
    ]);
  }
}

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.notification,
    required this.last,
    required this.index,
  });

  final Notification notification;
  final bool last;
  final int index;

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, dynamic>> status = {
      "success": {"icon": FontAwesomeIcons.solidCircleCheck, "color": success},
      "danger": {"icon": FontAwesomeIcons.solidCircleXmark, "color": error}
    };
    final borderColor = last
        ? null
        : Border(
            bottom: BorderSide(
                width: 1,
                color: notification.readAt != null
                    ? Get.theme.primaryColor.withOpacity(0.1)
                    : Get.theme.canvasColor.withOpacity(0.5)));

    final backgroundColor = notification.readAt != null
        ? null
        : Get.theme.primaryColor.withOpacity(0.2);

    return InkWell(
        onTap: () {
          int? appointmentId = notification.appointmentId;
          if (appointmentId != null) {
            Get.find<NotificationController>().findAppointment(
                appointmentId: notification.appointmentId!,
                index: index,
                notificationId: '${notification.id}');
          }
        },
        child: SizedBox(
            width: double.infinity,
            child: Container(
                decoration:
                    BoxDecoration(border: borderColor, color: backgroundColor),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              FaIcon(status[notification.status]?['icon'],
                                  color: status[notification.status]?['color'],
                                  size: 20),
                              const SizedBox(width: 5),
                              Text(formatNotificationTitle(notification.title!),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600))
                            ]),
                            GestureDetector(
                                onTap: () => notificationActions(context),
                                child: const Icon(Icons.more_horiz_outlined,
                                    size: 25))
                          ])),
                  Text('${notification.body}')
                ]))));
  }

  Future<void> notificationActions(BuildContext context) async {
    return bottomSheet(
        context: context,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _buildActionItems(context)));
  }

  List<Widget> _buildActionItems(BuildContext context) {
    var items = <Widget>[];

    if (notification.readAt == null) {
      items.add(bottomSheetActionItem(
          icon: Icons.check_box,
          text: "mark-notification-as-read".tr,
          onTap: () => _markAsRead(context)));
    }

    items.add(bottomSheetActionItem(
        icon: Icons.delete_forever,
        text: "delete-notification".tr,
        onTap: () => _deleteNotification(context)));

    return items;
  }

  void _markAsRead(BuildContext context) {
    Get.find<NotificationController>().notificationMarkAsRead(
        notificationId: '${notification.id}', index: index);
    Get.back();
  }

  void _deleteNotification(BuildContext context) {
    Get.find<NotificationController>()
        .notificationDelete(notificationId: '${notification.id}', index: index);
    Get.back();
  }

  String formatNotificationTitle(String title) {
    return title.length > 27 ? '${title.substring(0, 27)}...' : title;
  }
}
