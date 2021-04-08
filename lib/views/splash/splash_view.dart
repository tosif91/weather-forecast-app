import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/styles.dart';
import 'package:weather_app/views/splash/splash_model.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final SplashModel _model = SplashModel();

  @override
  void initState() {
    super.initState();
    _model.initApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: background,
        child: Center(
            child: Text(
          'Weather App',
          style: heading,
        )),
      ),
    );
  }
}
