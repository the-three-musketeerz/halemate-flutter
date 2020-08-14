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
  Position _currentPosition;

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      if (position != null) {
        print("Location: ${position.latitude},${position.longitude}");
        setState(() {
          _currentPosition = position;
          postLocation(_currentPosition.latitude, _currentPosition.longitude);
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  Future<http.Response> postLocation(dynamic lat, dynamic long) async {
    final http.Response response = await http.post(
      'http://65fe8c36a7f4.ngrok.io/halemate/alert',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'latitude': lat,
        'longitude': long,
      }),
    );

    if (response.statusCode == 201) {
      print("Post request successful");
      return response;
    } else {
      throw Exception('Error!!');
    }

  }

  void showAlertDialog(BuildContext context) {

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



