class User {
  int? id;
  int? patienId;
  String? name;
  String? phone;
  String? email;
  String? firstName;
  String? sex;
  String? role;
  String? status;
  String? defaultLang;
  String? avatar;
  String? fullname;
  String? idCnss;
  String? addresse;
  String? birthday;
  int? cityId;
  String? cityName;
  String? oneSignalId;
  String? phoneVerifiedAt;
  String? emailVerifiedAt;
  String? createdAt;
  String? updatedAt;

  User(
      {this.id,
      this.patienId,
      this.name,
      this.phone,
      this.email,
      this.firstName,
      this.sex,
      this.role,
      this.status,
      this.defaultLang,
      this.avatar,
      this.fullname,
      this.idCnss,
      this.addresse,
      this.birthday,
      this.cityId,
      this.cityName,
      this.oneSignalId,
      this.phoneVerifiedAt,
      this.emailVerifiedAt,
      this.createdAt,
      this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    patienId = json['patien_id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    firstName = json['firstName'];
    sex = json['sex'];
    role = json['role'];
    status = json['status'];
    defaultLang = json['default_lang'];
    avatar = json['avatar'];
    fullname = json['fullname'];
    idCnss = json['id_cnss'];
    addresse = json['addresse'];
    birthday = json['birthday'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    oneSignalId = json['one_signal_id'];
    phoneVerifiedAt = json['phone_verified_at'];
    emailVerifiedAt = json['email_verified_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['patien_id'] = patienId;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['firstName'] = firstName;
    data['sex'] = sex;
    data['role'] = role;
    data['status'] = status;
    data['default_lang'] = defaultLang;
    data['avatar'] = avatar;
    data['fullname'] = fullname;
    data['id_cnss'] = idCnss;
    data['addresse'] = addresse;
    data['birthday'] = birthday;
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    data['one_signal_id'] = oneSignalId;
    data['phone_verified_at'] = phoneVerifiedAt;
    data['email_verified_at'] = emailVerifiedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
