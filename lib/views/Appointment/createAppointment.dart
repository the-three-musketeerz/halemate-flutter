import 'package:after_init/after_init.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hale_mate/Services/Appointment/appointmentProvider.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/constants.dart';
import 'package:hale_mate/myScaffold.dart';
import 'package:hale_mate/utlis/validator.dart';
import 'package:hale_mate/views/Authenticate/widgets/AuthStyles.dart';
import 'package:provider/provider.dart';


class CreateAppointmentWidget extends StatelessWidget{
  static const String id = 'CreateAppointment';
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
      create: (context) => AppointmentProvider(authProvider),
      child: CreateAppointment(),
    );
  }
}

class CreateAppointment extends StatefulWidget{
  @override
  _CreateAppointmentState createState() => _CreateAppointmentState();
}

class _CreateAppointmentState extends State<CreateAppointment> with AfterInitMixin<CreateAppointment>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String patientName;
  int doctor;
  int hospital;
  String reason = '';

  Future<void> submit() async{
    final form = _formKey.currentState;
    if(form.validate()){
      await Provider.of<AppointmentProvider>(context).createAppointment(patientName, hospital, doctor, reason);
      Navigator.pushNamed(context, MyScaffold.id);
    }
  }

  @override
  void didInitState() {
    Provider.of<AppointmentProvider>(context).getHospitals();
  }

  @override
  Widget build(BuildContext context) {
    final hospitals = Provider.of<AppointmentProvider>(context).hospitals;
    final doctors = Provider.of<AppointmentProvider>(context).doctors;
    List<Map<String, dynamic>> hospitalList = hospitals.where((element) => true).map((e) => {'value':e.id, 'text':e.name}).toList();

    return Scaffold(
        appBar: AppBar(
          title: Text("Create Appointment"),
          backgroundColor: colorDark,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.pushNamed(context, MyScaffold.id),
          ),),
      body: Container(
        margin: EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              //mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
                Text(
                  'New Appointment',
                  textAlign: TextAlign.center,
                  style: AuthStyles.h1,
                ),
                SizedBox(height: 30.0),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Patient Name'),
                  onChanged: (value){
                    patientName = value.trim();
                  },
                  validator: (value){
                    patientName = value.trim();
                    return Validate.requiredField(value, 'Patient name is required');
                  },
                ),
                SizedBox(height: 15.0),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Reason'),
                  onChanged: (value){
                    reason = value.trim();
                  },
                  validator: (value){
                    reason = value.trim();
                    return null;
                  },
                ),
                SizedBox(height: 15.0),
                Theme(
                  data: Theme.of(context).copyWith(brightness: Brightness.dark),
                  child: DropDownFormField(
                    titleText: 'Hospital',
                    hintText: 'Select hospital',
                    value: hospital,
                    required: true,
                    errorText: 'Please select a hospital',
                    onSaved: (value){
                      Provider.of<AppointmentProvider>(context).getDoctors(value);
                      hospital = value;
                    },
                    onChanged: (value){
                      Provider.of<AppointmentProvider>(context).getDoctors(value);
                      hospital = value;
                    },
                    dataSource: hospitalList,
                    textField: 'text',
                    valueField: 'value',
                  ),
                ),
                SizedBox(height: 15.0),
                Theme(
                  data: Theme.of(context).copyWith(brightness: Brightness.dark),
                  child: DropDownFormField(
                    titleText: 'Doctor',
                    hintText: 'Select Doctor',
                    value: doctor,
                    required: true,
                    onSaved: (value){
                      doctor = value;
                    },
                    onChanged: (value){
                      doctor = value;
                      print(value);
                    },
                    dataSource: doctors.where((element) => true).map((e) => {'value':e.id, 'text':e.name+'  ('+e.specialization+')'}).toList(),
                    textField: 'text',
                    valueField: 'value',
                  ),
                ),
                SizedBox(height: 35.0),
                Container(
                  height: 50,
                  child: FlatButton(
                    child: Text('Create Appointment'),
                    color: colorLight,
                    textColor: Colors.white,
                    onPressed: () {
                      submit();
                    },
                  ),
                )
              ]
            )
          ),
        ),
      )
    );
  }
}