import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:weather_app/utils/colors.dart';
import 'package:weather_app/utils/styles.dart';
import 'package:weather_app/views/home/home_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:weather_app/widget/custom_app_bar.dart';
import 'package:weather_app/widget/progress_indicator.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<HomeModel>.reactive(
      viewModelBuilder: () => HomeModel(),
      onModelReady: (model) => model.initialize(),
      builder: (context, model, map) => SafeArea(
        child: Scaffold(
          extendBodyBehindAppBar: true,
          drawer: Drawer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'UserInfo',
                        style: TextStyle(
                            fontSize: 40, color: orange.withOpacity(.9)),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Current Location',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        (model.currentAddress == null)
                            ? '_'
                            : '${model.currentAddress}',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Phone No.',
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${model.mobileNo}',
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
                Divider(),
                ListTile(
                  onTap: () => model.navigateToHistory(),
                  title: Text('History'),
                  trailing: Icon(FontAwesomeIcons.history),
                ),
                Divider(),
                // (model.isLogOut)
                //     ? Center(
                //         child: CircularProgressIndicator(),
                //       )
                //     :
                ListTile(
                  onTap: () => model.showLogOutAlert(),
                  title: Text('LogOut'),
                  trailing: Icon(FontAwesomeIcons.signOutAlt),
                )
              ],
            ),
          ),
          appBar: CustomAppBar(
            position: (model.currentlocation?.target != null)
                ? model.currentlocation?.target
                : LatLng(0.0, 0.0),
            callback: model.handleDrawer,
          ),
          body: (model.isBusy)
              ? ProgressIndicatorWidget()
              : (model.isError)
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Oops, Something went wrong!'),
                        OutlinedButton(
                            onPressed: () => model.initialize(),
                            child: Text('Retry'))
                      ],
                    ))
                  : Stack(
                      children: [
                        GoogleMap(
                            onMapCreated: model.onMapCreated,
                            // liteModeEnabled: true,
                            zoomControlsEnabled: false,
                            onCameraMove: model.setCurrentLocation,
                            initialCameraPosition: model.currentlocation),
                        // Positioned(top: 0, child: CustomAppBar()),
                        new Positioned(
                          top: (_height - 30) / 2,
                          right: (_width - 25) / 2,
                          child: new Icon(
                            FontAwesomeIcons.mapPin,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        Positioned(
                            bottom: 5,
                            left: 5,
                            right: 5,
                            child: InkWell(
                              onTap: () => model.navigateToWeatherInfo(),
                              child: Container(
                                height: 44,
                                alignment: Alignment.center,
                                width: _width,
                                decoration: BoxDecoration(
                                    color: orange,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  'Choose',
                                  style: headingwhite,
                                ),
                              ),
                            ))
                      ],
                    ),
        ),
      ),
    );
  }
}
