import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

class Map extends StatelessWidget {
  GoogleMapController _controller;
  bool tracking = false;

  _onMapCreated(UserModel user) {
    user.setAllItemVenues();
  }

  _onCameraMove(CameraPosition position) {
  }

  _animateToUser() async {
    var pos = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    _controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(pos.latitude, pos.longitude),
          zoom: 14.4746,
        )
      )
    );

    // TODO: RESET ALL ITEM VENUES!
  }

  toggleTracking(){
    print("Tracking running.");
    tracking = !tracking;
    if(tracking){
      _animateToUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, user, child) {
      return Container(
          child: GoogleMap(
            markers: user.getMarkers(),
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: LatLng(double.parse(user.lat), double.parse(user.long)),
              zoom: 14.4746,
            ),
            onMapCreated: (GoogleMapController controller) {
                            _controller = controller;
                            _onMapCreated(user);
                          },
            zoomGesturesEnabled: true,
            onCameraMove: _onCameraMove,
            myLocationEnabled: true,
            compassEnabled: true,
            myLocationButtonEnabled: false,
      ));
    });
  }
}
