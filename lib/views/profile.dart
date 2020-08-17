import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hale_mate/utlis/validator.dart';
import 'package:provider/provider.dart';
import 'package:hale_mate/constants.dart';

import 'package:hale_mate/models/user/User.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';

class Profile extends StatefulWidget{
  static const String id = 'Profile';
  @override
  ProfileState createState () => ProfileState();
}

class ProfileState extends State<Profile>{
  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);
    authProvider.getUser();
    final userProfile = authProvider.userProfile;

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10),
        child: Container(
          height: 220,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 3,
            margin: EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text(userProfile.name),
                ),
                ListTile(
                  leading: Icon(Icons.mail),
                  title: Text(userProfile.email),
                ),
                ListTile(
                  leading: Icon(Icons.phone),
                  title: Text(userProfile.phoneNumber),
                ),
              ],
            ),
          ),
        )
        ),
      );
  }
}