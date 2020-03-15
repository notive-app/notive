import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:notive_app/models/item_model.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/models/venue_model.dart';
import 'package:provider/provider.dart';


//TODO make me stateless !!!


class Map extends StatelessWidget {

  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
//  static LatLng _initialPosition;
//  final Set<Marker> _markers = {};
//  static LatLng _lastMapPosition = _initialPosition;


//  void _getUserLocation() async {
//    Position position = await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//    List<Placemark> placemark = await Geolocator()
//        .placemarkFromCoordinates(position.latitude, position.longitude);
//    setState(() {
//      _initialPosition = position.latitude, position.longitude);
//      print('${placemark[0].name}');
//    });
//  }

//  Future<String> getCurrentLocation() async {
//    String res = "";
//    Position position = await Geolocator()
//        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//    return res + position.latitude.toString() + ", " + position.longitude.toString();
//  }

  _onMapCreated(UserModel user) {
    user.setAllItemVenues();
  }

  _onCameraMove(CameraPosition position) {
//    _lastMapPosition = position.target;
  }

//  _onAddMarkerButtonPressed() {
//    setState(() {
//      _markers.add(Marker(
//          markerId: MarkerId(_lastMapPosition.toString()),
//          position: _lastMapPosition,
//          infoWindow: InfoWindow(
//              title: "Pizza Parlour",
//              snippet: "This is a snippet",
//              onTap: () {}),
//          onTap: () {},
//          icon: BitmapDescriptor.defaultMarker));
//    });
//  }

//  Widget mapButton(Function function, Icon icon, Color color) {
//    return RawMaterialButton(
//      onPressed: function,
//      child: icon,
//      shape: new CircleBorder(),
//      elevation: 2.0,
//      fillColor: color,
//      padding: const EdgeInsets.all(7.0),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
        builder: (context, user, child) {
          return Container(
              child: GoogleMap(
                markers: user.getMarkers(),
                mapType: MapType.normal,
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      double.parse(user.lat), double.parse(user.long)),
                  zoom: 14.4746,
                ),
                onMapCreated: _onMapCreated(user),
                zoomGesturesEnabled: true,
                onCameraMove: _onCameraMove,
                myLocationEnabled: true,
                compassEnabled: true,
                myLocationButtonEnabled: false,
                
              )
          );
        }
    );
  }
}
