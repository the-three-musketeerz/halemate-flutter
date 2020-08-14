import 'dart:convert';

List<Appointment> appointmentFromJson(String str) => new List<Appointment>.from(
    json.decode(str).map((x) => Appointment.fromJson(x)));

String appointmentToJson(List<Appointment> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class Appointment {
  String id;
  String userID;
  String name;
  String hospital;
  String doctor;
  String reason;
  int status;
  DateTime time;

  Appointment(
      {this.id,
      this.userID,
      this.name,
      this.hospital,
      this.doctor,
      this.reason,
      this.status,
      this.time
      });

  //for decoding data in json format from the server
  factory Appointment.fromJson(Map<String, dynamic> json) => new Appointment(
        id: json['appointmentId'],
        userID: json['uid'],
        name: json['name'],
        hospital: json['hospital'],
        doctor: json['doctor'],
        reason: json['reason'],
        status: json['status'],
        time: DateTime.parse(json['time']),
      );

  //encoding data into a json object to be sent to the server
  Map<String, dynamic> toJson() => {
        "appointmentId": id,
        "uid": userID,
        "name": name,
        "hospital": hospital,
        "doctor": doctor,
        "reason": reason,
      //  "status": status,
      //  "time": time.toIso8601String(),
      };
}
