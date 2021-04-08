import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app/locator.dart';
import 'package:weather_app/services/authentication_service.dart';
import 'package:weather_app/services/connection_service.dart';
import 'package:weather_app/services/local_storage_service.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/constants.dart';
import 'package:weather_app/utils/routes.dart';

class OTPModel extends BaseViewModel {
  final TextEditingController otpController = TextEditingController();
  static const oneSec = const Duration(seconds: 1);
  bool _isConnected = false;
  StreamSubscription _connectionSubscription;
  final ConnectionService _connectionService = locator<ConnectionService>();
  int _otpTimer;
  String mobileNumber;
  Timer _timer;
  final AuthenticationService _authenticationService =
      locator<AuthenticationService>();
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  final SnackbarService _snackbarService = locator<SnackbarService>();
  bool _resendingOTP = false;
  get otpTimer => _otpTimer;
  get resendingOTP => _resendingOTP;

  // SuccessData _result;

  initialize() {
    listenConnection();
    // _localStorageService.openHiveBox();
    mobileNumber = _authenticationService.mobileNo;
    startTimer();
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

  changeNo() {
    if (_otpTimer == 0 && !resendingOTP)
      _navigationService.back();
    else
      _snackbarService.showSnackbar(message: 'please wait...');
  }

  validateOTP(String value) {
    if (value.length != 6)
      return 'Invalid OTP';
    else
      return null;
  }

  void startTimer() {
    _otpTimer = 10;
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_otpTimer < 1) {
        timer.cancel();
      } else {
        _otpTimer = _otpTimer - 1;
      }
      notifyListeners();
    });
  }

  handleOTP() async {
    FocusManager.instance.primaryFocus.unfocus();
    if (_isConnected) {
      if (otpController.text.trim().isNotEmpty) {
        if (!isBusy) {
          setBusy(true);
          bool authState = await _authenticationService.submitOTP(
              otpController.text.trim(), () => signInFirebaseError());

          if (authState != null) {
            if (authState) {
              await _localStorageService.updateSingleInfo(
                  key: phoneNo, value: mobileNumber);
              _navigationService.navigateTo(home);
            } else {
              setBusy(false);
              otpController.clear();
              _snackbarService.showSnackbar(
                  message: 'Inalid OTP, Enter the correct OTP!');
              // Alert(
              //         context: _navigationService.navigatorKey.currentContext,
              //         style: AlertStyle(
              //             isCloseButton: false,
              //             titleStyle: TextStyle(color: Colors.white),
              //             descStyle: TextStyle(color: Colors.white),
              //             backgroundColor: Colors.blueGrey),
              //         buttons: [
              //           DialogButton(
              //             child: Text(
              //               'ok',
              //               style: TextStyle(color: Colors.white),
              //             ),
              //             onPressed: () => _navigationService.back(),
              //             color: orange,
              //           )
              //         ],
              //         title: 'Invalid OTP',
              //         desc: 'Enter the correct OTP!')
              //     .show();
            }
          }
        }
      }
    } else
      noInternet();
  }

  clearResendSMS() {
    if (_otpTimer == 0) otpController.clear();
    _timer.cancel();
    _otpTimer = 0;
    //  notifyListeners();
  }

  resendSMS() async {
    clearResendSMS();
    if (_isConnected) if (!_resendingOTP) {
      _resendingOTP = true;
      notifyListeners();
      await _authenticationService
          .resendVerificationSms(
              mobileNumber,
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
    //may need to change this
    print('code sent successfully');
    _resendingOTP = false;
    startTimer();
  }

// callback function neede to be passed
  void verificationCompleted() async {
    print('verification compeleted');

    await _localStorageService.updateSingleInfo(
        key: phoneNo, value: mobileNumber);
    await _navigationService.clearStackAndShow(home);
  }

  void verificationFailed() async {
    print('verification failed');
    setBusy(false);
    _resendingOTP = false;
    await _dialogService.showDialog(
        title: 'error', description: 'check your entered number');
  }

  void autoRetrieveTimeOut() {
    print('autoRetrieve time out');
  }

  void signInFirebaseError() {
    setBusy(false);
    _dialogService.showDialog(
        title: 'app error', description: 'something went wrong retry again');
  }

  noInternet() => _snackbarService.showSnackbar(
        message: 'check your internet connection',
        title: 'no internet',
        duration: Duration(seconds: 4),
      );

  Future<bool> onBackPressed() async {
    return false;
    // if (_otpTimer == 0 && !resendingOTP)
    //   _navigationService.back();
    // else
    //   _dialogService.showDialog(
    //       title: 'please wait', description: 'verification in progress');
  }

  // checkUserRegistration() async {
  //   _result = await _cloudDatabaseService.checkUserRegistered();
  //   if (_result.success) {
  //     if (_result.data == true) {
  //       await _navigationService.clearStackAndShow(home);
  //     } else {
  //       await _navigationService.clearStackAndShow(invaliduser);
  //     }
  //   } else {
  //     print('caught an firebase error');
  //   }
  // }

  @override
  void dispose() {
    print('diposes otpModel');
    if (_timer?.isActive ?? false) _timer.cancel();
    _connectionSubscription.cancel();
    otpController.dispose();

    super.dispose();
  }
}
