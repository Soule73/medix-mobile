class WorkPlaceLocation {
  int? id;
  String? name;
  String? address;
  double? latitude;
  double? longitude;
  int? doctorId;
  int? cityId;
  String? createdAt;
  String? updatedAt;
  double? distance;
  String? doctorAvatar;
  String? doctorFullname;
  String? doctorEmail;
  String? doctorPhone;
  String? doctorProfessionalTitle;
  List<String>? specialities;

  WorkPlaceLocation(
      {this.id,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.doctorId,
      this.cityId,
      this.createdAt,
      this.updatedAt,
      this.distance,
      this.doctorAvatar,
      this.doctorFullname,
      this.doctorEmail,
      this.doctorPhone,
      this.doctorProfessionalTitle,
      this.specialities});

  WorkPlaceLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    doctorId = json['doctor_id'];
    cityId = json['city_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    distance = json['distance'];
    doctorAvatar = json['doctor_avatar'];
    doctorFullname = json['doctor_fullname'];
    doctorEmail = json['doctor_email'];
    doctorPhone = json['doctor_phone'];
    doctorProfessionalTitle = json['doctor_professional_title'];
    specialities = json['specialities'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['doctor_id'] = doctorId;
    data['city_id'] = cityId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['distance'] = distance;
    data['doctor_avatar'] = doctorAvatar;
    data['doctor_fullname'] = doctorFullname;
    data['doctor_email'] = doctorEmail;
    data['doctor_phone'] = doctorPhone;
    data['doctor_professional_title'] = doctorProfessionalTitle;
    data['specialities'] = specialities;
    return data;
  }
}
