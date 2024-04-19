import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/controllers/favoris_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/models/doctor_model.dart';
import 'package:medix/screens/doctor/book_appointment_screen.dart';
import 'package:medix/screens/doctor/schedule_screen.dart';
import 'package:medix/utils/format_string.dart';
import 'package:medix/utils/utils.dart';
import 'package:medix/widgets/boutons/button.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:medix/widgets/doctor/doc_info.dart';
import 'package:medix/widgets/full_modal.dart';
import 'package:medix/widgets/is_favorite.dart';
import 'package:medix/widgets/reviews_rating.dart';
import 'package:medix/widgets/speciality_badge.dart';

class DoctorDetailScreen extends StatelessWidget {
  DoctorDetailScreen({super.key, required this.doctor});
  final doctorController = Get.find<DoctorController>();
  final Doctor doctor;
  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        leading: const BackBtn(),
        actions: [IconFavorite(id: doctor.id!)],
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                  right: 10.0,
                  left: 10.0,
                ),
                child: Column(children: [
                  DoctorInfo(
                      tags: doctor.id!,
                      avatar: networkImage('${doctor.avatar}'),
                      phone: '${'phone'.tr} : ${doctor.phone}',
                      fullName:
                          '${doctor.professionalTitle} ${doctor.fullname}',
                      email: '${'email'.tr} : ${doctor.email}',
                      title: 'contact'.tr),
                  SpecialityBadge(
                      alignment: WrapAlignment.center,
                      specialities: doctor.specialities!,
                      fontSize: 12),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Get.theme.primaryColor.withOpacity(0.1)),
                      child: IntrinsicHeight(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                            IconWidgetDetail(
                                title: "+${doctor.patientsCount}",
                                subTitle: "doctor-patients".tr,
                                icon: FontAwesomeIcons.userGroup),
                            VerticalDivider(
                              color: Get.theme.dividerColor.withOpacity(0.2),
                              width: 2,
                            ),
                            IconWidgetDetail(
                                title: "+${doctor.yearExperience}",
                                subTitle: "doctor-experience".tr,
                                icon: FontAwesomeIcons.graduationCap)
                          ]))),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              child: FaIcon(FontAwesomeIcons.solidStar,
                                  color: primary, size: 20)),
                          Text('${doctor.ratings}',
                              style: const TextStyle(fontSize: 18))
                        ]),
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Get.theme.primaryColor.withOpacity(0.1)),
                            child: Text(
                                "${"consultation-price".tr} : ${doctor.visitPrice} MRU",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)))
                      ]),
                  MeduimTitle(title: "doctor-about".tr),
                  Container(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: RichText(
                          text: TextSpan(
                              style: TextStyle(
                                  fontSize: 16,
                                  wordSpacing: 2,
                                  color: Get.theme.primaryColor),
                              text: formatDoctorBio('${doctor.bio}'),
                              children: <InlineSpan>[
                            if ('${doctor.bio}'.length > 200)
                              WidgetSpan(
                                  child: GestureDetector(
                                      onTap: () => _shwoDoctorBio(
                                          context, '${doctor.bio}'),
                                      child: Text(' ${'view-more'.tr}',
                                          style: TextStyle(
                                              color: primary, fontSize: 16))))
                          ]))),
                  Obx(() => doctorController.isLoadingDoctorDetail.value
                      ? SizedBox(
                          width: Get.width,
                          height: 300,
                          child: Center(
                              child: CircularProgressIndicator(color: primary)))
                      : Column(children: [
                          doctorController.weeklySchedule.value != null
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0, horizontal: 50),
                                  child: OutlinedBtn(
                                      height: 40,
                                      title: "view-timetable".tr,
                                      onPressed: () =>
                                          _showFullScreenDialog(context)))
                              : const SizedBox.shrink(),
                          Container(
                              padding: const EdgeInsets.only(bottom: 2.0),
                              margin: const EdgeInsets.only(bottom: 5.0),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          color: Get.theme.primaryColor
                                              .withOpacity(0.3)))),
                              child: MeduimTitle(title: "reviews".tr)),
                          Obx(() => doctorController
                                  .reviewRatings.value.isNotEmpty
                              ? Column(
                                  children: [
                                    ...doctorController.reviewRatings.value.map(
                                        (e) =>
                                            ItemReviewWidget(reviewRatings: e))
                                  ],
                                )
                              : Center(
                                  child: Column(children: [
                                  SizedBox(
                                      width: Get.width * 0.6,
                                      height: 200,
                                      child: SvgPicture.asset(
                                          'assets/svg/notification_ullustration.svg')),
                                  Text("no-patients-reviews".tr,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600))
                                ])))
                        ]))
                ]))),
        bottomNavigationBar: Obx(() =>
            doctorController.weeklySchedule.value != null
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 50.0),
                    child: BottomBtn(doctor: doctor))
                : const SizedBox.shrink()),
        title: '${'doctor-profil'.tr} ');
  }

  void _showFullScreenDialog(BuildContext context) {
    showFullScreenDialog(
        context: context,
        title: 'timetable'.tr,
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(() => doctorController.weeklySchedule.value != null
                    ? SizedBox(
                        width: double.infinity,
                        child: ScheduleWidget(
                            weeklySchedule:
                                doctorController.weeklySchedule.value!))
                    : const SizedBox.shrink()))));
  }

  void _shwoDoctorBio(BuildContext context, String doctorBio) {
    showFullScreenDialog(
        context: context,
        title: 'about-doctor'.tr,
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text('$doctorBio$doctorBio$doctorBio',
                    style: const TextStyle(fontSize: 18)))));
  }
}

class IconFavorite extends StatelessWidget {
  IconFavorite({super.key, required this.id});

  final int id;
  final FavorisController favorisController = Get.find<FavorisController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
        onTap: _addOrDeleteFavori,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: buildFavoriteIcon(
                isFavorite:
                    favorisController.favorisList.contains(id.toString())))));
  }

  void _addOrDeleteFavori() async {
    await favorisController.addOrDeleteFavori(id.toString());
  }
}

class MeduimTitle extends StatelessWidget {
  const MeduimTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 18.0, top: 8.0),
        child: SizedBox(
            width: double.infinity,
            child: Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 20))));
  }
}

class IconWidgetDetail extends StatelessWidget {
  const IconWidgetDetail({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
  });

  final IconData icon;
  final String title;
  final String subTitle;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Row(children: [
        Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(85),
                color: primary.withOpacity(0.2)),
            child: FaIcon(icon, size: 25, color: primary)),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 20,
                      color: primary,
                      fontWeight: FontWeight.w700)),
              Text(subTitle, style: const TextStyle(fontSize: 12))
            ]))
      ])
    ]);
  }
}

class BottomBtn extends StatelessWidget {
  const BottomBtn({
    super.key,
    required this.doctor,
  });
  final Doctor doctor;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            const EdgeInsets.only(bottom: 10.0, left: 50, right: 50, top: 5),
        child: FadeBtn(
            height: 40,
            onPressed: () => Get.to(() => BookAppointmentScreen(
                  doctor: doctor,
                )),
            title: 'book-appointment'.tr));
  }
}
