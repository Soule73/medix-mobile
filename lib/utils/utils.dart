import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:medix/constants/constants.dart';
import 'package:medix/controllers/lang_controller.dart';
import 'package:platform_device_id_v3/platform_device_id.dart';

/// Gestion sécurisée du stockage des données.
const storage = FlutterSecureStorage();

/// Récupère l'identifiant unique de l'appareil.
Future getDeviceId() async {
  String? deviceId = await PlatformDeviceId.getDeviceId;
  return deviceId;
}

/// Stocke le token d'authentification dans un stockage sécurisé.
Future storeToken(String token) async {
  await storage.write(key: 'auth', value: token);
}

/// Récupère le token d'authentification du stockage sécurisé.
Future<String?> getToken() async {
  final String? token = await storage.read(key: 'auth');
  return token;
}

/// Supprime le token d'authentification du stockage sécurisé.
Future deleteToken() async {
  await storage.delete(key: 'auth');
  await storage.delete(key: 'user');
}

/// Formate une date UTC en une chaîne de caractères localisée.
String formatDateTime(String utcDate) {
  initializeDateFormatting(Get.find<LangController>().lang.value, null);
  DateTime dateTime = DateTime.parse(utcDate);

  String formattedDate = DateFormat(
          "date-and-hour-format".trParams({
            'date': Get.find<LangController>().lang.value == "en"
                ? 'yyyy MMMM dd'
                : 'dd MMMM yyyy',
            'hour': 'HH:mm'
          }),
          Get.find<LangController>().lang.value)
      .format(dateTime.toLocal());

  return formattedDate;
}

String formatDate(String utcDate) {
  initializeDateFormatting(Get.find<LangController>().lang.value, null);
  DateTime dateTime = DateTime.parse(utcDate);

  String formattedDate = DateFormat(
          Get.find<LangController>().lang.value == "en"
              ? 'yyyy MMMM dd'
              : 'dd MMMM yyyy',
          Get.find<LangController>().lang.value)
      .format(dateTime.toLocal());

  return formattedDate;
}

/// Calcule le temps écoulé depuis une date donnée jusqu'à maintenant.
String timeFromNow(String dateString) {
  DateTime pastDate =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").parseUtc(dateString);
  DateTime now = DateTime.now().toUtc();
  Duration difference = now.difference(pastDate);

  int years = now.year - pastDate.year;
  int months = now.month - pastDate.month;
  int days = now.day - pastDate.day;

  if (days < 0) {
    months--;
    days += DateTime(pastDate.year, pastDate.month + 1, 0).day;
  }

  if (months < 0) {
    years--;
    months += 12;
  }

  int hours = difference.inHours % 24;
  int minutes = difference.inMinutes % 60;
  int seconds = difference.inSeconds % 60;

  String value = formatTime(
      years: years,
      months: months,
      days: days,
      hours: hours,
      minutes: minutes,
      seconds: seconds);

  return ('times-ago'.trParams({'time': value}));
}

/// Formate le temps écoulé en années, mois, jours, heures, minutes et secondes.
String formatTime(
    {required int years,
    required int months,
    required int days,
    required int hours,
    required int minutes,
    required int seconds}) {
  String value = '';
  String unit = '';
  int count = 0;

  if (years > 0) {
    unit = 'year';
    count = years;
  } else if (months > 0) {
    unit = 'month';
    count = months;
  } else if (days > 0) {
    unit = 'day';
    count = days;
  } else if (hours > 0) {
    unit = 'hour';
    count = hours;
  } else if (minutes > 0) {
    unit = 'minute';
    count = minutes;
  } else {
    unit = 'seconde';
    count = seconds;
  }

  String time = '$unit${count > 1 ? 's' : ''}';
  value = "$count ${time.tr}";
  return value;
}

/// Convertit une date UTC en une chaîne de caractères représentant la date.
String getDateFromUTC(String utcDate) {
  DateTime parsedDate = DateTime.parse(utcDate);
  String formattedDate =
      "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
  return formattedDate;
}

/// Convertit une date UTC en une chaîne de caractères représentant l'heure.
String getHourFromUTC(String utcDate) {
  DateTime parsedDate = DateTime.parse(utcDate);
  String formattedTime =
      "${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}";
  return formattedTime;
}

/// Génère une liste d'heures entre deux heures données.
List<String> generateHourList(String start, String end) {
  DateTime startTime = DateTime.parse("0000-01-01 $start");
  DateTime endTime = DateTime.parse("0000-01-01 $end");
  List<String> hoursList = [];

  for (DateTime currentTime = startTime;
      currentTime.isBefore(endTime.add(const Duration(minutes: 1)));
      currentTime = currentTime.add(const Duration(hours: 1))) {
    hoursList.add(DateFormat('HH:mm').format(currentTime));
  }

  return hoursList;
}

/// Ajoute une heure à une date donnée.
String addHourToDate(String date, String hour) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  String finalDateTime = "$formattedDate $hour:00";

  return finalDateTime;
}

/// Formate une URL pour une image réseau, en ajoutant l'URL de base si nécessaire.
String networkImage(String url) {
  return url.startsWith('/') ? "$assetURL$url" : url;
}
