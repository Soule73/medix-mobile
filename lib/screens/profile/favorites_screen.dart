import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medix/controllers/favoris_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/screens/doctor/show_doctors_list.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:medix/widgets/empty_result.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({super.key});
  final FavorisController favorisController = Get.find<FavorisController>();

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        leading: const BackBtn(),
        title: 'favorites'.tr,
        body: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(children: [_buildDoctorListOrLoading()])));
  }

  Widget _buildDoctorListOrLoading() {
    return Obx(() {
      if (favorisController.isLoadingFavoris.value) {
        return buildLoadingIndicator(height: Get.height * 0.9);
      } else if (favorisController.userFavrisDoctors.value.isEmpty) {
        return buildEmptyResult(height: Get.height * 0.6);
      } else {
        return ShowDoctorsList(
          onTapItem: () async => await favorisController.getFavris(),
          doctorsList: favorisController.userFavrisDoctors.value,
        );
      }
    });
  }
}
