import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/constants.dart';
import 'package:hale_mate/myScaffold.dart';
import 'package:hale_mate/utlis/validator.dart';
import 'package:hale_mate/views/Authenticate/passwordReset.dart';
import 'package:hale_mate/views/Authenticate/signup.dart';
import 'package:hale_mate/views/Authenticate/widgets/AuthStatus.dart';
import 'package:hale_mate/views/Authenticate/widgets/AuthStyles.dart';
import 'package:provider/provider.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({Key key}) : super(key: key);
  static const String id = 'Login';

  @override
  LogInFormState createState() => LogInFormState();
}

class LogInFormState extends State<LogInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String email;
  String password;
  String message = '';
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();




  Future<void> submit() async {
    final form = _formKey.currentState;


    if (form.validate()) {
      bool success = await Provider.of<AuthProvider>(context).login(email, password);
      if (success == true) {
       await _firebaseMessaging.getToken().then((fcmToken) => Provider.of<AuthProvider>(context).registerDevice(fcmToken)
        );
       await Navigator.pushNamed(context, MyScaffold.id);
      } else{
        Navigator.pop(context);
      }
    }else{

      setState(() {
        message = "Please give valid login credentials";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(

      child: SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.all(15.0),
                child: Form(
                    key: _formKey,
                    child: Center(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top:50.0, bottom: 20.0),
                            height: 100,
                          width: 100,
                          child: new Image(image: AssetImage('assets/logo.png'))),
                          Text(
                            'Login',
                            textAlign: TextAlign.center,
                            style: AuthStyles.h1,
                          ),
                          SizedBox(height: 10.0),
                          Consumer<AuthProvider>(
                            builder: (context, provider, child) =>
                                provider.notification ?? AuthStatusText(''),
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                              decoration: AuthStyles.input.copyWith(
                                hintText: 'Email',
                              ),
                              validator: (value) {
                                email = value.trim();
                                return Validate.validateEmail(value);
                              }),
                          SizedBox(height: 15.0),
                          TextFormField(
                              obscureText: true,
                              decoration: AuthStyles.input.copyWith(
                                hintText: 'Password',
                              ),
                              validator: (value) {
                                password = value.trim();
                                return Validate.requiredField(
                                    value, 'Password is required.');
                              }),
                          SizedBox(height: 15.0),
                          StyledButton(
                            'Login',
                            onPressed: submit,
                          ),
                          SizedBox(height: 25.0),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: "Don't have an account? ",
                                    style: AuthStyles.p,
                                  ),
                                  TextSpan(
                                    text: 'Register.',
                                    style: AuthStyles.p.copyWith(color: colorDark),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => {
                                            Navigator.pushNamed(
                                                context, RegisterForm.id),
                                          },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Center(
                            child: RichText(
                              text: TextSpan(
                                  text: 'Forgot Your Password?',
                                  style: AuthStyles.p
                                      .copyWith(color: colorDark),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => {
                                          Navigator.pushNamed(
                                              context, ForgotPasswordForm.id),
                                        }),
                            ),
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
