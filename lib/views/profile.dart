import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/constants.dart';
import 'package:hale_mate/myScaffold.dart';
import 'package:hale_mate/views/selectContacts.dart';
import 'package:provider/provider.dart';
import 'package:after_init/after_init.dart';
import 'package:hale_mate/models/user/User.dart';
import 'package:hale_mate/views/createContact.dart';

class Profile extends StatefulWidget {
  static const String id = 'Profile';
  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> with AfterInitMixin<Profile> {


  @override
  void didInitState(){
    Provider.of<AuthProvider>(context).getUser();
    Provider.of<AuthProvider>(context).getContacts();
  }
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProfile = authProvider.userProfile;
    final contacts = authProvider.contacts;

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
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
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
                  ),
                  Container(
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
                              //leading: Icon(Icons.local_hospital, color: Colors.red,size: 30,),
                              title: Text('Trusted Contacts', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                            ),
                            Container(
                              child: contactList(context, contacts),
                            )
                            ]
                      ),
                    ),
                  ),
                ],
              )

          ),
      floatingActionButton: FloatingActionButton(
        elevation: 4,
        backgroundColor: colorDark,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, CreateContact.id);
        },
      ),

    );
  }
}

Widget contactList(BuildContext context, List<TrustedContacts> contacts){
  return (contacts != null && contacts.length !=0)?
     ListView.builder(
         shrinkWrap: true,
       itemCount: contacts.length,
         itemBuilder:(BuildContext context, int index){
           final contact = contacts[index];
           return ListTile(
             title: Text(contact.contactName),
             subtitle: Text(contact.contactNumber),
           );
         }
     )
      :Center(
      child: Text('No trusted contacts found'),
  );

}

