import 'dart:convert';

List<Doctor> doctorFromJson(String str) => new List<Doctor>.from(
    json.decode(str).map((x) => Doctor.fromJson(x)));

class Doctor{
  int id;
  String name;
  String specialization;
  dynamic timeStart;
  dynamic timeEnd;

  Doctor(
  {
    this.id,
    this.name,
    this.specialization,
    this.timeStart,
    this.timeEnd,
  }
      );

  //for decoding data in json format from the server
  factory Doctor.fromJson(Map<String, dynamic> json) => new Doctor(
    id: json['id'],
    name: json['name'],
    specialization: json['specialization'],
    timeStart: (json['timeStart'] != null)? DateTime.parse(json['timeStart']): '',
    timeEnd: (json['timeEnd'] != null)? DateTime.parse(json['timeEnd']): '',
  );
}