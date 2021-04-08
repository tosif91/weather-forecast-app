import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/views/weather%20info/weather_info_model.dart';

class ErrorInfoWidget extends ViewModelWidget<WeatherInfoModel> {
  final int index;
  ErrorInfoWidget({@required this.index});
  @override
  Widget build(BuildContext context, WeatherInfoModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Something went wrong!',
          style: TextStyle(fontSize: 20),
        ),
        OutlinedButton(
            onPressed: () => model.retry(index),
            child: Text(
              'Retry',
              style: TextStyle(color: orange),
            ))
      ],
    );
  }
}
