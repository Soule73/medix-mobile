import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:medix/constants/constants.dart';
import 'package:medix/constants/couleurs.dart';
import 'package:medix/controllers/doctor_controller.dart';
import 'package:medix/controllers/location_controller.dart';
import 'package:medix/layouts/default_scaffold.dart';
import 'package:medix/models/doctor_model.dart';
import 'package:medix/models/work_place_location.dart';
import 'package:medix/screens/doctor/doctor_detail_screen.dart';
import 'package:medix/services/api_doctor.dart';
import 'package:medix/utils/utils.dart';
import 'package:medix/widgets/boutons/button.dart';
import 'package:medix/widgets/doctor/back_btn.dart';
import 'package:medix/widgets/doctor/bottom_sheet.dart';
import 'package:medix/widgets/empty_result.dart';
import 'package:medix/widgets/speciality_badge.dart';

// Créer un widget sans état qui utilise le contrôleur GetX
class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldDefault(
        leading: const BackBtn(),
        title: "find-a-doctor".tr,
        actions: const [],
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 50),
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          decoration:
              BoxDecoration(color: Get.theme.primaryColor.withOpacity(0.07)),
          height: 70,
          child: Column(
            children: [
              Text(
                "find-a-closer-doctor".tr,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              Text(
                "only-places-within-a-maximum-radius-of-5km".tr,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(children: [
          SizedBox(
            width: double.infinity,
            height: Get.height * 0.8,
            child: const LocationFlutterMap(),
          )
        ]))));
  }
}

class LocationFlutterMap extends StatelessWidget {
  const LocationFlutterMap({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = Get.find<LocationController>();
    return _buildMap(locationController, context);
  }

  Widget _buildMap(
      LocationController locationController, BuildContext context) {
    return Obx(() {
      final currentPosition = locationController.currentPosition.value;
      final startPoint = LatLng(
        currentPosition?.latitude ?? 50.5,
        currentPosition?.longitude ?? 30.51,
      );

      if (locationController.isLoadLocation.value &&
          locationController.workPlaceLocations.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

      if (currentPosition != null &&
          locationController.workPlaceLocations.isNotEmpty) {
        return FlutterMap(
          options: MapOptions(
            initialZoom: 12.3,
            initialCenter: startPoint,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName:
                  applicationId, // Replace with your applicationId
            ),
            CircleLayer(circles: _buildCircles(startPoint)),
            MarkerLayer(
                markers: _buildMarkers(startPoint,
                    locationController.workPlaceLocations, context)),
          ],
        );
      } else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildEmptyResult(
              title: 'something-went-wrong-title'.tr,
              subTitle: "unable-to-display-map".tr,
            ),
            SizedBox(
              width: Get.width * 0.6,
              child: OutlinedBtn(
                height: 40,
                title: "try".tr,
                onPressed: () {
                  locationController.getchWorkPlaceLocations(
                      getLocationScreen: false);
                },
              ),
            )
          ],
        );
      }
    });
  }

  List<CircleMarker> _buildCircles(LatLng startPoint) {
    return [
      CircleMarker(
        point: startPoint,
        radius: 5000,
        useRadiusInMeter: true,
        color: Colors.red.withOpacity(0.1),
        borderColor: Colors.red.withOpacity(0.5),
        borderStrokeWidth: 2,
      ),
    ];
  }

  List<Marker> _buildMarkers(LatLng startPoint,
      RxList<WorkPlaceLocation> workPlaceLocations, BuildContext context) {
    final markers = <Marker>[
      Marker(
        point: startPoint,
        width: 80,
        height: 80,
        child: _buildCurrentLocationMarker('your-position'.tr),
      ),
    ];

    markers.addAll(workPlaceLocations.map((workPlaceLocation) => Marker(
          point:
              LatLng(workPlaceLocation.latitude!, workPlaceLocation.longitude!),
          width: 80,
          height: 80,
          child: _buildLocationMarker(
              workPlaceLocation: workPlaceLocation, context: context),
        )));

    return markers;
  }

  Widget _buildCurrentLocationMarker(String locationName) {
    return Column(
      children: [
        const Icon(
          Icons.location_on,
          color: Colors.red,
          size: 50,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
            child: Text(
              formatWorkPlaceName(locationName),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 9, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationMarker(
      {required WorkPlaceLocation workPlaceLocation,
      required BuildContext context}) {
    return GestureDetector(
        onTap: () => openLocationDetail(
            context: context, workPlaceLocation: workPlaceLocation),
        child: Column(children: [
          SizedBox(
              width: 80,
              height: 50,
              child: ClipOval(
                  child: Image.network('${workPlaceLocation.doctorAvatar}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.location_on,
                    color: Colors.red, size: 50);
              }))),
          Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 2.0),
                  child: Text(
                    formatWorkPlaceName('${workPlaceLocation.name}'),
                    style: const TextStyle(fontSize: 9, color: Colors.black),
                  )))
        ]));
  }

  String formatWorkPlaceName(String workPlaceName) {
    return workPlaceName.length > 15
        ? "${workPlaceName.substring(0, 12)}..."
        : workPlaceName;
  }

  openLocationDetail(
      {required BuildContext context,
      required WorkPlaceLocation workPlaceLocation}) {
    Widget doctorAvatar() {
      return workPlaceLocation.doctorAvatar != null &&
              workPlaceLocation.doctorAvatar == ""
          ? CircleAvatar(
              child: ClipOval(
                  child: SvgPicture.asset('assets/icons/avatar.svg',
                      fit: BoxFit.scaleDown)))
          : CircleAvatar(
              backgroundImage: NetworkImage(
                  networkImage('${workPlaceLocation.doctorAvatar}')),
              backgroundColor: primary,
            );
    }

    Future<void> getDoctor() async {
      DoctorController doctorController = Get.find<DoctorController>();
      doctorController.isLoadingDoctorDetail.value = true;
      int? doctorId = workPlaceLocation.doctorId;
      if (doctorId != null) {
        Doctor? doctor = await ApiDoctor().findDoctor(doctorId: doctorId);

        if (doctor != null) {
          Get.to(() => DoctorDetailScreen(doctor: doctor));
          doctorController.fetchDoctorDetails(doctorId);
        }
      }
      doctorController.isLoadingDoctorDetail.value = false;
    }

    return bottomSheet(
        height: 300,
        context: context,
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          SizedBox(width: 100, height: 100, child: doctorAvatar()),
          SpecialityBadge(
              alignment: WrapAlignment.center,
              specialities: workPlaceLocation.specialities ?? []),
          Text("${"doctor".tr} : ${workPlaceLocation.doctorFullname}"),
          Text("${"appointment-place".tr} : ${workPlaceLocation.name}"),
          Text("${"adresse".tr} : ${workPlaceLocation.address}"),
          Text(
              "${"approximate-radius".tr} : ${workPlaceLocation.distance?.toStringAsFixed(2)} Km"),
          SizedBox(
              width: Get.width * 0.6,
              child: Obx(() => OutlinedBtn(
                  isLoad:
                      Get.find<DoctorController>().isLoadingDoctorDetail.value,
                  height: 40,
                  title: "view-profile".tr,
                  onPressed: getDoctor)))
        ]));
  }
}
