import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/base/constants.dart';
import 'package:hale_mate/models/appointment/Appointment.dart';
import 'package:hale_mate/models/appointment/Doctor.dart';
import 'package:hale_mate/models/appointment/Hospital.dart';
import 'package:http/http.dart' as http;

class AppointmentApiService{

  AuthProvider authProvider;
  String token;

  AppointmentApiService(AuthProvider authProvider) {
    this.authProvider = authProvider;
    this.token = authProvider.token;
  }

  final String api = appointmentAPI;

  Future<List<Appointment>> getAppointments() async{
    String token =  await authProvider.getToken();
    final response = await http.get(
      api,
      headers:{
        HttpHeaders.authorizationHeader: 'token $token'
      },
    );
    print('token $token');
    print(response.body);
    List<Appointment> appointments = appointmentFromJson(response.body);

    return appointments;
  }

  Future<List<Hospital>> getHospitals() async{
    final response = await http.get(
      hospitalAPI,
      headers:{
        HttpHeaders.authorizationHeader: 'token $token'
      },
    );
    print('here');
    List<Hospital> hospitals = hospitalFromJson(response.body);

    return hospitals;
  }

  Future<List<Doctor>> getDoctors(int id) async{
    final url = '$hospitalAPI$id/';
    final response = await http.get(
      url,
      headers:{
        HttpHeaders.authorizationHeader: 'token $token'
      },
    );
    Map<String, dynamic> apiResponse = json.decode(response.body);
    List<dynamic> data = apiResponse['doctors'];

    List<Doctor> doctors = doctorFromJson(json.encode(data));
    return doctors;
  }

  createAppointment(String patientName, int hospital, int doctor, String reason) async{
    Map<String, dynamic> body = {
      'patient_name':patientName,
      'hospital':hospital.toString(),
      'doctor':doctor.toString(),
      'reason':reason
    };

    final response = await http.post(
      api,
      headers: {
        HttpHeaders.authorizationHeader: 'token $token'
      },
      body: body
    );
    print(response.statusCode);
  }

}