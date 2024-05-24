import 'dart:convert';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:medix/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:medix/controllers/location_controller.dart';
import 'package:medix/models/work_place_location.dart';
import 'package:medix/services/perform_request.dart';
import 'package:medix/utils/utils.dart';

class ApiLocation {
  // Method to consume the OpenRouteService API
  Future<List<LatLng>> getCoordinates(
      {required String startPoint, required String endPoint}) async {
    // Raw coordinates got from  OpenRouteService
    List listOfPoints = [];

    // Conversion of listOfPoints into LatLng(Latitude, Longitude) list of points
    List<LatLng> points = [];
    try {
      // Requesting for openrouteservice api
      var response = await http.get(getRouteUrl(startPoint, endPoint));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        listOfPoints = data['features'][0]['geometry']['coordinates'];
        double segmentsDuration =
            data['features'][0]['properties']['segments'][0]['duration'] ?? 0.0;
        double segmentsDistance =
            data['features'][0]['properties']['segments'][0]['distance'] ?? 0.0;
        Get.find<LocationController>().segmentsDistance.value =
            segmentsDistance;
        Get.find<LocationController>().segmentsDuration.value =
            segmentsDuration;
        points = listOfPoints
            .map((p) => LatLng(p[1].toDouble(), p[0].toDouble()))
            .toList();
      }
    } catch (_) {}
    return points;
  }

  ///
  ///
  ///
  Future<List<WorkPlaceLocation>> fetchWorkPlaceLocations(
      {required double userLatitude, required double userLongitude}) async {
    String? token = await getToken();
    return await performRequest(
          endpoint:
              '/work-place-location?userLatitude=$userLatitude&userLongitude=$userLongitude',
          headers: buildHeader(token: token),
          method: 'POST',
          onSuccess: (dynamic data, int statusCode) {
            final List<dynamic> reviewRatingsList = data['data'];

            return reviewRatingsList
                .map((e) => WorkPlaceLocation.fromJson(e))
                .toList();
          },
        ) ??
        [];
  }

  getRouteUrl(String startPoint, String endPoint) {
    const String baseUrl =
        'https://api.openrouteservice.org/v2/directions/driving-car';
    String apiKey = openRouteApiKey;
    return Uri.parse(
        '$baseUrl?api_key=$apiKey&start=$startPoint&end=$endPoint');
  }
}
