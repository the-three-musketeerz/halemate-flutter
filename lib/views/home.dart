import 'dart:core';
import 'package:hale_mate/Services/alertService.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  static const String id = 'Home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(),
        floatingActionButton: Container(
            height: 100.0,
            width: 100.0,
            child: FittedBox(
              child: FloatingActionButton(
                  child: Icon(Icons.warning),
                  backgroundColor: Colors.red[500],
                  onPressed: () {
                   Navigator.pushReplacementNamed(context, AlertWidget.id);
                  }),
            )
        )
    );
  }




}



