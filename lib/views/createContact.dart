import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/constants.dart';
import 'package:hale_mate/myScaffold.dart';
import 'package:hale_mate/views/selectContacts.dart';
import 'package:provider/provider.dart';
import 'package:after_init/after_init.dart';
import 'package:hale_mate/models/user/User.dart';
import 'package:hale_mate/views/Authenticate/widgets/AuthStyles.dart';
import 'package:hale_mate/utlis/validator.dart';
import 'package:hale_mate/views/profile.dart';

class CreateContact extends StatefulWidget{
  static const String id = 'CreateContact';
  @override
  CreateContactState createState() => CreateContactState();
}

class CreateContactState extends State<CreateContact>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String name;
  String phone;

  Future<void> submit() async{
    final form = _formKey.currentState;
    if(form.validate()){
      await Provider.of<AuthProvider>(context).createContact(name, phone);
      Navigator.pushNamed(context, Profile.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text("Create Appointment"),
    backgroundColor: colorDark,
    leading: new IconButton(
    icon: new Icon(Icons.arrow_back),
    onPressed: () => Navigator.pushNamed(context, MyScaffold.id),
    ),),
    body: Container(
      margin: EdgeInsets.all(25.0),
      child: Form(
        key: _formKey,
        child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //mainAxisAlignment: MainAxisAlignment.center,
                children:<Widget>[
                  Text(
                    'New Contact',
                    textAlign: TextAlign.center,
                    style: AuthStyles.h1,
                  ),
                  SizedBox(height: 30.0),
                  TextFormField(
                      decoration: AuthStyles.input.copyWith(
                        hintText: 'Name',
                      ),
                      validator: (value) {
                        name = value.trim();
                        return Validate.requiredField(value,'Name is required');
                      }),
                  SizedBox(height: 15.0),
                  TextFormField(
                      decoration: AuthStyles.input.copyWith(
                        hintText: 'Phone no.',
                      ),
                      validator: (value) {
                        phone = value.trim();
                        return Validate.requiredField(value,'Phone number is required');
                      }),
                  SizedBox(height: 15.0),
                  StyledButton(
                    'Add contact',
                    onPressed: submit,
                  ),
                ]
            )
        ),
      ),
      )
    );
  }
}