class User {
  int userId;
  String email;
  String name;
  String phoneNumber;
  // String token;
  String medicalRecord;
  List<TrustedContacts> trustedContacts;

  User(
      {this.userId,
      this.email,
      this.name,
      this.phoneNumber,
      // this.token,
      this.medicalRecord,
      this.trustedContacts});

  //for decoding data in json format from the server
  factory User.fromJson(Map<String, dynamic> json) => new User(
      userId: json['id'],
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      medicalRecord: json['medical_history']);
}

class TrustedContacts {
  String contactName;
  String contactNumber;

  TrustedContacts({this.contactName, this.contactNumber});

  //encoding data into a json object to be sent to the server
  Map<String, dynamic> toJson() =>
      {"trusted_name": contactName, "trusted_phone": contactNumber, };
}

class PassedData {
  final String email;
  final String phone;

  PassedData(this.email, this.phone);
}
