class Alert{
  String hospitalName;
  String hospitalAddress;
  String phoneNumber;

  Alert({

    this.hospitalName,
    this.hospitalAddress,
    this.phoneNumber
});

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
    hospitalName: json['hospitalName'],
    hospitalAddress: json['address'],
    phoneNumber: json['phoneNumber'],
    );
  }

}