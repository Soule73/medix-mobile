import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/controllers/speciality_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/models/specility_model.dart';
import 'package:medix/screens/doctor/show_doctors_list.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:medix/widgets/empty_result.dart';
import 'package:medix/widgets/links.dart';

class TopDoctorBySpecility extends StatelessWidget {
  TopDoctorBySpecility({super.key});

  final DoctorController doctorController = Get.find<DoctorController>();
  final SpecialityController specialityController =
      Get.find<SpecialityController>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        leading: _buildBackButton(),
        titleWidget: _buildSearchField(),
        body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(children: [
              _buildSpecialityList(),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildDoctorListOrLoading())
            ])),
        bottomNavigationBar: _buildBottomNavigationBar());
  }

  Widget _buildBackButton() {
    return BackBtn(onPressed: () {
      Get.back();
    });
  }

  Widget _buildSearchField() {
    return TextField(
        onChanged: (value) {
          doctorController.search(value);
          doctorController.fetchDoctors();
        },
        decoration: _searchFieldDecoration());
  }

  InputDecoration _searchFieldDecoration() {
    return InputDecoration(
        contentPadding: const EdgeInsets.all(0),
        enabledBorder:
            _outlineInputBorder(Get.theme.primaryColor.withOpacity(0.1)),
        focusedBorder: _outlineInputBorder(primary),
        hintText: "search-doctor".tr,
        prefixIcon: Obx(() =>
            Get.find<DoctorController>().isLoadingDoctors.value
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

  Widget _buildBottomNavigationBar() {
    return Obx(() {
      return (doctorController.linksList.length > 3)
          ? Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 60),
              child: Links(
                linksList: doctorController.linksList,
                onLinkClick: doctorController.fetchDoctors,
              ),
            )
          : const SizedBox.shrink();
    });
  }

  Widget _buildSpecialityList() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
            height: 30.0,
            child: ListView.builder(
                itemCount: specialityController.specialitysList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return _buildSpecialityItem(index);
                })));
  }

  Widget _buildSpecialityItem(int index) {
    final Speciality speciality = specialityController.specialitysList[index];
    return InkWell(
        onTap: () {
          doctorController.currentSpecialityId.value = '${speciality.id}';
          doctorController.fetchDoctors();
        },
        child: Obx(() => Container(
            decoration: _specialityItemDecoration(speciality),
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
            child: Text('${speciality.name}'.tr,
                style: _specialityItemTextStyle(speciality)))));
  }

  BoxDecoration _specialityItemDecoration(Speciality speciality) {
    return BoxDecoration(
        border: Border(
            bottom: BorderSide(
                width: doctorController.currentSpecialityId.value ==
                        speciality.id.toString()
                    ? 3
                    : 1,
                color: doctorController.currentSpecialityId.value ==
                        speciality.id.toString()
                    ? primary
                    : Get.theme.dividerColor.withOpacity(0.3))));
  }

  TextStyle _specialityItemTextStyle(Speciality speciality) {
    return TextStyle(
        color: doctorController.currentSpecialityId.value ==
                speciality.id.toString()
            ? primary
            : Get.theme.primaryColor);
  }

  Widget _buildDoctorListOrLoading() {
    return Obx(() {
      if (doctorController.isLoadingDoctors.value) {
        return buildLoadingIndicator();
      } else if (doctorController.doctorsList.value.isEmpty) {
        return buildEmptyResult();
      } else {
        return ShowDoctorsList(doctorsList: doctorController.doctorsList.value);
      }
    });
  }
}
