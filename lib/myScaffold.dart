import 'package:flutter/material.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/constants.dart';
import 'package:hale_mate/views/Appointment/appointment.dart';
import 'package:hale_mate/views/help.dart';
import 'package:hale_mate/views/home.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class MyScaffold extends StatelessWidget {
  static const String id = "scaffold";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("HaleMate"), backgroundColor: colorDark),
        drawer: HomeDrawer(),
        body: DefaultTabController(
            length: 3,
            child: Column(
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(maxHeight: 70.0),
                  child: Material(
                    color: colorLight,
                    child: TabBar(
                      tabs: [
                        Tab(icon: Icon(Icons.home), text: "Home"),
                        Tab(
                            icon: Icon(Icons.local_hospital),
                            text: 'Appointments'),
                        Tab(icon: Icon(Icons.alarm), text: 'Alarm'),
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
                  ],
                ))
              ],
            ))); //Scaffold
  }
}

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(children: <Widget>[
        SizedBox(height: 20.0),
        Text(
        "Welcome to HaleMate!",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: colorLight, fontWeight: FontWeight.bold, fontSize: 25.0),
      ),
        SizedBox(height: 20.0),
         new Image(image: AssetImage('assets/drawerImage.jpg')),
        Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
          child: Column(
          children: <Widget>[
            ListTile(
              dense: true,
              title: Text(
                "Home",
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(Icons.home),
              onTap: () {
                Navigator.pushNamed(context, MyScaffold.id);
              },
            ),
            ListTile(
              dense: true,
              title: Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(Icons.person),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(Icons.exit_to_app),
              onTap: () {
                Provider.of<AuthProvider>(context).logOut(true);
              },
            ),
            ListTile(
              dense: true,
              title: Text(
                "Change Password",
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(Icons.settings),
              onTap: () {
                // Navigator.pushNamed(context, "/settings");
              },
            ),
            ListTile(
              dense: true,
              title: Text(
                "Help",
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(Icons.info),
              onTap: () {
                Navigator.pushNamed(context, HelpList.id);
              },
            ),
          ],
        ),
      ),
    ]));
  }
}

