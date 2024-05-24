import 'package:medix/langs/ar/appointment.dart';
import 'package:medix/langs/ar/auth.dart';
import 'package:medix/langs/ar/day.dart';
import 'package:medix/langs/ar/doctor.dart';
import 'package:medix/langs/ar/location.dart';
import 'package:medix/langs/ar/notification.dart';
import 'package:medix/langs/ar/profile.dart';
import 'package:medix/langs/ar/speciality.dart';

final Map<String, String> ar = {
  "empty-result": "لم يتم العثور على نتائج",
  "contact": "اتصل بنا",
  "email": "البريد الإلكتروني",
  "phone": "هاتف",
  "date": "التاريخ",
  "app-language": "لغة التطبيق",
  "choose-from-device": "اختر من الجهاز",
  "to-take-a-picture": "التقاط صورة",
  "try": "حاول ثانية",
  ...specialitiesAR,
  ...appointmentAR,
  ...doctorAR,
  ...dayAR,
  ...notificationAR,
  ...profileAR,
  ...authAR,
  ...locationAR
};
