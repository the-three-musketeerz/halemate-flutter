import 'package:flutter/material.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/utlis/validator.dart';
import 'package:hale_mate/views/Authenticate/login.dart';
import 'package:hale_mate/views/Authenticate/widgets/AuthStyles.dart';
import 'package:provider/provider.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({Key key}) : super(key: key);
  static const String id = 'SignUp';

  @override
  RegisterFormState createState() => RegisterFormState();
}

class RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String name;
  String email;
  String password;
  String passwordConfirm;
  String phone;
  String message = '';

  Map response = new Map();

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      response = await Provider.of<AuthProvider>(context)
          .register(name, email, password, passwordConfirm, phone);
      if (response['success']) {
        Navigator.pushNamed(context, LogInForm.id);
      } else {
        setState(() {
          message = response['message'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        child: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
                margin: EdgeInsets.symmetric(horizontal: 15.0, vertical: 50.0),
                child: Card(
                    semanticContainer: true,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Register Account',
                                textAlign: TextAlign.center,
                                style: AuthStyles.h1,
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                message,
                                textAlign: TextAlign.center,
                                style: AuthStyles.error,
                              ),
                              SizedBox(height: 30.0),
                              TextFormField(
                                  decoration: AuthStyles.input.copyWith(
                                    hintText: 'Name',
                                  ),
                                  validator: (value) {
                                    name = value.trim();
                                    return Validate.requiredField(
                                        value, 'Name is required.');
                                  }),
                              SizedBox(height: 15.0),
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
                                    AuthStyles.p
                                        .copyWith(color: Colors.blue[500]);
                                    password = value.trim();
                                    return Validate.requiredField(
                                        value, 'Password is required.');
                                  }),
                              SizedBox(height: 15.0),
                              TextFormField(
                                  obscureText: true,
                                  decoration: AuthStyles.input.copyWith(
                                    hintText: 'Confirm Password ',
                                  ),
                                  validator: (value) {
                                    passwordConfirm = value.trim();

                                    return Validate.passwordMatch(
                                        value, password);
                                  }
                                  ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                  obscureText: true,
                                  decoration: AuthStyles.input.copyWith(
                                    hintText:
                                        'Enter Phone Number Eg. +910000000000',
                                  ),
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  onChanged: (value) {
                                    this.phone = value;
                                  },
                                  validator: (value) {
                                    phone = value.trim();
                                    return Validate.requiredField(
                                        value, 'Phone Number is required.');
                                  }),

                              SizedBox(height: 20.0),
                              RaisedButton(
                                child: Text('Register'),
                                onPressed: submit,
                              ),
                            ],
                          ),
                        ))))));
  }
}
