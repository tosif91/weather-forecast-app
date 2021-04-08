import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/utils/routes.dart';
import 'package:weather_app/views/history/history_view.dart';
import 'package:weather_app/views/home/home_view.dart';
import 'package:weather_app/views/location%20permission/location_permission_view.dart';
import 'package:weather_app/views/login/login_view.dart';
import 'package:weather_app/views/login/mobile/mobile_vew.dart';
import 'package:weather_app/views/login/otp/otp_view.dart';
import 'package:weather_app/views/splash/splash_view.dart';
import 'package:weather_app/views/weather%20info/weather_info_view.dart';

class Routers {
  static Route<dynamic> toGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => SplashView());
      case home:
        return MaterialPageRoute(builder: (context) => HomeView());
      case logIn:
        return MaterialPageRoute(builder: (context) => LogInView());
      case weatherInfo:
        return MaterialPageRoute(
            builder: (context) =>
                WeatherInfoView(position: settings.arguments));
      case history:
        return MaterialPageRoute(builder: (context) => HistoryView());
      case mobile:
        return MaterialPageRoute(builder: (context) => MobileView());
      case otp:
        return MaterialPageRoute(builder: (context) => OTPView());
      case locationPermission:
        return MaterialPageRoute(
            builder: (context) => LocationPermissionView());
      default:
        return MaterialPageRoute(
            builder: (context) => Material(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Invalid Route',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ));
    } //switch
  }
}
