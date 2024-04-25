import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/appointment_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/screens/appointment/appointment_detail_screen.dart';
import 'package:medix/screens/welcome_screen.dart';
import 'package:medix/utils/utils.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:medix/widgets/doctor/doc_info.dart';
import 'package:medix/widgets/links.dart';

class TabBarController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController? tabController;
  List<String> status = [
    'pending',
    'accepted',
    'finished',
    'denied',
  ];
  final AppointmentController _appointmentController =
      Get.find<AppointmentController>();
  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: status.length, vsync: this);
    int? index = tabController?.index;

    if (_appointmentController.appointmentList.value.isEmpty && index != null) {
      _appointmentController.fetchUserAppointment(status: status[index]);
    }
    tabController?.addListener(() {
      int? newIndex = tabController?.index;
      if (newIndex != null) {
        _appointmentController.fetchUserAppointment(status: status[newIndex]);
      }
    });
  }
}

class AppointmentScreen extends StatelessWidget {
  AppointmentScreen({super.key, this.back = true});

  final bool back;

  final AppointmentController appointmentController =
      Get.find<AppointmentController>();
  final TabBarController tabController = Get.put(TabBarController());
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tabs = [
      {'title': 'appointment-pending'.tr},
      {'title': 'appointment-accepted'.tr},
      {'title': 'appointment-finished'.tr},
      {'title': 'appointment-denied'.tr}
    ];
    return ScaffoldDefault(
        leading: BackBtn(
            onPressed: back ? null : () => Get.to(() => WelcomeScreen())),
        actions: const [],
        title: "patient-appointments".tr,
        body: Column(children: <Widget>[
          TabBar(
              labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              controller: tabController.tabController,
              tabs: [...tabs.map((tab) => TabItem(title: tab['title']))]),
          Expanded(child: Obx(() {
            Widget buildTabViewItem(String emptyTitle) {
              return appointmentController.isLoad.value
                  ? Center(child: CircularProgressIndicator(color: primary))
                  : TabViewItem(
                      emptytitle: emptyTitle,
                      appointmentList:
                          appointmentController.appointmentList.value);
            }

            return TabBarView(
                controller: tabController.tabController,
                children: [
                  buildTabViewItem('patient-appointments-empty-pending'.tr),
                  buildTabViewItem('patient-appointments-empty-acceted'.tr),
                  buildTabViewItem("patient-appointments-empty-denied".tr),
                  buildTabViewItem('patient-appointments-empty-denied'.tr)
                ]);
          }))
        ]),
        bottomNavigationBar: Obx(() => appointmentController.linksList.length >
                3
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Links(
                    linksList: appointmentController.linksList,
                    onLinkClick: (link) =>
                        appointmentController.fetchUserAppointment(url: link)))
            : const SizedBox.shrink()));
  }
}

class TabViewItem extends StatelessWidget {
  const TabViewItem({
    super.key,
    required this.appointmentList,
    this.emptytitle,
  });

  final List<Appointment?> appointmentList;
  final String? emptytitle;

  @override
  Widget build(BuildContext context) {
    return appointmentList.isNotEmpty
        ? SingleChildScrollView(
            child: Column(children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: appointmentList.length,
                itemBuilder: (BuildContext context, int index) {
                  return AppointmentItem(
                      appointment: appointmentList[index]!, index: index);
                })
          ]))
        : Center(
            child: Column(children: [
            SizedBox(
                width: (Get.width / 3) * 2,
                height: (Get.height / 2),
                child: SvgPicture.asset('assets/icons/taken_empty.svg')),
            Text('empty-result'.tr,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w600)),
            Text(emptytitle ?? '')
          ]));
  }
}

class AppointmentItem extends StatelessWidget {
  const AppointmentItem({
    super.key,
    required this.appointment,
    this.index,
  });

  final Appointment appointment;
  final int? index;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: _getDetailScreen,
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Get.theme.primaryColor.withOpacity(0.1)),
            child: DoctorInfo(
                isHero: false,
                tags: appointment.doctorId!,
                avatar: networkImage('${appointment.doctorAvatar}'),
                phone: '${'phone'.tr} : ${appointment.doctorPhone}',
                fullName:
                    '${appointment.doctorProfessionalTitle} ${(appointment.doctorFullname)}',
                email:
                    '${'date'.tr} : ${formatDateTime('${appointment.dateAppointment}')}',
                title: 'contact'.tr)));
  }

  void _getDetailScreen() {
    Get.to(() => AppointmentDetailScreen(
          index: index,
          appointment: appointment,
        ));
  }
}

class TabItem extends StatelessWidget {
  const TabItem({
    super.key,
    required this.title,
  });

  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: Text(title, style: const TextStyle(fontSize: 14)));
  }
}
