import 'package:flutter/material.dart';
import 'package:hale_mate/screens/Authenticate/login.dart';
import 'package:hale_mate/screens/Authenticate/passwordReset.dart';
import 'package:hale_mate/screens/Authenticate/signup.dart';
import 'package:hale_mate/screens/home.dart';


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