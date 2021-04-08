import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app/locator.dart';
import 'package:weather_app/models/history_item_data.dart';
import 'package:weather_app/services/local_storage_service.dart';
import 'package:weather_app/utils/routes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HistoryModel extends BaseViewModel {
  LocalStorageService _localStorageService = locator<LocalStorageService>();
  NavigationService _navigationService = locator<NavigationService>();
  List<HistoryItemData> itemData = <HistoryItemData>[];
  int historyLength;

  initialize() {
    setBusy(true);
    historyLength = _localStorageService.getHistoryLength();
    print(historyLength);
    setBusy(false);
  }

  navigateToWeatherInfo(HistoryItemData data) {
    _navigationService.navigateTo(weatherInfo,
        arguments: LatLng(data.lat, data.lon));
  }

  retrieveItem(int index) => _localStorageService.retrieveItem(index);
}
