import 'package:flutter/material.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/base/myScaffold.dart';
import 'package:hale_mate/utlis/validator.dart';
import 'package:hale_mate/views/Authenticate/widgets/AuthStyles.dart';
import 'package:provider/provider.dart';

class ChangePasswordForm extends StatefulWidget {

  ChangePasswordForm({Key key}) : super(key: key);

  static const String id = 'ChangePassword';

  @override
  ChangePasswordFormState createState() => ChangePasswordFormState();
}

class ChangePasswordFormState extends State<ChangePasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  String oldPassword;
  String newPassword;
  String message = '';


  Future<void> changeMyPassword() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      bool success =
      await Provider.of<AuthProvider>(context).changePassword(oldPassword, newPassword);
      if (success) {
        Navigator.pushNamed(context, MyScaffold.id);
      } else {
        setState(() {
          message = 'Invalid old Password! Please try again!';
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
                      heightFactor: 2.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Image(image: AssetImage('assets/logo.jpg')),
                          Text(
                            'Change Your password',
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
                              obscureText: true,
                              decoration: AuthStyles.input.copyWith(
                                hintText: 'Enter old Password',

                              ),
                              validator: (value) {
                                oldPassword = value.trim();
                                return Validate.requiredField(value, "Enter the correct password");
                              }),
                          SizedBox(height: 15.0),
                          TextFormField(
                              obscureText: true,
                              decoration: AuthStyles.input.copyWith(
                                hintText: 'Enter New Password',
                              ),
                              validator: (value) {
                                newPassword = value.trim();
                                return Validate.requiredField(value, "New password is required");
                              }),
                          SizedBox(height: 25.0),
                          StyledButton(
                            'Change password',
                            onPressed: () {
                              changeMyPassword();
                            },
                          ),
                        ],
                      ),
                    )
                )
            )
        )
    );
  }
}


