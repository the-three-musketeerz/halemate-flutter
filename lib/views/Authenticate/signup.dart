import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hale_mate/Services/Authenticate/authProvider.dart';
import 'package:hale_mate/utlis/validator.dart';
import 'package:hale_mate/views/Authenticate/otpVerify.dart';
import 'package:hale_mate/views/Authenticate/widgets/AuthStatus.dart';
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
  bool _obscureText = true;

  String name;
  String email;
  String password;
  String passwordConfirm;
  String phone;
  String message = '';
  TextEditingController _controller = new TextEditingController();

  Map response = new Map();

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> submit() async {
    final form = _formKey.currentState;
    if (form.validate()) {
      response = await Provider.of<AuthProvider>(context)
          .register(name, email, password, passwordConfirm, phone);
      if (response['success']) {
        var route = new MaterialPageRoute(
          builder: (BuildContext context) =>
          new OTPVerificationScreen(emailValue: _controller.text),
        );
        Navigator.of(context).push(route);
        print(email);
        print(phone);
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
                margin: EdgeInsets.all(15.0),
                        child: Form(
                          key: _formKey,
                          child: Center(
                            heightFactor: 1.5,
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
                              Consumer<AuthProvider>(
                                builder: (context, provider, child) =>
                                provider.notification ?? AuthStatusText(''),
                              ),
                              SizedBox(height: 10.0),
                              Text(
                                message,
                                textAlign: TextAlign.center,
                                style: AuthStyles.error,
                              ),
                              SizedBox(height: 10.0),
                              TextFormField(
                                  decoration: AuthStyles.input.copyWith(
                                    hintText: 'Name',
                                    icon: Icon(Icons.account_circle),
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
                                    icon: Icon(Icons.email),
                                  ),
                                  controller: _controller,
                                  validator: (value) {
                                    email = value.trim();
                                    return Validate.validateEmail(value);
                                  }),
                              SizedBox(height: 15.0),
                              TextFormField(
                                  obscureText: _obscureText,
                                  decoration: AuthStyles.input.copyWith(
                                     /* border: OutlineInputBorder(
                                        gapPadding: 1.0,
                                        borderSide: BorderSide(
                                          color: Colors.grey[600],
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: colorLight,
                                          width: 2.0,
                                        ),
                                      ),*/
                                    hintText: 'Password',
                                    icon: Container(
                                      width: 15.0,
                                        margin: EdgeInsets.only(right: 10.0),
                                        child: IconButton(
                                        onPressed: (){
                                          _toggle();
                                        },
                                        icon: Icon(Icons.remove_red_eye))
                                  )),
                                  validator: (value) {
                                    AuthStyles.p
                                        .copyWith(color: Colors.blue[500]);
                                    password = value.trim();
                                    return Validate.requiredField(
                                        value, 'Password is required.');
                                  }),
                              SizedBox(height: 15.0),
                              TextFormField(
                                  obscureText:  _obscureText,
                                  decoration: AuthStyles.input.copyWith(
                                    hintText: 'Confirm Password ',
                                      icon: Container(
                                          width: 15.0,
                                          margin: EdgeInsets.only(right: 10.0),
                                          child: IconButton(
                                          onPressed: ()
                                          {
                                            _toggle();
                                          },
                                          icon: Icon(Icons.remove_red_eye))
                                  )),

                                  validator: (value) {
                                    passwordConfirm = value.trim();

                                    return Validate.passwordMatch(
                                        value, password);
                                  }
                                  ),
                              SizedBox(height: 15.0),
                              TextFormField(
                                  decoration: AuthStyles.input.copyWith(
                                    hintText:
                                        'Enter Phone Number Eg. +910000000000',
                                    icon: Icon(Icons.phone),
                                  ),

                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  onChanged: (value) {
                                    this.phone = value;
                                  },
                                  validator: (value) {
                                    phone = value.trim();
                                    return Validate.validatePhone(
                                        value);
                                  }),

                              SizedBox(height: 20.0),
                              StyledButton(
                                'Register',
                                onPressed: (){
                                  _toggle();
                                  submit();
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
