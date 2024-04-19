class Notification {
  String? id;
  String? title;
  String? body;
  String? status;
  int? appointmentId;
  String? readAt;
  String? createdAt;

  Notification(
      {this.id,
      this.title,
      this.body,
      this.status,
      this.appointmentId,
      this.readAt,
      this.createdAt});

  Notification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    status = json['status'];
    appointmentId = json['appointment_id'];
    readAt = json['read_at'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['body'] = body;
    data['status'] = status;
    data['appointment_id'] = appointmentId;
    data['read_at'] = readAt;
    data['created_at'] = createdAt;
    return data;
  }
}
