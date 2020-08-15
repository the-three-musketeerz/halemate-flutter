import 'dart:convert';

List<Appointment> appointmentFromJson(String str) => new List<Appointment>.from(
    json.decode(str).map((x) => Appointment.fromJson(x)));

String appointmentToJson(List<Appointment> data) =>
    json.encode(new List<dynamic>.from(data.map((x) => x.toJson())));

class Appointment {
  int id;
  String patientName;
  int hospitalId;
  String hospitalName;
  String hospitalPhone;
  int doctorId;
  String doctorName;
  String reason;
  String status;
  DateTime appointmentTime;
  DateTime appointmentMadeTime;

  Appointment(
      {
        this.id,
        this.patientName,
        this.hospitalId,
        this.hospitalName,
        this.hospitalPhone,
        this.doctorId,
        this.doctorName,
        this.reason,
        this.status,
        this.appointmentTime,
        this.appointmentMadeTime
      });

  //for decoding data in json format from the server
  factory Appointment.fromJson(Map<String, dynamic> json) => new Appointment(
    id: json['id'],
    patientName: json['patient_name'],
    hospitalId: json['hospital']['id'],
    hospitalName: json['hospital']['name'],
    hospitalPhone: json['hospital']['phoneNumber'],
    doctorId: json['doctor']['id'],
    doctorName: json['doctor']['name'],
    reason: json['reason'],
    status: json['status'],
    appointmentTime: (json['appointment_time'] == '')? DateTime.parse(json['appointment_time']) : null,
    appointmentMadeTime: DateTime.parse(json['appointment_made_time']),
  );

  //encoding data into a json object to be sent to the server
  Map<String, dynamic> toJson() => {
    "patient_name": patientName,
    "hospital": hospitalId,
    "doctor": doctorId,
    "reason": reason,
  };
}
