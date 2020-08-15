import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:hale_mate/models/appointment/Appointment.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/utlis/exceptions.dart';
import 'package:hale_mate/constanst.dart';

class AppointmentApiService{

  AuthProvider authProvider;
  String token;

  AppointmentApiService(AuthProvider authProvider){
    this.authProvider = authProvider;
    this.token = authProvider.token;
  }

  final String api = appointmentAPI;

//  void validateResponseStatus(int status, int validStatus) {
//    if (status == 401) {
//      throw new AuthException( "401", "Unauthorized" );
//    }
//
//    if (status != validStatus) {
//      throw new ApiException( status.toString(), "API Error" );
//    }
//  }

  Future<List<Appointment>> getAppointments() async{
    final response = await http.get(
      api,
      headers:{
        HttpHeaders.authorizationHeader: 'token $token'
      },
    );

    List<Appointment> appointments = appointmentFromJson(response.body);

    return appointments;
  }

}