import 'package:flutter/material.dart';
import 'package:hale_mate/Services/Alert/alertService.dart';
import 'package:hale_mate/views//Authenticate/login.dart';
import 'package:hale_mate/views/Authenticate/otpVerify.dart';
import 'package:hale_mate/views/Authenticate/passwordReset.dart';
import 'package:hale_mate/views/Authenticate/signup.dart';
import 'package:hale_mate/views/help.dart';
import 'package:hale_mate/views/home.dart';


class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case HomeScreen.id:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case RegisterForm.id:
        return MaterialPageRoute(builder: (_) => RegisterForm());
      case LogInForm.id:
        return MaterialPageRoute(builder: (_) => LogInForm());
      case ForgotPasswordForm.id:
        return MaterialPageRoute(builder: (_) => ForgotPasswordForm());
      case AlertWidget.id:
        return MaterialPageRoute(builder: (_) => AlertWidget());
      case HelpListView.id:
        return MaterialPageRoute(builder: (_) => HelpListView());
      case OTPVerificationScreen.id:
        return MaterialPageRoute(builder: (_) => OTPVerificationScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}