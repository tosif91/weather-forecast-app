import 'package:dio/dio.dart';
import 'package:weather_app/locator.dart';
import 'package:weather_app/models/base_data.dart';
import 'package:weather_app/models/current_weather_response.dart';
import 'package:weather_app/services/api_service.dart';
import 'package:weather_app/utils/data_type.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class DatabaseService {
  final ApiService _apiService = locator<ApiService>();

  Future<BaseData<dynamic>> currentWeatherInfo(LatLng position) async {
    Response response = await _apiService.handleGet(
        type: FetchDataType.CURRENT_WEATHER_INFO,
        parameters: {'lat': position.latitude, 'lon': position.longitude});
    return response.data;
  }

  Future<BaseData<dynamic>> fetchForecast(LatLng position) async {
    Response response = await _apiService.handleGet(
        type: FetchDataType.FORECAST_DATA,
        parameters: {'lat': position.latitude, 'lon': position.longitude});
    return response.data;
  }
}
