import 'package:flutter/material.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/screens/Authenticate/widgets/AuthStyles.dart';
import 'package:hale_mate/utlis/validator.dart';
import 'package:provider/provider.dart';



class PasswordResetForm extends StatefulWidget {
  const PasswordResetForm({Key key}) : super(key: key);
  static const String id = 'ResetPassword';

  @override
  PasswordResetFormState createState() => PasswordResetFormState();
}

class PasswordResetFormState extends State<PasswordResetForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email;
  String password;
  String message = '';

  Map response = new Map();

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      bool success = await Provider.of<AuthProvider>(context).passwordReset(email);
      if (success) {
        Navigator.pushReplacementNamed( context, '/login' );
      } else {
        setState(() {
          message = 'An error occurred during password reset.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 15.0),
        child: Form(
      key: _formKey,
      child: Center(
        heightFactor: 3,
    child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Text(
            'Request Password Reset',
            textAlign: TextAlign.center,
            style: AuthStyles.h1,
          ),
          SizedBox(height: 20.0),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AuthStyles.error,
          ),
          SizedBox(height: 30.0),
          TextFormField(
              decoration: AuthStyles.input.copyWith(
                hintText: 'Enter Email',
              ),
              validator: (value) {
                email = value.trim();
                return Validate.validateEmail(value);
              }
          ),
          SizedBox(height: 15.0),
          StyledButton(
            'Send Password Reset Email',
            onPressed: submit,
          ),
        ],
      ),
    ))
    )));
  }
}