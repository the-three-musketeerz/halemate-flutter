import 'package:flutter/material.dart';

class AuthStatusText extends StatelessWidget {
  final String text;
  final String type;

  AuthStatusText(this.text, {this.type, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color color = Colors.red;

    if ('info' == type) {
      color = Colors.green;
    }

    if ('error' == type) {
      color = Colors.red;
    }
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(color: color,
      fontWeight: FontWeight.bold),
    );
  }
}