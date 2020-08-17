import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/constants.dart';
import 'package:hale_mate/views/Authenticate/login.dart';
import 'package:hale_mate/views/Authenticate/signup.dart';
import 'package:hale_mate/views/Authenticate/widgets/AuthStatus.dart';
import 'package:hale_mate/views/Authenticate/widgets/AuthStyles.dart';
import 'package:provider/provider.dart';

class OTPVerificationScreen extends StatefulWidget {
  static const String id = 'OTPVerify';
  final String emailValue;

  OTPVerificationScreen({Key key, this.emailValue}) : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  int attemptsLeft = 3;

  String method;
  String message = '';
  String OTP;

  bool success;

  Future<void> getMyOTP() async {
    success =
        await Provider.of<AuthProvider>(context).sendOTP(method, widget.emailValue);
    OTPDialog(context);
    print(method);
  }

  Future<void> refreshMyOTP() async {
    success =
    await Provider.of<AuthProvider>(context).refreshOTP(method, widget.emailValue);
    OTPDialog(context);
    print(method);
  }

  Future<void> verifyMyOTP() async {
    bool success = await Provider.of<AuthProvider>(context).verifyOTP(OTP, widget.emailValue);

    if (success == true) {
      Navigator.pushNamed(context, LogInForm.id);
    } else {
      if(attemptsLeft >= 1) {
        OTPDialog(context);
      } else {
        Navigator.push(context, MaterialPageRoute(
          builder: (BuildContext context) =>
          RegisterForm(),
        ));
      }
    }
    print(OTP);
  }



  @override
  Widget build(BuildContext context) {

    return Material(
        child: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Center(
          heightFactor: 2.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Email/Phone Number Verification",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  color: colorDark
                ),
              ),
              SizedBox(height: 30.0),
              StyledButton(
                  "Verify via Email",
                  onPressed: () {
                    setState(() {
                      method = "email";
                    });
                    getMyOTP();
                  }),
              SizedBox(height: 30.0),
              Text(
                "OR",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: colorDark,
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 30.0),
              StyledButton(
                "Verify via Phone Number",
                  onPressed: () {
                    setState(() {
                      method = "M";
                    });
                    getMyOTP();
                  })
            ],
          ),
        ),
      ),
    ));
  }
  OTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text(
              'Enter OTP',
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
            child: Column(
                children: [
              Text("Attempts Left : $attemptsLeft "),
              Consumer<AuthProvider>(
                builder: (context, provider, child) =>
                provider.notification ?? AuthStatusText(''),
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(),
                onChanged: (value) {
                  if (value != null) {
                    OTP = value;
                  } else {
                    //show error here
                  }
                },
              ),
            ])),
            actions: <Widget>[
              StyledButton(
                '  Submit OTP  ',
                onPressed: () {
                  attemptsLeft--;
                  verifyMyOTP();

                },
              ),
              FlatButton(
                child: Text('Resend OTP via Email'),
                onPressed: () {
                  setState(() {
                    method = "email";
                    return Consumer<AuthProvider>(
                      builder: (context, provider, child) =>
                      provider.notification ?? AuthStatusText(''),
                    );
                  });
                  refreshMyOTP();
                },
              ),
              FlatButton(
                child: Text('Resend OTP via Phone'),
                onPressed: () {
                  setState(() {
                    method = "M";
                    return Consumer<AuthProvider>(
                        builder: (context, provider, child) =>
                    provider.notification ?? AuthStatusText('')
                    );
                  });
                  refreshMyOTP();
                },
              )
            ],
          );
        });
  }
}
