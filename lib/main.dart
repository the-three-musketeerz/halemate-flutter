import 'package:flutter/material.dart';
import 'package:hale_mate/screens/appointment.dart';
import 'package:hale_mate/screens/home.dart';

void main() {
  runApp(HaleMateApp());
}

class HaleMateApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('HaleMate'),
            backgroundColor: Colors.deepPurpleAccent,
          ),
          body: DefaultTabController(
              length: 5,
              child: Column(
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(maxHeight: 70.0),
                    child: Material(
                     color: Colors.deepPurpleAccent[400],
                      child: TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.home), text: "Home"),
                          Tab(icon: Icon(Icons.local_hospital), text: 'appointment'),
                          Tab(icon: Icon(Icons.alarm), text: 'Alarm'),
                          Tab(icon: Icon(Icons.account_circle), text: 'Profile',),
                          Tab(icon: Icon(Icons.info), text: 'FAQ'),
                        ],
                        indicatorColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                        children: [
                          HomeScreen(),
                          Icon(Icons.local_hospital),
                          Icon(Icons.alarm),
                          Icon(Icons.account_circle),
                          Icon(Icons.info),
                        ],  ))
                ],
              )


          ),
        ),
      );

  }
}
