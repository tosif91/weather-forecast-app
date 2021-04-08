import 'dart:async';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app/locator.dart';
import 'package:weather_app/services/authentication_service.dart';
import 'package:weather_app/services/connection_service.dart';
import 'package:weather_app/services/local_storage_service.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/styles.dart';
import 'package:weather_app/views/home/home_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeModel extends BaseViewModel {
  ConnectionService _connectionService = locator<ConnectionService>();
  NavigationService _navigationService = locator<NavigationService>();
  AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  LocalStorageService _localStorageService = locator<LocalStorageService>();
  GoogleMapController controller;
  Completer<GoogleMapController> _mapController = Completer();
  CameraPosition currentlocation;
  Position position;
  bool _isConnected = false;
  SnackbarService _snackbarService = locator<SnackbarService>();
  StreamSubscription _connectionSubscription;
  bool isError = false;
  String mobileNo;
  String currentAddress;
  setIsError(bool value) {
    isError = value;
    notifyListeners();
  }
  // bool isLogOut = false;
  // setLogOut() {
  //   isLogOut = !isLogOut;
  // }

  initialize() async {
    setBusy(true);

    mobileNo = _localStorageService.fetchLocalData(key: phoneNo);
    listenConnection();
    await getUserLocation();
    currentAddress = await getaddress(currentlocation.target);
    setBusy(false);
  }

  listenConnection() {
    _isConnected = _connectionService.hasConnection;
    notifyListeners();
    _connectionSubscription =
        _connectionService.connectionChange.listen((event) {
      _isConnected = event;
      notifyListeners();
    });
  }

  setCurrentLocation(CameraPosition position) {
    currentlocation = position;
    notifyListeners();
  }

  navigateToWeatherInfo() {
    print('${currentlocation.target}');
    if (_isConnected)
      _navigationService.navigateTo(weatherInfo,
          arguments: currentlocation.target);
    else
      _snackbarService.showSnackbar(message: 'check your network connection!');
  }

  navigateToHistory() {
    _navigationService.back();
    _navigationService.navigateTo(history);
  }

  showLogOutAlert() {
    Alert(
        context: _navigationService.navigatorKey.currentContext,
        title: 'LogOut',
        style: AlertStyle(
          backgroundColor: Colors.black87,
          titleStyle: TextStyle(color: orange),
        ),
        buttons: [
          DialogButton(
            child: Text('Yes'),
            onPressed: () => logOut(),
            color: Colors.grey,
          ),
          DialogButton(
            child: Text('No'),
            onPressed: () => _navigationService.back(),
          ),
        ]).show();
  }

  logOut() async {
    // setLogOut();
    bool status = await _authenticationService.signOut();
    // setLogOut();
    _navigationService.back();
    if (status) {
      _localStorageService.clearLocalState();
      _navigationService.clearStackAndShow(logIn);
    } else
      _snackbarService.showSnackbar(message: 'please try again!');
  }

  Future<String> getaddress(LatLng latLng) async {
    final coordinates = new Coordinates(latLng.latitude, latLng.longitude);
    try {
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses[addresses.length - 2];
      var second = addresses.last;
      return first.addressLine + second.addressLine;
    } catch (e) {
      setBusy(false);
      setIsError(true);
    }
  }

  handleDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void onMapCreated(GoogleMapController controller) {
    print('called map created');
    controller.setMapStyle(
        '[{"elementType": "geometry","stylers": [{"color": "#212121"}]  },  {    "elementType": "labels.icon",    "stylers": [      {"visibility": "off"}    ]  },  {    "elementType": "labels.text.fill",    "stylers": [      {        "color": "#e56d1b"      }]  },  {    "elementType": "labels.text.stroke",    "stylers": [      {        "color": "#212121"      }    ]  },  {    "featureType": "administrative","elementType": "geometry",    "stylers": [     {        "color": "#757575"      }    ]  },  {    "featureType": "administrative.country",    "elementType": "labels.text.fill","stylers": [      {        "color": "#9e9e9e"      }    ]  },  {    "featureType": "administrative.land_parcel",    "stylers": [      {"visibility": "off"}]  },  {    "featureType": "administrative.locality", "elementType": "labels.text.fill",    "stylers": [{"color": "#bdbdbd"      }    ]  },  {    "featureType": "poi",    "elementType": "labels.text.fill",    "stylers": [      {        "color": "#757575"      }    ]  },  {"featureType": "poi.park",    "elementType": "geometry",    "stylers": [      {"color": "#181818"      }    ]  },  {    "featureType": "poi.park",    "elementType": "labels.text.fill",    "stylers": [      {"color": "#616161"      }    ]  },  {    "featureType": "poi.park",    "elementType": "labels.text.stroke",    "stylers": [      {        "color": "#1b1b1b"      }    ]  },  {    "featureType": "road",    "elementType": "geometry.fill",    "stylers": [      {"color": "#2c2c2c"      }    ]  },  {    "featureType": "road",    "elementType": "labels.text.fill",    "stylers": [      {       "color": "#8a8a8a"      }    ]  },  {    "featureType": "road.arterial",    "elementType": "geometry",    "stylers": [      {"color": "#373737"      }    ]  },  {    "featureType": "road.highway",    "elementType": "geometry",    "stylers": [      {        "color": "#3c3c3c"      }    ]  },  {    "featureType": "road.highway.controlled_access",    "elementType": "geometry",    "stylers": [{        "color": "#4e4e4e"      }    ]  },  {    "featureType": "road.local",    "elementType": "labels.text.fill",    "stylers": [      {        "color": "#616161"      }    ]  },  {    "featureType": "transit",    "elementType": "labels.text.fill",    "stylers": [{ "color": "#757575"}]  },  {    "featureType": "water",    "elementType": "geometry",    "stylers": [      {        "color": "#000000"      }   ]  },  {    "featureType": "water",    "elementType": "labels.text.fill",    "stylers": [      {        "color": "#3d3d3d"      }    ]  }]');
    this.controller = controller;

    // addLoc(LatLng(position.latitude - 0.004, position.longitude - 0.001),
    //     "ABCD GYM"); //only for dummy location

    // locations.forEach((key, value) {
    //   print("dist to" +
    //       value +
    //       " :" +
    //       Geolocator.distanceBetween(position.latitude, position.longitude,
    //               key.latitude, key.longitude)
    //           .toString());
    //   if (Geolocator.distanceBetween(position.latitude, position.longitude,
    //           key.latitude, key.longitude) <=
    //       5000) {
    //     addLoc(key, value);
    //   }
    // });

    _mapController.complete(controller);
    // setBusy(false);
  }

  Future<void> getUserLocation() async {
    try {
      position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print("Current location: " + position.toString());
      // addLoc(LatLng(position.latitude, position.longitude),
      //     "Your current location",
      //     isme: true);
      currentlocation = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14,
      );
    } catch (e) {
      print(e);
      //   DialogResponse response = await DialogService().showConfirmationDialog(
      //       title: 'Error',
      //       description:
      //           'Map feature cannot be accessed without location permission',
      //       cancelTitle: 'CANCEL',
      //       confirmationTitle: 'RETRY');

      //   if (response.confirmed) {
      //     // getCurrentLocation();
      //   }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _connectionSubscription.cancel();
    // super.dispose();
  }
}
