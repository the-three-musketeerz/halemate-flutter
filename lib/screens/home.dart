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
                    showAlertDialog(context);
                  }),
            )
        )
    );
  }
}

void showAlertDialog(BuildContext context) {
  // set up the buttons
  Widget helpBtn = FlatButton(
    child: Text("I need Help"),
    onPressed:  () {
      Navigator.pop(context);
    },
  );
  Widget reportBtn = FlatButton(
    child: Text("Report a Medical Emergency"),
    onPressed:  () {
      Navigator.pop(context);
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


