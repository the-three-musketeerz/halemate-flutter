import 'package:flutter/material.dart';
import 'package:hale_mate/Services/Appointment/appointmentApiService.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/models/appointment/Appointment.dart';
import 'package:hale_mate/models/appointment/Doctor.dart';
import 'package:hale_mate/models/appointment/Hospital.dart';
import 'package:hale_mate/utlis/exceptions.dart';

class AppointmentProvider with ChangeNotifier{

  bool _initialized = false;

  AuthProvider authProvider;

  List<Appointment> _appointments = List<Appointment>();
  List<Hospital> _hospitals = List<Hospital>();
  List<Doctor> _doctors = List<Doctor>();

  AppointmentApiService appointmentApiService;

  bool get initialized => _initialized;
  List<Appointment> get appointments => _appointments;
  List<Hospital> get hospitals => _hospitals;
  List<Doctor> get doctors => _doctors;

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

  Future<void> getHospitals() async{

   try{
      List<Hospital> hospitalList = await appointmentApiService.getHospitals();

      _hospitals = hospitalList;

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

  Future<void> getDoctors(int id) async{
  print('called');
    try{
      List<Doctor> doctorList = await appointmentApiService.getDoctors(id);
      _doctors = doctorList;
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

  Future<void> createAppointment(String patientName, int hospital, int doctor, String reason) async{

    try{
      await appointmentApiService.createAppointment(patientName, hospital, doctor, reason);

      List<Appointment> appointmentsResponse = await appointmentApiService.getAppointments();

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