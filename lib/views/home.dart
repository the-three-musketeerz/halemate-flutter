import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hale_mate/Services/Alert/alertService.dart';
import 'package:hale_mate/myScaffold.dart';
import 'package:hale_mate/constants.dart';

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
                    showDialog(context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) => AlertWidget());
                  }),
            )
        )
    );
  }




}



