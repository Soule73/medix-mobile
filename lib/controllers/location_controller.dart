import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:medix/controllers/appointment_detail_controller.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/models/work_place_location.dart';
import 'package:medix/screens/location/location_screen.dart';
import 'package:medix/services/api_location.dart';
import 'package:medix/utils/alert_dialog.dart';
import 'package:medix/utils/utils.dart';

// Créer un contrôleur GetX qui contient les variables et les méthodes d'état
class LocationController extends GetxController {
  // Déclarer les variables d'état
  RxString? currentAddress = "".obs;
  RxInt currentAppointmentId = 0.obs;
  Rx<Position?> currentPosition = Rx<Position?>(null);
  RxBool isLoadLocation = false.obs;
  RxBool isLoadToGetCurrentPosition = false.obs;
  RxBool locationPermission = false.obs;
  ApiLocation apiLocation = ApiLocation();
  RxList<WorkPlaceLocation> workPlaceLocations = RxList<WorkPlaceLocation>([]);
  RxDouble segmentsDistance = 0.0.obs;
  RxDouble segmentsDuration = 0.0.obs;

  // Conversion of listOfPoints into LatLng(Latitude, Longitude) list of points
  RxList<LatLng> points = RxList<LatLng>([]);
  @override
  onInit() async {
    super.onInit;
    var permission = await Geolocator.checkPermission();

    if (!(permission == LocationPermission.denied)) {
      handleLocationPermission();
    } else {
      getCoordinates();
    }
  }

  // Définir les méthodes d'état comme des fonctions normales
  Future<void> handleLocationPermission() async {
    // Vérifier si les services de localisation sont activés
    if (!await Geolocator.isLocationServiceEnabled()) {
      errorDialog(title: "info".tr, body: 'location-services-are-disabled'.tr);
      return;
    }

    // Vérifier l'état de l'autorisation de localisation
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Demander l'autorisation si elle est refusée
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        errorDialog(title: "info".tr, body: 'location-permissions-are-denied');
        return;
      }
    }

    // Gérer le cas où l'autorisation est refusée de manière permanente
    if (permission == LocationPermission.deniedForever) {
      errorDialog(
          title: "info".tr,
          body: "location-permissions-are-permanently-denied".tr);
      return;
    }

    // Si l'autorisation est accordée, mettre à jour l'état
    locationPermission.value = true;
  }

  Future<void> getCoordinates() async {
    if (currentPosition.value == null) {
      await getCurrentPosition();
    }
    Appointment appointment =
        Get.find<AppointmentDetailController>().appointment.value;

    if (currentAppointmentId.value != appointment.id && points.isEmpty) {
      String startPoint =
          "${currentPosition.value?.longitude},${currentPosition.value?.latitude}";
      String endPoint =
          "${appointment.workPlaceLongitude},${appointment.workPlaceLatitude}";
      points.value = await apiLocation.getCoordinates(
          startPoint: startPoint, endPoint: endPoint);

      currentAppointmentId.value = appointment.id ?? 0;
    }
  }

  Future<void> getCurrentPosition() async {
    isLoadToGetCurrentPosition.value = true;
    if (!locationPermission.value) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition.value = position;
      isLoadToGetCurrentPosition.value = false;
    }).catchError((e) {
      isLoadToGetCurrentPosition.value = false;
    });

    isLoadToGetCurrentPosition.value = false;
  }

  Future<void> getchWorkPlaceLocations({bool getLocationScreen = true}) async {
    isLoadLocation.value = true;
    if (getLocationScreen) {
      Get.to(() => const LocationScreen());
    }
    if (currentPosition.value == null) {
      await getCurrentPosition();
    }
    double? userLatitude = currentPosition.value?.latitude;
    double? userLongitude = currentPosition.value?.longitude;
    if (userLatitude != null && userLongitude != null) {
      workPlaceLocations.value = await apiLocation.fetchWorkPlaceLocations(
          userLatitude: userLatitude, userLongitude: userLongitude);
    }
    isLoadLocation.value = false;
  }

  String distance() {
    // Calculer le reste avec l'opérateur %
    double r = segmentsDistance.value % 1000;

    // Calculer le quotient avec l'opérateur ~/
    int q = segmentsDistance.value ~/ 1000;
    return "${q > 0 ? '${q}km' : ''} ${r > 0 ? '${r.toStringAsFixed(2)} m' : ''}";
  }

  String duration() {
    return formatDuration(segmentsDuration.value);
  }
}
