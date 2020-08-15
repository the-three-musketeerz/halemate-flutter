import 'package:flutter/material.dart';
import 'package:hale_mate/constanst.dart';

class AuthStyles {
  static TextStyle defaultStyle = TextStyle(
      color: Colors.grey[900]
  );

  static TextStyle h1 = defaultStyle.copyWith(
    fontWeight: FontWeight.w700,
    fontSize: 25.0,
    height: 22 / 18,
    color: colorDark
  );

  static TextStyle p = defaultStyle.copyWith(
    fontSize: 16.0,
  );

  static TextStyle error = defaultStyle.copyWith(
    fontWeight: FontWeight.w500,
    fontSize: 14.0,
    color: Colors.red,
  );

  static InputDecoration input = InputDecoration(
    fillColor: Colors.white,
    focusColor: Colors.grey[900],
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: colorLight,
        width: 2.0,
      ),
    ),
    border: OutlineInputBorder(
      gapPadding: 1.0,
      borderSide: BorderSide(
        color: Colors.grey[600],
        width: 1.0,
      ),
    ),
    hintStyle: TextStyle(
      color: Colors.grey[600],
    ),
  );

}


class StyledButton extends StatelessWidget {
  final String text;
  final onPressed;
  final double radius;

  const StyledButton(this.text, {this.onPressed, Key key, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: colorLight,
      splashColor: colorLight,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 18.0),
        child: Text(
          this.text,
          style: AuthStyles.p.copyWith(
            color: Colors.white,
            height: 1,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      onPressed: () {
        this.onPressed();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 4.0),
        side: BorderSide(
          color: colorLight,
          width: 2,
        ),
      ),
    );
  }
}