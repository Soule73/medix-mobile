class Review {
  int? id;
  int? star;
  int? patientId;
  String? patientFullname;
  String? patientAvatar;
  int? doctorId;
  String? doctorFullname;
  String? doctorAvatar;
  String? comment;
  String? createdAt;
  String? updatedAt;

  Review(
      {this.id,
      this.star,
      this.patientId,
      this.patientFullname,
      this.patientAvatar,
      this.doctorId,
      this.doctorFullname,
      this.doctorAvatar,
      this.comment,
      this.createdAt,
      this.updatedAt});

  Review.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    star = json['star'];
    patientId = json['patient_id'];
    patientFullname = json['patient_fullname'];
    patientAvatar = json['patient_avatar'];
    doctorId = json['doctor_id'];
    doctorFullname = json['doctor_fullname'];
    doctorAvatar = json['doctor_avatar'];
    comment = json['comment'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['star'] = star;
    data['patient_id'] = patientId;
    data['patient_fullname'] = patientFullname;
    data['patient_avatar'] = patientAvatar;
    data['doctor_id'] = doctorId;
    data['doctor_fullname'] = doctorFullname;
    data['doctor_avatar'] = doctorAvatar;
    data['comment'] = comment;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
