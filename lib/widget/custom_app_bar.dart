import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSize {
  final LatLng position;
  final Function callback;
  @override
  final Size preferredSize; // default is 56.0
  CustomAppBar({@required this.position, @required this.callback})
      : preferredSize = Size.fromHeight(56.0);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Row(
        children: [
          InkWell(
            onTap: () => callback(context),
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Icon(
                Icons.menu,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: ClipRRect(
                child: BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Card(
                      elevation: 10,
                      color: Colors.transparent,
                      child: new Container(
                          alignment: Alignment.center,
                          height: 56,
                          child: Text(
                              'lat: ${position?.latitude?.toStringAsFixed(2)} lng: ${position?.longitude?.toStringAsFixed(2)}'),
                          decoration: new BoxDecoration(
                              color: Colors.grey.shade200.withOpacity(0.5))),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();
}
