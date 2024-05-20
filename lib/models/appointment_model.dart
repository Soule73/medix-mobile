class Appointment {
  int? id;
  int? patientId;
  String? dateAppointment;
  String? rescheduleDate;
  bool? addByDoctor;
  String? reasonForRefusal;
  String? acceptedMessage;
  String? motif;
  String? status;
  bool? payed;
  String? amount;
  String? discount;
  int? doctorId;
  String? doctorAvatar;
  String? doctorFullname;
  String? doctorEmail;
  String? doctorPhone;
  String? doctorProfessionalTitle;
  int? workPlaceId;
  String? workPlaceName;
  String? workPlaceAddress;
  double? workPlaceLatitude;
  double? workPlaceLongitude;
  ReviewRating? reviewRating;

  Appointment(
      {this.id,
      this.patientId,
      this.dateAppointment,
      this.rescheduleDate,
      this.addByDoctor,
      this.reasonForRefusal,
      this.acceptedMessage,
      this.motif,
      this.status,
      this.payed,
      this.amount,
      this.discount,
      this.doctorId,
      this.doctorAvatar,
      this.doctorFullname,
      this.doctorEmail,
      this.doctorPhone,
      this.doctorProfessionalTitle,
      this.workPlaceId,
      this.workPlaceName,
      this.workPlaceAddress,
      this.workPlaceLatitude,
      this.workPlaceLongitude,
      this.reviewRating});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patientId = json['patient_id'];
    dateAppointment = json['date_appointment'];
    rescheduleDate = json['reschedule_date'];
    addByDoctor = json['add_by_doctor'];
    reasonForRefusal = json['reason_for_refusal'];
    acceptedMessage = json['accepted_message'];
    motif = json['motif'];
    status = json['status'];
    payed = json['payed'];
    amount = json['amount'];
    discount = json['discount'];
    doctorId = json['doctor_id'];
    doctorAvatar = json['doctor_avatar'];
    doctorFullname = json['doctor_fullname'];
    doctorEmail = json['doctor_email'];
    doctorPhone = json['doctor_phone'];
    doctorProfessionalTitle = json['doctor_professional_title'];
    workPlaceId = json['work_place_id'];
    workPlaceName = json['work_place_name'];
    workPlaceAddress = json['work_place_address'];
    workPlaceLatitude = json['work_place_latitude'];
    workPlaceLongitude = json['work_place_longitude'];
    reviewRating = json['review-rating'] != null
        ? ReviewRating.fromJson(json['review-rating'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patient_id'] = patientId;
    data['date_appointment'] = dateAppointment;
    data['reschedule_date'] = rescheduleDate;
    data['add_by_doctor'] = addByDoctor;
    data['reason_for_refusal'] = reasonForRefusal;
    data['accepted_message'] = acceptedMessage;
    data['motif'] = motif;
    data['status'] = status;
    data['payed'] = payed;
    data['amount'] = amount;
    data['discount'] = discount;
    data['doctor_id'] = doctorId;
    data['doctor_avatar'] = doctorAvatar;
    data['doctor_fullname'] = doctorFullname;
    data['doctor_email'] = doctorEmail;
    data['doctor_phone'] = doctorPhone;
    data['doctor_professional_title'] = doctorProfessionalTitle;
    data['work_place_id'] = workPlaceId;
    data['work_place_name'] = workPlaceName;
    data['work_place_address'] = workPlaceAddress;
    data['work_place_latitude'] = workPlaceLatitude;
    data['work_place_longitude'] = workPlaceLongitude;
    if (reviewRating != null) {
      data['review-rating'] = reviewRating!.toJson();
    }
    return data;
  }
}

class ReviewRating {
  int? id;
  int? star;
  String? comment;
  String? createdAt;
  String? updatedAt;

  ReviewRating(
      {this.id, this.star, this.comment, this.createdAt, this.updatedAt});

  ReviewRating.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    star = json['star'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['star'] = star;
    data['comment'] = comment;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
