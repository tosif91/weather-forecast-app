import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/styles.dart';

class LoginButton extends StatelessWidget {
  LoginButton({this.title, @required this.onpressed});
  final String title;
  final Function onpressed;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: const EdgeInsets.all(16),
      color: orange,
      onPressed: onpressed,
      child: Text(
        title,
        style: headingwhite,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
