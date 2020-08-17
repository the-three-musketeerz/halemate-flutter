import 'package:flutter/material.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/utlis/validator.dart';
import 'package:hale_mate/views/Authenticate/widgets/AuthStatus.dart';
import 'package:hale_mate/views/Authenticate/widgets/AuthStyles.dart';
import 'package:provider/provider.dart';

import 'login.dart';

class ForgotPasswordForm extends StatefulWidget {

  ForgotPasswordForm({Key key}) : super(key: key);

  static const String id = 'ForgotPassword';

  @override
  ForgotPasswordFormState createState() => ForgotPasswordFormState();
}



class ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _textController = new TextEditingController();
  String OTP;
  String message = "";
  String email;



  Future<void> forgotMyPassword() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      bool success =
          await Provider.of<AuthProvider>(context).forgotPassword(email);
      if (success) {
        var route = new MaterialPageRoute(
          builder: (BuildContext context) =>
          new ResetPasswordView(emailValue: _textController.text),
        );
        Navigator.of(context).push(route);
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
                          Consumer<AuthProvider>(
                            builder: (context, provider, child) =>
                            provider.notification ?? AuthStatusText(''),
                          ),
                          SizedBox(height: 30.0),
                          TextFormField(
                            controller: _textController,
                              decoration: AuthStyles.input.copyWith(
                                hintText: 'Enter Email',
                              ),
                              validator: (value) {
                                email = value.trim();
                                return Validate.validateEmail(value);
                              }),
                          SizedBox(height: 15.0),
                          StyledButton(
                            'Send Password Reset Email',
                            onPressed: () {
                              forgotMyPassword();
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

class ResetPasswordView extends StatefulWidget {
  final String emailValue;

  ResetPasswordView({Key key, this.emailValue}) : super(key: key);

  @override
  _ResetPasswordViewState createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  String password;
  String confirmPassword;
  String message = '';
  String OTP;



  Future<void> resetMyPassword() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      bool success =
      await Provider.of<AuthProvider>(context).resetPassword(widget.emailValue, OTP, password);
      if (success) {
        Navigator.pushNamed(context, LogInForm.id);
      } else {
        setState(() {
          message = 'Invalid OTP! Please enter correct OTP';
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
                          new Image(image: AssetImage('assets/logo.png')),
                          Text(
                            'Reset Your password',
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
                            keyboardType: TextInputType.numberWithOptions(),
                              decoration: AuthStyles.input.copyWith(
                                hintText: 'Enter OTP',

                              ),
                              validator: (value) {
                                OTP = value.trim();
                                return Validate.requiredField(value, "Enter the correct OTP");
                              }),
                          SizedBox(height: 15.0),
                          TextFormField(
                              decoration: AuthStyles.input.copyWith(
                                hintText: 'Enter New Password',
                              ),
                              validator: (value) {
                                password = value.trim();
                                return Validate.requiredField(value, "New password is required");
                              }),
                          SizedBox(height: 15.0),
                          TextFormField(
                              decoration: AuthStyles.input.copyWith(
                                hintText: 'Confirm Password',
                              ),
                              validator: (value) {
                                confirmPassword = value.trim();
                                return Validate.passwordMatch(value, password);
                              }),
                          SizedBox(height: 20.0),
                          StyledButton(
                            'Reset password',
                            onPressed: () {
                              resetMyPassword();
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


