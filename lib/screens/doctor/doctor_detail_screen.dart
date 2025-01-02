import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/controllers/favoris_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/models/doctor_model.dart';
import 'package:medix/models/qualification_model.dart';
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

class CollapseController extends GetxController {
  RxBool qualificationCollapse = true.obs;
  void setQualificationCollapse() {
    qualificationCollapse.value = !qualificationCollapse.value;
  }
}

class DoctorDetailScreen extends StatelessWidget {
  DoctorDetailScreen({super.key, required this.doctor});
  final doctorController = Get.find<DoctorController>();
  final CollapseController collapseController = Get.put(CollapseController());
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
                  _buildDctorInfo(),
                  _buildSpecialities(),
                  _buildYearAndPatientCount(),
                  _buildAvgRateAndPrice(),
                  _buildBio(context),
                  _buildOtherDetail(context)
                ]))),
        bottomNavigationBar: _buildBottomNavigationBar(),
        title: '${'doctor-profil'.tr} ');
  }

  Obx _buildBottomNavigationBar() {
    return Obx(() => doctorController.weeklySchedule.value != null
        ? Padding(
            padding: const EdgeInsets.only(bottom: 50.0),
            child: BottomBtn(doctor: doctor))
        : const SizedBox.shrink());
  }

  Obx _buildOtherDetail(BuildContext context) {
    return Obx(() => doctorController.isLoadingDoctorDetail.value
        ? _loadingIndiator()
        : Column(children: [
            _qualifications(),
            _viewSchedule(context),
            ReviewRatingList()
          ]));
  }

  Column _buildBio(BuildContext context) {
    return Column(
      children: [
        MeduimTitle(title: "doctor-about".tr),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
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
                            onTap: () =>
                                _shwoDoctorBio(context, '${doctor.bio}'),
                            child: Text(' ${'view-more'.tr}',
                                style:
                                    TextStyle(color: primary, fontSize: 16))))
                ]))),
      ],
    );
  }

  Row _buildAvgRateAndPrice() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1.0),
            child:
                FaIcon(FontAwesomeIcons.solidStar, color: primary, size: 20)),
        Text('${doctor.ratings}', style: const TextStyle(fontSize: 18))
      ]),
      Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Get.theme.primaryColor.withAlpha((0.1 * 255).toInt())),
          child: Text("${"consultation-price".tr} : ${doctor.visitPrice} MRU",
              style: const TextStyle(fontWeight: FontWeight.w600)))
    ]);
  }

  Container _buildYearAndPatientCount() {
    return Container(
        margin: const EdgeInsets.symmetric(vertical: 15),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Get.theme.primaryColor.withAlpha((0.1 * 255).toInt())),
        child: IntrinsicHeight(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
              IconWidgetDetail(
                  title: "+${doctor.patientsCount}",
                  subTitle: "doctor-patients".tr,
                  icon: FontAwesomeIcons.userGroup),
              VerticalDivider(
                color: Get.theme.dividerColor.withAlpha((0.2 * 255).toInt()),
                width: 2,
              ),
              IconWidgetDetail(
                  title: "+${doctor.yearExperience}",
                  subTitle: "doctor-experience".tr,
                  icon: FontAwesomeIcons.graduationCap)
            ])));
  }

  SpecialityBadge _buildSpecialities() {
    return SpecialityBadge(
        alignment: WrapAlignment.center,
        specialities: doctor.specialities!,
        fontSize: 12);
  }

  DoctorInfo _buildDctorInfo() {
    return DoctorInfo(
        tags: doctor.id!,
        avatar: networkImage('${doctor.avatar}'),
        phone: '${'phone'.tr} : ${doctor.phone}',
        fullName: '${doctor.professionalTitle} ${doctor.fullname}',
        email: '${'email'.tr} : ${doctor.email}',
        title: 'contact'.tr);
  }

  SizedBox _loadingIndiator() {
    return SizedBox(
        width: Get.width,
        height: 300,
        child: Center(child: CircularProgressIndicator(color: primary)));
  }

  Widget _qualifications() {
    return doctorController.qualificationList.value.isNotEmpty
        ? Container(
            padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
            decoration: BoxDecoration(
                color: Get.theme.primaryColor.withAlpha((0.1 * 255).toInt()),
                borderRadius: BorderRadius.circular(10.0)),
            child: Column(children: [
              GestureDetector(
                  onTap: () => collapseController.setQualificationCollapse(),
                  child: Row(children: [
                    Expanded(
                        flex: 5,
                        child: MeduimTitle(title: "qualifications".tr)),
                    Expanded(
                        flex: 1,
                        child: Center(
                            child: Obx(() =>
                                collapseController.qualificationCollapse.value
                                    ? const FaIcon(FontAwesomeIcons.chevronDown,
                                        size: 15.0)
                                    : const FaIcon(FontAwesomeIcons.chevronUp,
                                        size: 15.0))))
                  ])),
              Obx(() => collapseController.qualificationCollapse.value
                  ? const SizedBox.shrink()
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          doctorController.qualificationList.value.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return QualificationItem(
                            qualification:
                                doctorController.qualificationList.value[index],
                            last: index ==
                                doctorController
                                        .qualificationList.value.length -
                                    1);
                      }))
            ]),
          )
        : const SizedBox.shrink();
  }

  Widget _viewSchedule(context) {
    return doctorController.weeklySchedule.value != null
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 50),
            child: OutlinedBtn(
                height: 40,
                title: "view-timetable".tr,
                onPressed: () => _showFullScreenDialog(context)))
        : const SizedBox.shrink();
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

class QualificationItem extends StatelessWidget {
  const QualificationItem({
    super.key,
    required this.qualification,
    this.last = false,
  });

  final Qualification qualification;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: last
                    ? BorderSide.none
                    : BorderSide(
                        width: 2,
                        color: Get.theme.canvasColor
                            .withAlpha((0.7 * 255).toInt())))),
        child: Column(
          children: [
            SizedBox(
                width: double.infinity, child: Text('${qualification.name}')),
            SizedBox(
                width: double.infinity,
                child: Text('${qualification.institute}')),
            SizedBox(
                width: double.infinity,
                child: Text(formatDate('${qualification.procurementDate}'))),
          ],
        ));
  }
}

class ReviewRatingList extends StatelessWidget {
  ReviewRatingList({
    super.key,
  });

  final DoctorController doctorController = Get.find<DoctorController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitle(),
        Obx(() => doctorController.reviewRatings.value.isNotEmpty
            ? _buildReviewList()
            : _emptyResult()),
      ],
    );
  }

  Container _buildTitle() {
    return Container(
        padding: const EdgeInsets.only(bottom: 2.0),
        margin: const EdgeInsets.only(bottom: 5.0),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Get.theme.primaryColor
                        .withAlpha((0.3 * 255).toInt())))),
        child: MeduimTitle(title: "reviews".tr));
  }

  Column _buildReviewList() {
    return Column(
      children: [
        ...doctorController.reviewRatings.value
            .map((e) => ItemReviewWidget(reviewRatings: e))
      ],
    );
  }

  Padding _emptyResult() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 60.0),
      child: Center(
          child: Column(children: [
        SizedBox(
            width: Get.width * 0.6,
            height: 200,
            child:
                SvgPicture.asset('assets/svg/notification_ullustration.svg')),
        Text("no-patients-reviews".tr,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600))
      ])),
    );
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
                color: primary.withAlpha((0.2 * 255).toInt())),
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
