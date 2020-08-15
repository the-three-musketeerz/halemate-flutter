import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:hale_mate/models/appointment/Appointment.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/Services/Appointment/appointmentProvider.dart';

class AppointmentWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
      builder: (context) => AppointmentProvider(authProvider),
      child: Appointments(),
    );
  }
}

class Appointments extends StatefulWidget{
  static const String id = 'Appointment';
  @override
  AppointmentsState createState() => AppointmentsState();
}

class AppointmentsState extends State<Appointments>{
  bool loading = false;
  String activeTab = 'open';

  @override
  Widget build(BuildContext context) {

    final appointments = Provider.of<AppointmentProvider>(context).appointments;

    return appointmentList(context, appointments);
  }
}


Widget appointmentList(BuildContext context, List<Appointment> appointments){
  return ListView.separated(
      itemBuilder: (BuildContext context, int index){
        final appointment = appointments[index];
        return ListTile(
          key: Key((appointment.id).toString()),
          title: Text(appointment.patientName),
        );
      },
      separatorBuilder: (context, index) => Divider(
        color: Colors.black38,
      ),
      itemCount: appointments.length
  );
}