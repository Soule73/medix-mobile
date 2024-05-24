import 'package:medix/langs/fr/appointment.dart';
import 'package:medix/langs/fr/auth.dart';
import 'package:medix/langs/fr/day.dart';
import 'package:medix/langs/fr/doctor.dart';
import 'package:medix/langs/fr/location.dart';
import 'package:medix/langs/fr/notification.dart';
import 'package:medix/langs/fr/profile.dart';
import 'package:medix/langs/fr/speciality.dart';

final Map<String, String> fr = {
  "empty-result": "Aucun résultat trouvé",
  "contact": "Contact",
  "email": "Email",
  "phone": "Téléphone",
  "date": "Date",
  "app-language": "Langue de l'application",
  "choose-from-device": "Choisir dans l'appareil",
  "to-take-a-picture": "Prendre une photo",
  "try": "Réessayez",
  ...specialitiesFR,
  ...appointmentFR,
  ...doctorFR,
  ...dayFR,
  ...notificationFR,
  ...profileFR,
  ...authFR,
  ...locationFR
};
