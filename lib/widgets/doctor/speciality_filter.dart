import 'package:flutter/material.dart';
import 'package:medix/constants/constants.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/controllers/speciality_controller.dart';
import 'package:medix/models/specility_model.dart';
import 'package:get/get.dart';

class SpecialityFilter extends StatelessWidget {
  SpecialityFilter({
    super.key,
  });

  final SpecialityController _specialityController =
      Get.find<SpecialityController>();
  final DoctorController doctorController = Get.find<DoctorController>();
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: kDefaultPadding),
        child: Column(children: [
          SizedBox(
              width: double.maxFinite,
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: primary))),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("Specialties".tr,
                          style: const TextStyle(fontSize: 20))))),
          Obx(() => _specialityController.isLoadingSpecialitys.value
              ? Center(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      CircularProgressIndicator(
                          color: Theme.of(context).primaryColor)
                    ]))
              : Column(children: [
                  ..._specialityController.specialitysList.map((element) =>
                      SpecialityCard(
                          onTap: () {
                            doctorController
                                .addOrDeleteInSpecialityFilter('${element.id}');
                          },
                          isSelected: doctorController.specialitiesListFilter
                              .contains('${element.id}'),
                          speciality: element))
                ]))
        ]));
  }
}

class SpecialityCard extends StatelessWidget {
  const SpecialityCard({
    super.key,
    required this.speciality,
    required this.isSelected,
    required this.onTap,
  });

  final Speciality speciality;
  final bool isSelected;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        activeColor: primary,
        checkColor: Colors.white,
        value: isSelected,
        onChanged: (val) => onTap.call(),
        title: Text(
          '${speciality.name}'.tr,
          style: isSelected
              ? TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: primary)
              : const TextStyle(fontSize: 16),
        ));
  }
}
