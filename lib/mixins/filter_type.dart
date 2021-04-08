import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_app/models/current_weather_response.dart';
import 'package:weather_app/models/weather_forecast_response.dart';
import 'package:weather_app/utils/data_type.dart';

mixin FilterType {
  filterFromMap({@required Response response, @required FetchDataType type}) {
    if (response.data != null)
      switch (type) {
        case FetchDataType.CURRENT_WEATHER_INFO:
          return CurrentWeatherResponse.fromJson(response.data);
        case FetchDataType.FORECAST_DATA:
          return WeatherForecastResponse.fromJson(response.data);
        default:
          return response.data;
      }
  }
}
