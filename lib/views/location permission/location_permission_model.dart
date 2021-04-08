import 'package:stacked/stacked.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app/locator.dart';
import 'package:weather_app/utils/routes.dart';

class LocationPermissionModel extends BaseViewModel {
  SnackbarService _snackbarService = locator<SnackbarService>();
  NavigationService _navigationService = locator<NavigationService>();
  checkLocationPermission() {
    // setBusy(true);
    Permission.location.request().then((status) {
      switch (status) {
        case PermissionStatus.granted:
          _navigationService.clearStackAndShow(home);
          break;
        default:
          _snackbarService.showSnackbar(
              message: 'location Permission not granted !',
              duration: Duration(milliseconds: 1000));
      }
    });
    // setBusy(false);
  }
}
