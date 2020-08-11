import 'package:flutter/material.dart';
import 'package:hale_mate/screens/alarm/alarm.dart';
import 'package:hale_mate/screens/alarm/globalBloc.dart';
import 'package:hale_mate/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(HaleMateApp());
}

class HaleMateApp extends StatefulWidget {

  @override
  _HaleMateAppState createState() => _HaleMateAppState();
}

class _HaleMateAppState extends State<HaleMateApp> {

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                          MedReminder(),
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

class MedReminder extends StatefulWidget {
  @override
  _MedReminderState createState() => _MedReminderState();
}

class _MedReminderState extends State<MedReminder> {

  GlobalBloc globalBloc;

  void initState() {
    globalBloc = GlobalBloc();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Provider<GlobalBloc>.value(
      value: globalBloc,
      child: MaterialApp(
        /*theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.light,
        ),*/
        home: AlarmHomeScreen(),
       debugShowCheckedModeBanner: false,
      ),
    );
  }
}

