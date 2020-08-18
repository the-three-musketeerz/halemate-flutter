import 'package:flutter/material.dart';
import 'package:hale_mate/Services/Alert/alertService.dart';
import 'package:hale_mate/myScaffold.dart';
import 'package:hale_mate/views//Authenticate/login.dart';
import 'package:hale_mate/views/Appointment/appointment.dart';
import 'package:hale_mate/views/Appointment/createAppointment.dart';
import 'package:hale_mate/views/Authenticate/otpVerify.dart';
import 'package:hale_mate/views/Authenticate/passwordReset.dart';
import 'package:hale_mate/views/Authenticate/signup.dart';
import 'package:hale_mate/views/help.dart';
import 'package:hale_mate/views/profile.dart';
import 'package:hale_mate/views/createContact.dart';


class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RegisterForm.id:
        return MaterialPageRoute(builder: (_) => RegisterForm());
      case LogInForm.id:
        return MaterialPageRoute(builder: (_) => LogInForm());
      case ForgotPasswordForm.id:
        return MaterialPageRoute(builder: (_) => ForgotPasswordForm());
      case AlertWidget.id:
        return MaterialPageRoute(builder: (_) => AlertWidget());
      case HelpList.id:
        return MaterialPageRoute(builder: (_) => HelpList());
      case AppointmentWidget.id:
        return MaterialPageRoute(builder: (_) => AppointmentWidget());
      case CreateAppointmentWidget.id:
        return MaterialPageRoute(builder: (_) => CreateAppointmentWidget());
      case OTPVerificationScreen.id:
        return MaterialPageRoute(builder: (_) => OTPVerificationScreen());
      case CreateContact.id:
        return MaterialPageRoute(builder: (_) => CreateContact());
      case MyScaffold.id:
        return MaterialPageRoute(builder: (_) => MyScaffold());
      case HospitalList.id:
        return MaterialPageRoute(builder: (_) => HospitalList());
      case Profile.id:
        return MaterialPageRoute(builder: (_) => Profile());
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
