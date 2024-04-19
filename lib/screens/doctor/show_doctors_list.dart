import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/favoris_controller.dart';
import 'package:medix/models/doctor_model.dart';
import 'package:medix/widgets/doctor/doctor_card.dart';

class ShowDoctorsList extends StatelessWidget {
  ShowDoctorsList({
    super.key,
    required this.doctorsList,
    this.onTapItem,
  });

  final List<Doctor> doctorsList;
  final FavorisController favorisController = Get.find<FavorisController>();
  final Function? onTapItem;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: doctorsList.length,
        itemBuilder: (BuildContext context, int index) {
          final Doctor doctor = doctorsList[index];
          return Obx(() => DoctorCard(
              doctor: doctor,
              onTap: () async {
                await favorisController.addOrDeleteFavori('${doctor.id}');
                onTapItem?.call();
              },
              isFavorite:
                  favorisController.favorisList.contains('${doctor.id}')));
        });
  }
}
