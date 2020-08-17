import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;


class AlertWidget extends StatefulWidget {

  static const String id = "AlertWidget";

  @override
  _AlertWidgetState createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: Text("Send alert"),
        onPressed: (){
          showAlertDialog(context);
        }
    );
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      if (position != null) {
        print("Location: ${position.latitude},${position.longitude}");
        /*setState(() {
          _currentPosition = position;
        });*/
        postLocation(position.latitude, position.longitude);
      }
    }).catchError((e) {
      print(e);
    });
  }

  Future<http.Response> postLocation(double lat, double long) async {

    Map<String, dynamic> body = {
      'lat': lat,
      'lng': long
    };
    final http.Response response = await http.post(
      'http://40888d127c7a.ngrok.io/halemate/alert/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body
    );

    if (response.statusCode == 201) {
      print("Post request successful");
      return response;
    } else {
      throw Exception('Error!!');
    }

  }

  showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget helpBtn = FlatButton(
      child: Text("I need Help"),
      onPressed:  () {
        _getCurrentLocation();
      },
    );
    Widget reportBtn = FlatButton(
      child: Text("Report a Medical Emergency"),
      onPressed:  () {
        _getCurrentLocation();
      },
    );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        title: Text("Confirm your case to proceed"),
        actions: [
          helpBtn,
          reportBtn,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }


}



