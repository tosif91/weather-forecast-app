import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app/locator.dart';
import 'package:weather_app/services/authentication_service.dart';
import 'package:weather_app/services/connection_service.dart';
import 'package:weather_app/services/local_storage_service.dart';
import 'package:weather_app/utils/routes.dart';
import 'package:permission_handler/permission_handler.dart';

class SplashModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();
  final ConnectionService _connectionService = locator<ConnectionService>();
  initApp() async {
    bool status = await _localStorageService.initHive();
    if (status) {
      await _localStorageService.openHiveBox();
      _connectionService.initialize();
      _haveLocationPermission();
    } else {}
  }

  _haveLocationPermission() async {
    Permission.location.request().then((status) {
      print('location permission is $status');
      switch (status) {
        case PermissionStatus.granted:
          Future.delayed(Duration(seconds: 2), () {
            bool userStatus = _authenticationService.checkUser();
            if (userStatus)
              _navigationService.clearStackAndShow(home);
            else
              _navigationService.clearStackAndShow(logIn);
          });
          break;
        case PermissionStatus.denied:
          // _navigateToLocationPermission();
          _haveLocationPermission();
          break;
        case PermissionStatus.permanentlyDenied:
          _navigateToLocationPermission();
          break;
        default:
          _navigateToLocationPermission();
      }
    });
  }

  _navigateToLocationPermission() {
    _navigationService.clearStackAndShow(locationPermission);
  }

  showLocationNeed() {}
}
