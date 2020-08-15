import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/views/Authenticate/login.dart';
import 'package:hale_mate/views/alarm/alarm.dart';
import 'package:hale_mate/Services/Alarm/globalBloc.dart';
import 'package:hale_mate/views/appointment.dart';
import 'package:hale_mate/views/help.dart';
import 'package:hale_mate/views/home.dart';
import 'package:hale_mate/utlis/router.dart';
import 'package:provider/provider.dart';

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
    const color = const Color(0xff30bfbf);
    //final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
        builder: (context) => AuthProvider(),
      child: MaterialApp(
        onGenerateRoute: Router.generateRoute,
      home: Scaffold(
          appBar: AppBar(
            title: Text('HaleMate'),
            backgroundColor: Color(0xff008c8c),
          ),
          body: DefaultTabController(
              length: 5,
              child: Column(
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(maxHeight: 70.0),
                    child: Material(
                     color: color,
                      child: TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.home), text: "Home"),
                          Tab(icon: Icon(Icons.local_hospital), text: 'appointment'),
                          Tab(icon: Icon(Icons.alarm), text: 'Alarm'),
                          Tab(icon: Icon(Icons.account_circle), text: 'Profile',),
                          Tab(icon: Icon(Icons.info), text: 'Help'),
                        ],
                        indicatorColor: Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                      child: TabBarView(
                        children: [
                          HomeScreen(),
                          AppointmentWidget(),
                          MedReminder(),
                          LogInForm(),
                          HelpListView(),
                        ],  ))
                ],
              )


          ),
        ),
      ));
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

