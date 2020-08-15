import 'package:geolocator/geolocator.dart';

class Alert{
  Position location;
  String hospitalName;
  String hospitalAddress;
  String phoneNumber;

  Alert({
    this.location,
    this.hospitalName,
    this.hospitalAddress,
    this.phoneNumber
});

  factory Alert.fromJson(Map<String, dynamic> json) => new Alert(
    hospitalName: json['hospitalName'],
    hospitalAddress: json['hospitalAddress'],
    phoneNumber: json['phoneNumber'],
  );

  Map<String, dynamic> toJson() => {
    "lat": location.latitude,
    "lng": location.longitude,
  };
}