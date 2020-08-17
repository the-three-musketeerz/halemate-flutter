import 'dart:convert';

List<Hospital> hospitalFromJson(String str) => new List<Hospital>.from(
    json.decode(str).map((x) => Hospital.fromJson(x)));

class Hospital{
  int id;
  String name;
  String email;
  String phoneNumber;

  Hospital(
    {
      this.id,
      this.name,
      this.email,
      this.phoneNumber
    });

  factory Hospital.fromJson(Map<String, dynamic> json) => new Hospital(
    id:json['id'],
    name: json['name'],
    email: json['email'],
    phoneNumber: json['phoneNumber'],
  );

}
