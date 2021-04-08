import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app/locator.dart';
import 'package:weather_app/utils/routes.dart';

class LogInModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();

  navigateToMobile() {
    _navigationService.clearStackAndShow(mobile);
  }

  @override
  void dispose() async {
    print('called loginModel dispose');
    super.dispose();
  }
}
