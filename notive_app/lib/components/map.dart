import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:provider/provider.dart';

class Map extends StatelessWidget {
  _onMapCreated(UserModel user) {
    user.setAllItemVenues();
  }

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
        onMapCreated: _onMapCreated(user),
        zoomGesturesEnabled: true,
        onCameraMove: _onCameraMove,
        myLocationEnabled: true,
        compassEnabled: true,
        myLocationButtonEnabled: false,
      ));
    });
  }
}
