import 'package:dio/dio.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app/locator.dart';
import 'package:weather_app/models/base_data.dart';
import 'package:weather_app/models/current_weather_response.dart';

import 'package:weather_app/models/history_item_data.dart';
import 'package:weather_app/models/weather_forecast_response.dart';
import 'package:weather_app/services/database_service.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:weather_app/services/local_storage_service.dart';

class WeatherInfoModel extends BaseViewModel {
  DatabaseService _databaseService = locator<DatabaseService>();
  CurrentWeatherResponse currentWeatherResponse;
  SnackbarService _snackbarService = locator<SnackbarService>();
  LocalStorageService _localStorageService = locator<LocalStorageService>();
  LatLng location;
  List<List<ListElement>> dayForecastList = <List<ListElement>>[];
  bool isSaved = true;
  bool fetchingWeatherData = true;
  bool fetchingForecastData = true;

  WeatherForecastResponse weatherForecastResponse;

  setfetchWeatherData(bool value) {
    fetchingWeatherData = value;
    notifyListeners();
  }

  setFetchForecastData(bool value) {
    fetchingForecastData = value;
    notifyListeners();
  }

  HistoryItemData _historyData;
  setIsSaved(bool value) {
    isSaved = value;
    notifyListeners();
  }

  generateForecastList() {
    DateTime tempDate = DateTime.now();
    List<ListElement> tempList = <ListElement>[];
    weatherForecastResponse.list.forEach((item) {
      DateTime itemDate = DateTime.fromMillisecondsSinceEpoch(item.dt * 1000);
      print('${tempDate.day}----${itemDate.day}');
      if (tempDate.day == itemDate.day) tempList.add(item);
      if (tempDate.day < itemDate.day) {
        tempDate = itemDate;
        dayForecastList.add(tempList);
        tempList = <ListElement>[];
        tempList.add(item);
        // tempList.add(item);
      }
    });
    dayForecastList.add(tempList);
  }

  initialize(LatLng value) async {
    location = value;

    getWeatherInfo();
    getForecastData();
  }

  saveToHistory() {
    _localStorageService.saveHistoy(_historyData);
    setIsSaved(true);
    _snackbarService.showSnackbar(message: 'Saved To History');
  }

  retry(int index) async {
    if (index == 0) {
      print('currentweather');
      setfetchWeatherData(true);
      getWeatherInfo();
    }
    if (index == 1) {
      print('forecastweather');
      setFetchForecastData(true);
      getForecastData();
    }
  }

  getWeatherInfo() async {
    BaseData result = await _databaseService.currentWeatherInfo(location);
    if (result.data != null) {
      currentWeatherResponse = result.data;

      _historyData = HistoryItemData(
          country: "${currentWeatherResponse?.name}",
          name: "${currentWeatherResponse?.sys?.country}",
          lat: location.latitude,
          lon: location.longitude);
      isSaved = _localStorageService.filterTrackHistory(_historyData);

      // notifyListeners();
    } else {
      _snackbarService.showSnackbar(message: '${result.message}');
    }
    setfetchWeatherData(false);
  }

  getForecastData() async {
    BaseData result = await _databaseService.fetchForecast(location);
    if (result.data != null) {
      weatherForecastResponse = result.data;
      generateForecastList();
    } else {
      setBusy(false);
      _snackbarService.showSnackbar(message: '${result.message}');
    }
    setFetchForecastData(false);
  }
}
