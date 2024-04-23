import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medix/constants/constants.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/controllers/notification_controller.dart';
import 'package:medix/controllers/speciality_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/models/specility_model.dart';
import 'package:medix/screens/doctor/show_doctors_list.dart';
import 'package:medix/screens/doctor/top_doctors_by_specility.dart';
import 'package:medix/widgets/boutons/button.dart';
import 'package:medix/widgets/doctor/bottom_sheet_speciality.dart';
import 'package:medix/widgets/doctor/speciality_filter.dart';
import 'package:medix/widgets/empty_result.dart';
import 'package:medix/widgets/filter.dart';

class Fetch extends GetxController {
  final DoctorController doctorController = Get.find<DoctorController>();
  @override
  void onInit() async {
    super.onInit();
    if (doctorController.topDoctorsList.value.isEmpty) {
      await doctorController.fetchDoctors();
      await Get.find<NotificationController>().getPatientNotification();
    }
  }
}

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final DoctorController doctorController = Get.find<DoctorController>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
                child: Column(children: <Widget>[
                  SearchBarithFilter(doctorController: doctorController),
                  AllSpecialitiesWithIcon(),
                  _buildDoctorListOrLoading()
                ]))));
  }

  Widget _buildDoctorListOrLoading() {
    return Column(children: [
      _buildDoctorsHeader(),
      Obx(() {
        if (doctorController.isLoadingDoctors.value &&
            doctorController.topDoctorsList.value.isEmpty) {
          return buildLoadingIndicator();
        } else if (doctorController.topDoctorsList.value.isNotEmpty) {
          return DoctorListBuilder(doctorController: doctorController);
        } else {
          return Column(children: [
            buildEmptyResult(),
            Padding(
                padding: const EdgeInsets.only(
                    top: 10.0, left: 50, right: 50, bottom: 10),
                child: OutlinedBtn(
                    height: 40,
                    onPressed: () => doctorController.fetchDoctors(),
                    title: "try".tr))
          ]);
        }
      })
    ]);
  }

  Widget _buildDoctorsHeader() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            "top-doctors".tr,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          _buildSeeAllText()
        ]));
  }

  InkWell _buildSeeAllText() {
    return InkWell(
        onTap: () => _navigateToTopDoctors(),
        child: Text("see-all".tr,
            style: TextStyle(
                color: primary, fontWeight: FontWeight.w600, fontSize: 15)));
  }

  void _navigateToTopDoctors() {
    Get.to(() => TopDoctorBySpecility());
  }
}

class SearchBarithFilter extends StatelessWidget {
  const SearchBarithFilter({
    super.key,
    required this.doctorController,
  });

  final DoctorController doctorController;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [_buildSearchField(context), _buildFilterButton(context)]);
  }

  Widget _buildSearchField(BuildContext context) {
    return Expanded(
        child: SizedBox(
            height: 45,
            child: TextField(
                onChanged: (value) => _onSearchChanged(context, value),
                decoration: _searchFieldDecoration())));
  }

  InputDecoration _searchFieldDecoration() {
    return InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        enabledBorder:
            _outlineInputBorder(Get.theme.primaryColor.withOpacity(0.1)),
        focusedBorder: _outlineInputBorder(primary),
        hintText: "search-doctor".tr,
        prefixIcon: Obx(() =>
            Get.find<DoctorController>().isLoadingDoctors.value &&
                    Get.find<DoctorController>().search.value != ""
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: Center(
                      child: SizedBox(
                        width: 15,
                        height: 15,
                        child: CircularProgressIndicator.adaptive(
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                  )
                : SvgPicture.asset('assets/icons/search.svg',
                    fit: BoxFit.scaleDown)));
  }

  OutlineInputBorder _outlineInputBorder(Color borderColor) {
    return OutlineInputBorder(
        borderSide: BorderSide(color: borderColor),
        borderRadius: BorderRadius.circular(8.0));
  }

  void _onSearchChanged(BuildContext context, String value) {
    doctorController.search(value);
    doctorController.fetchDoctors();
  }

  Widget _buildFilterButton(BuildContext context) {
    return FilterButton(tap: () => _openFilterBottomSheet(context));
  }

  void _openFilterBottomSheet(BuildContext context) {
    openBottomSheetSpecility(
        context: context,
        children: Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Column(children: [SpecialityFilter()])),
        title: Text("filter-speciality".tr,
            style: TextStyle(color: white, fontWeight: FontWeight.w600)),
        footer: _buildApplyButton(context));
  }

  Widget _buildApplyButton(BuildContext context) {
    return OutlinedBtn(
        onPressed: () {
          doctorController.fetchDoctors();
          Get.back();
        },
        title: "apply".tr);
  }
}

class DoctorListBuilder extends StatelessWidget {
  const DoctorListBuilder({super.key, required this.doctorController});

  final DoctorController doctorController;

  @override
  Widget build(BuildContext context) {
    return ShowDoctorsList(doctorsList: doctorController.topDoctorsList.value);
  }
}

String formatSpecialityName(String name) {
  return name.length > 15 ? '${name.substring(0, 15)}...' : name;
}

class AllSpecialitiesWithIcon extends StatelessWidget {
  AllSpecialitiesWithIcon({super.key});

  final SpecialityController specialityController =
      Get.find<SpecialityController>();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      _buildHeader(context),
      Obx(() => specialityController.isLoadingSpecialitys.value
          ? Center(child: CircularProgressIndicator(color: primary))
          : _buildSpecialityGridOrRetryButton())
    ]);
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("doctors-specialities".tr,
              style:
                  const TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
          InkWell(
              onTap: () => showAllSpecialityInbottomSheet(
                  context: context,
                  specialitysList: specialityController.specialitysList),
              child: Text("see-all".tr,
                  style: TextStyle(
                      color: primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15)))
        ]));
  }

  Widget _buildSpecialityGridOrRetryButton() {
    return specialityController.specialitysList.length > 1
        ? _buildSpecialityGrid()
        : Padding(
            padding: const EdgeInsets.only(
                top: 10.0, left: 50, right: 50, bottom: 10),
            child: OutlinedBtn(
                height: 40,
                onPressed: () => specialityController.fetchSpecialities(),
                title: "try".tr));
  }

  Widget _buildSpecialityGrid() {
    return Column(children: [
      MasonryGridView.count(
          crossAxisCount: 4,
          itemCount: specialityController.specialitysList.take(5).length,
          crossAxisSpacing: 10,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          mainAxisSpacing: 0,
          itemBuilder: (context, index) {
            return specialityController.specialitysList[index].name == "All"
                ? const SizedBox.shrink()
                : SpecialityWithIconItem(
                    speciality: specialityController.specialitysList[index]);
          })
    ]);
  }
}

showAllSpecialityInbottomSheet(
    {required BuildContext context,
    required List<Speciality> specialitysList}) {
  return openBottomSheetSpecility(
      context: context,
      title: Text('all-specialities'.tr,
          style: TextStyle(color: white, fontWeight: FontWeight.w600)),
      children: MasonryGridView.count(
          crossAxisCount: 4,
          itemCount: specialitysList.length,
          crossAxisSpacing: 10,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          mainAxisSpacing: 0,
          itemBuilder: (context, index) {
            return specialitysList[index].name == "All"
                ? const SizedBox.shrink()
                : SpecialityWithIconItem(speciality: specialitysList[index]);
          }));
}

class SpecialityWithIconItem extends StatelessWidget {
  const SpecialityWithIconItem({
    super.key,
    required this.speciality,
  });
  final Speciality speciality;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Get.find<DoctorController>().currentSpecialityId.value =
              '${speciality.id}';
          Get.find<DoctorController>().fetchDoctors();
          Get.to(() => TopDoctorBySpecility());
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(children: [
              Container(
                  padding: const EdgeInsets.all(10.0),
                  margin: const EdgeInsets.only(bottom: 3.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: primary.withOpacity(0.3)),
                  child: Icon(
                      size: 30,
                      color: primary,
                      specialitiesIcon[speciality.name])),
              Text(formatSpecialityName('${speciality.name?.tr}'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10))
            ])));
  }
}
