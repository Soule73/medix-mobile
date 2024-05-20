import 'package:get/get.dart';
import 'package:medix/models/appointment_model.dart';

class AppointmentDetailController extends GetxController {
  Rx<Appointment> appointment = Rx<Appointment>(Appointment());
  Rx<ReviewRating?> reviewRating = Rx<ReviewRating?>(null);
}
