import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app/services/authentication_service.dart';
import 'package:weather_app/services/connection_service.dart';
import 'package:weather_app/utils/routes.dart';

import '../../../locator.dart';

class MobileModel extends BaseViewModel {
  bool _isConnected = false;
  StreamSubscription _connectionSubscription;
  final ConnectionService _connectionService = locator<ConnectionService>();
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final TextEditingController mobileController = TextEditingController();
  final NavigationService _navigationService = locator<NavigationService>();
  final SnackbarService _snackbarService = locator<SnackbarService>();

  initialize() {
    listenConnection();
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

  validateMobile(String value) {
    if (value.length != 10)
      return 'Invalid Mobile no';
    else
      return null;
  }

  sendOTP() async {
    FocusManager.instance.primaryFocus.unfocus();
    if (_isConnected) {
      setBusy(true);
      // controller.jumpToPage(++_page);
      await _authenticationService
          .registerUser(
              mobileController.text.trim(),
              () => codeSent(),
              () => verificationCompleted(),
              () => verificationFailed(),
              () => autoRetrieveTimeOut(),
              () => signInFirebaseError())
          .then((value) {});
    } else
      noInternet();
  }

  void codeSent() {
    _authenticationService.mobileNo = mobileController.text.trim();
    //may need to change this
    print('code sent successfully');
    setBusy(false);
    _navigationService.navigateTo(otp);
  }

  // callback function neede to be passed
  void verificationCompleted() async {
    print('verification compeleted');
    await _navigationService.clearStackAndShow(home);
  }

  void verificationFailed() async {
    print('verification failed');
    setBusy(false);
    AlertDialog(
      title: Text('Error'),
      content: Text('Someting went wrong, Please try again!'),
    );
  }

  void autoRetrieveTimeOut() {
    print('autoRetrieve time out');
  }

  void signInFirebaseError() {
    setBusy(false);
    AlertDialog(
      title: Text('Error'),
      content: Text('Someting went wrong, Please try again!'),
    );
  }

  noInternet() => _snackbarService.showSnackbar(
        message: 'check your internet connection',
        title: 'no internet',
        duration: Duration(seconds: 4),
      );
  handleBackPressed() {
    if (isBusy) _snackbarService.showSnackbar(message: 'please wait...');
    _navigationService.back();
  }

  @override
  void dispose() {
    print('mobile model disposed');
    _connectionSubscription.cancel();
    mobileController.dispose();
    super.dispose();
  }
}
