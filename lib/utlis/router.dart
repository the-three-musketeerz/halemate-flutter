import 'package:flutter/material.dart';
import 'package:hale_mate/Services/alertService.dart';
import 'package:hale_mate/views//Authenticate/login.dart';
import 'package:hale_mate/views/Authenticate/passwordReset.dart';
import 'package:hale_mate/views/Authenticate/signup.dart';
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
      case PasswordResetForm.id:
        return MaterialPageRoute(builder: (_) => PasswordResetForm());
      case AlertWidget.id:
        return MaterialPageRoute(builder: (_) => AlertWidget());
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