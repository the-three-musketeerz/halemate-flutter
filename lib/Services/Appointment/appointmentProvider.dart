import 'package:flutter/material.dart';

import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/utlis/exceptions.dart';
import 'package:hale_mate/models/appointment/Appointment.dart';
import 'package:hale_mate/Services/Appointment/appointmentApiService.dart';

class AppointmentProvider with ChangeNotifier{

  bool _initialized = false;

  AuthProvider authProvider;

  List<Appointment> _appointments = List<Appointment>();

  AppointmentApiService appointmentApiService;

  bool get initialized => _initialized;
  List<Appointment> get appointments => _appointments;

  AppointmentProvider(AuthProvider authProvider){
    this.appointmentApiService = AppointmentApiService(authProvider);
    this.authProvider = authProvider;

    init();
  }

  void init() async{
    try{
      List<Appointment> appointmentsResponse = await appointmentApiService.getAppointments();

      _initialized = true;
      _appointments = appointmentsResponse;

      notifyListeners();
    }
    on AuthException {
      // API returned a AuthException, so user is logged out.
      await authProvider.logOut(true);
    }
    catch(Exception){
      print(Exception);
    }
  }
}