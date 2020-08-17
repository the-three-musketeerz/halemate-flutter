import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/constants.dart';
import 'package:hale_mate/models/alert/Alert.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AlertWidget extends StatefulWidget {
  static const String id = "AlertWidget";

  @override
  _AlertWidgetState createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position currentPosition;
  AuthProvider authProvider;
  List<Alert> hospitalList = List<Alert>();

  Future<void> submit() async {
    bool success = await sendAlertForMe(_getCurrentLocation());
    if(success == true){
      await showDialog(context: context,
          child: AlertDialog(
            title: Text(
              "Alert Sent successfully to your Trusted Contacts and nearby hospitals!",
              style: TextStyle(
                  color: Colors.green
              ),),
            content: Text (
              "Don't worry! We have recieved your request and someone from our team will contact you immediately for help! We are with you! :)",
              style: TextStyle(
                  color: Colors.blue
              ),
            ),
          )
      ).then((val) {
        Navigator.pop(context);
      });
    }
  }

  Future<void> getHospitals() async{
    await reportAlert(_getCurrentLocation()).then((value) {
      setState(() {
        hospitalList.addAll(value);
      });
    });
  }

  Position _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      if (position != null) {
        print("Location: ${position.latitude},${position.longitude}");

        setState(() {
          currentPosition = position;
        });
      }
    }).catchError((e) {
      print(e);
    });
    return currentPosition;
  }

  Future<List<Alert>> reportAlert(Position location) async {


    var body = {
      'lat': location.latitude.toString(),
      'lng': location.longitude.toString()
    };

    String url = reportAlertAPI;
    String token = await Provider.of<AuthProvider>(context).getToken();
    String header = "token $token";
    final http.Response response = await http.post(url,
        headers: {
          'Authorization': header,
        },
        body: body);


    var listJson = jsonDecode(response.body).cast<Map<String, dynamic>>();
    print(listJson);
    var hospitalList = listJson.map<Alert>((json) => Alert.fromJson(json)).toList();
    return hospitalList;



  }

  Future<bool> sendAlertForMe(Position location) async {
    var body = {
      'lat': location.latitude.toString(),
      'lng': location.longitude.toString()
    };

    String url = alertAPI;
    String token = await Provider.of<AuthProvider>(context).getToken();
    String header = "token $token";
    final http.Response response = await http.post(url,
        headers: {
          'Authorization': header,
        },
        body: body);

    if (response.statusCode == 200) {
      return true;
    } else {
      print("token = $token");
      throw Exception('Error!!');
    }
  }


  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Confirm your case to proceed"),
      actions: <Widget>[
        FlatButton(
          child: Text("I need Help"),
          onPressed: () {
            submit();

          },
        ),
        FlatButton(
          child: Text("Report a Medical Emergency"),
          onPressed: () {
            getHospitals();
          },
        )
      ],
    );
  }

  @override
  Widget list(List<Alert> hospital){
    return Material(
        child: Container(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: hospital.length,
                itemBuilder: (context, position) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        '${hospital[position].hospitalName}',

                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("${hospital[position].hospitalAddress}", style: TextStyle(
                          color: Colors.grey
                      ),),
                      trailing: IconButton(
                          icon: Icon(Icons.call, color: Colors.black),
                          onPressed: () {
                            launch("${hospital[position].phoneNumber}");
                          }
                      ),
                    ),
                  );}
            )));









  }
}

class HospitalList extends StatelessWidget {
  final List<Alert> hospital;

  const HospitalList({Key key, this.hospital}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Container(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: hospital.length,
                itemBuilder: (context, position) {
                  return Card(
                    child: ListTile(
                      title: Text(
                        '${hospital[position].hospitalName}',

                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text("${hospital[position].hospitalAddress}", style: TextStyle(
                          color: Colors.grey
                      ),),
                      trailing: IconButton(
                          icon: Icon(Icons.call, color: Colors.black),
                          onPressed: () {
                            launch("${hospital[position].phoneNumber}");
                          }
                      ),
                    ),
                  );}
            )));;
  }
}



