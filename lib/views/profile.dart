import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/constants.dart';
import 'package:hale_mate/myScaffold.dart';
import 'package:hale_mate/views/selectContacts.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  static const String id = 'Profile';
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {


  @override
  void didInitState(){
    Provider.of<AuthProvider>(context).getUser();
  }
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProfile = authProvider.userProfile;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: colorDark,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, MyScaffold.id),
        ),
      ),
      body: userProfile == null
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Container(
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
              )),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: colorDark,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, Contacts.id);
        },
      ),

    );
  }
}

