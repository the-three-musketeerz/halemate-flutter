import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:hale_mate/Services/Appointment/appointmentProvider.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/base/constants.dart';
import 'package:hale_mate/models/appointment/Appointment.dart';
import 'package:hale_mate/views/Appointment/createAppointment.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AppointmentWidget extends StatelessWidget{
  static const String id = 'Appointment';
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
      create: (context) => AppointmentProvider(authProvider),
      child: Appointments(),
    );
  }
}

class Appointments extends StatefulWidget{
  @override
  AppointmentsState createState() => AppointmentsState();
}

class AppointmentsState extends State<Appointments>{
  bool loading = false;

  @override
  Widget build(BuildContext context) {

    final appointments = Provider.of<AppointmentProvider>(context).appointments;

    return Scaffold(
      body: appointmentList(context, appointments),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: colorDark,
        child: Icon(Icons.add),
        onPressed:(){
          Navigator.pushNamed(context, CreateAppointmentWidget.id);
        },
      ),
    );
  }
}


Widget appointmentList(BuildContext context, List<Appointment> appointments){
  DateFormat dateFormat = DateFormat("HH:mm:ss dd-MM-yyyy ");
  return (appointments != null && appointments.length !=0)?
    ListView.builder(
      itemBuilder: (BuildContext context, int index){
        final appointment = appointments[index];
        return Container(
          color: Color(0xFFF6F8FC),
          //height: 200,
          child: Card(
            //semanticContainer: true,
            //clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 3,
            margin: EdgeInsets.all(10),

            child: Padding(
              padding: EdgeInsets.only(top:15.0,bottom: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    //leading: Icon(Icons.local_hospital, color: Colors.red,size: 30,),
                    title: Text(appointment.hospitalName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text(appointment.patientName),
                  ),
                  ListTile(
                    //leading: Icon(Icons.person),
                    title: Text('Doctor: '+appointment.doctorName, style: TextStyle(fontSize: 15),),
                  ),
                  ListTile(
                    title: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Status: ',
                            style: TextStyle(color: Colors.black)
                          ),
                          WidgetSpan(
                            child: (appointment.status == 'A')? Icon(Icons.done, color: Colors.green,):
                            (appointment.status == 'P')? Icon(Icons.error, color: Colors.orangeAccent,):
                            (appointment.status == 'R')? Icon(Icons.error, color: Colors.red,):
                            Icon(Icons.priority_high, color: Colors.orangeAccent,),
                          ),
                          TextSpan(
                            text: (appointment.status =='A')? ' Approved':
                            (appointment.status == 'P')?'  Pending':
                            (appointment.status == 'R')?'  Rejected':
                              'Unknown',
                            style: TextStyle(color: Colors.black)
                          )
                        ]
                      ),
                    ),
                  ),
                  ListTile(
                    //leading: Icon(Icons.person),
                    title: Text('Appointment time: '+((appointment.appointmentTime == '')?'':dateFormat.format(appointment.appointmentTime)), style: TextStyle(fontSize: 15),),
                  ),
                ],
              )
            ),
          ),
//          key: Key((appointment.id).toString()),
//          title: Text(appointment.patientName),
        );
      },
      itemCount: appointments.length
  )
  : Center(
    child: Column(
      children: <Widget>[
        SizedBox(height: 50.0),
        Text(
          'Press  +  to make new a new appointment',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 24,
              color: Colors.grey,
              fontWeight: FontWeight.bold
          ),
        ),
        SizedBox(height: 50.0),
        Image.asset(
            "assets/appointment.jpg",

          fit: BoxFit.fitWidth,
        )
      ],

  ));



}