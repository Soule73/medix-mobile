class Schedule {
  int? id;
  String? startAt;
  String? endAt;
  int? workPlaceId;
  String? workPlaceName;
  String? workPlaceAddress;
  double? workPlaceLatitude;
  double? workPlaceLongitude;

  Schedule(
      {this.id,
      this.startAt,
      this.endAt,
      this.workPlaceId,
      this.workPlaceName,
      this.workPlaceAddress,
      this.workPlaceLatitude,
      this.workPlaceLongitude});

  Schedule.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startAt = json['start_at'];
    endAt = json['end_at'];
    workPlaceId = json['work_place_id'];
    workPlaceName = json['work_place_name'];
    workPlaceAddress = json['work_place_address'];
    workPlaceLatitude = json['work_place_latitude'];
    workPlaceLongitude = json['work_place_longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['work_place_id'] = workPlaceId;
    data['work_place_name'] = workPlaceName;
    data['work_place_address'] = workPlaceAddress;
    data['work_place_latitude'] = workPlaceLatitude;
    data['work_place_longitude'] = workPlaceLongitude;
    return data;
  }
}

class WeeklySchedule {
  final List<Schedule>? monday;
  final List<Schedule>? tuesday;
  final List<Schedule>? wednesday;
  final List<Schedule>? thursday;
  final List<Schedule>? friday;
  final List<Schedule>? saturday;
  final List<Schedule>? sunday;

  WeeklySchedule({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  factory WeeklySchedule.fromJson(Map<String, dynamic> json) {
    return WeeklySchedule(
      monday: json['monday'] != null
          ? List<Schedule>.from(json['monday'].map((x) => Schedule.fromJson(x)))
          : null,
      tuesday: json['tuesday'] != null
          ? List<Schedule>.from(
              json['tuesday'].map((x) => Schedule.fromJson(x)))
          : null,
      wednesday: json['wednesday'] != null
          ? List<Schedule>.from(
              json['wednesday'].map((x) => Schedule.fromJson(x)))
          : null,
      thursday: json['thursday'] != null
          ? List<Schedule>.from(
              json['thursday'].map((x) => Schedule.fromJson(x)))
          : null,
      friday: json['friday'] != null
          ? List<Schedule>.from(json['friday'].map((x) => Schedule.fromJson(x)))
          : null,
      saturday: json['saturday'] != null
          ? List<Schedule>.from(
              json['saturday'].map((x) => Schedule.fromJson(x)))
          : null,
      sunday: json['sunday'] != null
          ? List<Schedule>.from(json['sunday'].map((x) => Schedule.fromJson(x)))
          : null,
    );
  }
}
