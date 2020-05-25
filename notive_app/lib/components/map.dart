import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:provider/provider.dart';

class Map extends StatelessWidget {
//  _onMapCreated(UserModel user) {
//    user.setAllItemVenues();
//  }
  Completer<GoogleMapController> _controller = Completer();

  _onCameraMove(CameraPosition position) {}

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
          _controller.complete(controller);
        },
        zoomGesturesEnabled: true,
        onCameraMove: _onCameraMove,
        myLocationEnabled: true,
        compassEnabled: true,
        myLocationButtonEnabled: true,
      ));
    });
  }

  Future<void> changeCameraPos(LatLng target) async {
    CameraPosition newPos = CameraPosition(
      target: target,
      zoom: 14.4746,
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(newPos));
  }
}
