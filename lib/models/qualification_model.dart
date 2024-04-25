class Qualification {
  int? id;
  String? name;
  String? institute;
  String? procurementDate;

  Qualification({this.id, this.name, this.institute, this.procurementDate});

  Qualification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    institute = json['institute'];
    procurementDate = json['procurement_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['institute'] = institute;
    data['procurement_date'] = procurementDate;
    return data;
  }
}
