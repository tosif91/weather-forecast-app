import 'package:get_it/get_it.dart';
// import 'package:passenger_flutter_app/services/payment_service.dart';

import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app/services/api_service.dart';
import 'package:weather_app/services/authentication_service.dart';
import 'package:weather_app/services/connection_service.dart';
import 'package:weather_app/services/database_service.dart';
import 'package:weather_app/services/local_storage_service.dart';

GetIt locator = GetIt.instance;

setUpLocator() {
  //stacked service..
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());

  //services
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => LocalStorageService());
  locator.registerLazySingleton(() => ConnectionService());
  locator.registerLazySingleton(() => DatabaseService());
  locator.registerLazySingleton(() => ApiService());
}
