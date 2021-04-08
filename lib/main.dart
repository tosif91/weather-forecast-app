import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:weather_app/locator.dart';
import 'package:weather_app/routers.dart';
import 'package:weather_app/utils/styles.dart';
import 'package:weather_app/views/history/history_view.dart';
import 'package:weather_app/views/home/home_view.dart';
import 'package:weather_app/views/splash/splash_view.dart';
import 'package:weather_app/views/weather%20info/weather_info_view.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.done)
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData.dark(),
              navigatorKey: NavigationService().navigatorKey,
              onGenerateRoute: Routers.toGenerateRoute,
              home: SplashView(),
            );
          else if (snapShot.hasError) {
            return Scaffold(
              body: Center(
                child: Column(
                  children: [
                    const Text(
                      'please Check your Network Connection',
                      style: subheading,
                    ),
                  ],
                ),
              ),
            );
          } else
            return Container(
              child: Center(
                child: const Text(
                  'Weather App',
                  textDirection: TextDirection.ltr,
                  style: subheading,
                ),
              ),
            );
        });
  }
}
