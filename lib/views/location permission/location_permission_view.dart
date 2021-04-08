import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/styles.dart';
import 'package:weather_app/views/location%20permission/location_permission_model.dart';

class LocationPermissionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ViewModelBuilder<LocationPermissionModel>.reactive(
      viewModelBuilder: () => LocationPermissionModel(),
      builder: (context, model, _) => Container(
        decoration: background,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Location Permission is required  to run this app, please provide the permission from app permission in your settings!',
              textAlign: TextAlign.center,
              style: headingwhite,
            ),
            const SizedBox(
              height: 15,
            ),
            OutlinedButton(
                onPressed: () => model.checkLocationPermission(),
                child: Text('Retry'))
          ],
        ),
      ),
    ));
  }
}
