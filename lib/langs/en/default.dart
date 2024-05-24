import 'package:medix/langs/en/appointment.dart';
import 'package:medix/langs/en/auth.dart';
import 'package:medix/langs/en/day.dart';
import 'package:medix/langs/en/doctor.dart';
import 'package:medix/langs/en/location.dart';
import 'package:medix/langs/en/notification.dart';
import 'package:medix/langs/en/profile.dart';
import 'package:medix/langs/en/speciality.dart';

final Map<String, String> en = {
  'empty-result': 'No results found',
  'contact': 'Contact',
  'email': 'Email',
  'phone': 'Phone',
  'date': 'Date',
  'app-language': 'App Language',
  "choose-from-device": "Choose from device",
  "to-take-a-picture": "To take a picture",
  "try": "Try again",
  ...specialitiesEN,
  ...appointmentEN,
  ...doctorEN,
  ...dayEN,
  ...notificationEN,
  ...profileEN,
  ...authEN,
  ...locationEN
};
