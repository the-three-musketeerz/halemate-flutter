import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hale_mate/Services/Alarm/globalBloc.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/myScaffold.dart';
import 'package:hale_mate/utlis/router.dart';
import 'package:hale_mate/views/Authenticate/login.dart';
import 'package:hale_mate/views/alarm/alarm.dart';
import 'package:hale_mate/views/home.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:hale_mate/views/profile.dart';

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

    //final AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return ChangeNotifierProvider(
        builder: (context) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Router.generateRoute,
      initialRoute: '/',
      routes: {
        '/': (context) => NavigationRouter(),
      },

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
        home: AlarmHomeScreen(),
       debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class NavigationRouter extends StatelessWidget {
  //final authProvider = Provider.of<AuthProvider>();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, user, child) {
        print(user.status);
        switch (user.status) {
          case Status.Unauthenticated:
            return LogInForm();
          case Status.Authenticated:
            return MyScaffold();
          case Status.Uninitialized:
            return LogInForm();
          case Status.Authenticating:
            return LogInForm();
          default:
            return MyScaffold();
        }
      },
    );
  }
}

