import 'package:get/get.dart';
import 'package:medix/models/appointment_model.dart';
import 'package:medix/services/api_doctor.dart';
import 'package:medix/utils/alert_dialog.dart';

class ReviewIsEmpty extends GetxController {
  RxBool noReview = true.obs;
  Rx<Appointment?> appointment = Rx<Appointment?>(null);

  Future<void> deleteReview(int id) async {
    appointment.value?.reviewRating = null;
    noReview.value = true;
    final ReviewRating? rating = appointment.value?.reviewRating;
    ApiDoctor apiDoctor = ApiDoctor();
    final bool success = await apiDoctor.deleteRate(id: id);
    if (success) {
      successDialog(title: "success".tr, body: "review-delete".tr);
    } else {
      appointment.value?.reviewRating = rating;
      noReview.value = false;
      defaultErrorDialog();
    }
    update();
  }
}
