import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapComponent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MapComponentState();
}

class _MapComponentState extends State<MapComponent> {
  GoogleMapController mapController;
  //_final LatLng _center = const LatLng(40.712776, -74.005974);

  List<Marker> markers = <Marker>[];
  //40.712776, -74.005974 - NY
  //39.8674631968, 32.7425503631 - Ankara

  static Position position;
  Future<Position> _getLocation() async {
   Position currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    print(position.longitude.toString());
    return currentLocation;
  }

  void _onMapCreated(GoogleMapController controller) async {
    _setStyle(controller);
    mapController = controller;
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/maps_style.json');
    controller.setMapStyle(value);
  }

  Future<void> setPosition() async {
    position = await _getLocation();
  }

  @override
  void initState() {
    super.initState();
    setPosition();
  }

  static double latitude = position.latitude;
  static double longitude = position.longitude;

  static LatLng _initialPosition = new LatLng(latitude, longitude);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: Column(
      children: <Widget>[
        Flexible(
          child: GoogleMap(
            //mapType: MapType.hybrid,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 11.0,
              bearing: 15.0, // 1
              tilt: 75.0, // 2
            ),
            //TODO check how to get a list of variables ??
            markers: {
              //markerOne
            },
          ),
        ),
      ],
    ));
  }
}
