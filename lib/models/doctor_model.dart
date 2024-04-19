class Doctor {
  int? id;
  String? fullname;
  String? visitPrice;
  String? bio;
  String? professionalTitle;
  List<String>? specialities;
  String? phone;
  String? email;
  String? sex;
  int? patientsCount;
  int? yearExperience;
  String? ratings;
  String? avatar;

  Doctor(
      {this.id,
      this.fullname,
      this.visitPrice,
      this.bio,
      this.professionalTitle,
      this.specialities,
      this.phone,
      this.email,
      this.sex,
      this.patientsCount,
      this.yearExperience,
      this.ratings,
      this.avatar});

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    visitPrice = json['visit_price'];
    bio = json['bio'];
    professionalTitle = json['professional_title'];
    specialities = json['specialities'].cast<String>();
    phone = json['phone'];
    email = json['email'];
    sex = json['sex'];
    patientsCount = json['patients_count'];
    yearExperience = json['year_experience'];
    ratings = json['ratings'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fullname'] = fullname;
    data['visit_price'] = visitPrice;
    data['bio'] = bio;
    data['professional_title'] = professionalTitle;
    data['specialities'] = specialities;
    data['phone'] = phone;
    data['email'] = email;
    data['sex'] = sex;
    data['patients_count'] = patientsCount;
    data['year_experience'] = yearExperience;
    data['ratings'] = ratings;
    data['avatar'] = avatar;
    return data;
  }
}
