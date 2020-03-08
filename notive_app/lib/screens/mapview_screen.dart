import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';
import 'constants.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/components/rounded_button.dart';
import 'package:geolocator/geolocator.dart';
//import 'dart:convert';
//import 'package:http/http.dart' as http;
//import 'package:flutter/services.dart' show rootBundle;
//TODO add --> import 'package:map_controller/map_controller.dart';
//TODO check add map controls and map assets

class MapViewScreen extends StatefulWidget {
  static const String id = 'mapview_screen';
  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  static const String _API_KEY = '{{AIzaSyAKAT8GgEpqEYfCp_qBHLE5M5BhPz6sCEk}}';

  GoogleMapController mapController;
  //_final LatLng _center = const LatLng(40.712776, -74.005974);

  List<Marker> markers = <Marker>[];
  //40.712776, -74.005974 - NY
  //39.8674631968, 32.7425503631 - Ankara

  void _onMapCreated(GoogleMapController controller) {
    _setStyle(controller);
    mapController = controller;
  }

  void _setStyle(GoogleMapController controller) async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/maps_style.json');
    controller.setMapStyle(value);
  }

  static LatLng _initialPosition;
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print('${placemark[0].name}');
    });
  }
  /* Marker markerOne = Marker(
  markerId: MarkerId('gramercy'),
  position: _initialPosition,
  infoWindow: InfoWindow(title: 'Gramercy Tavern'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ), */
//);
  // 1
//SEARCH IN MAP CODE
//  void searchNearby(double latitude, double longitude) async {
//    setState(() {
//      markers.clear(); // 2
//    });
//    // 3
//    String url =
//        '$baseUrl?key=$_API_KEY&location=$latitude,$longitude&radius=10000&keyword=${widget.keyword}';
//    print(url);
//    // 4
//    final response = await http.get(url);
//    // 5
//    if (response.statusCode == 200) {
//      final data = json.decode(response.body);
//      _handleResponse(data);
//    } else {
//      throw Exception('An error occurred getting places nearby');
//    }
//    setState(() {
//      searching = false; // 6
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: 2,
      ),
      appBar: AppBar(
        title: Text('Map View'),
        //backgroundColor: Colors.black,
      ),
      body: SafeArea(
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
                /* markers:{
                  markerOne
                }, */
              ),
            ),
            RoundedButton(
              title: 'Check Locations in List View',
              colour: kLightBlueColor,
              onPressed: () {
                Navigator.pushNamed(context, MapViewScreen.id);
              },
            ),
          ],
        ),
      ),
//      floatingActionButton: FloatingActionButton.extended(
//        onPressed: () {
//          searchNearby(39.8674631968, 32.7425503631); // 2
//        },
//        label: Text('Places Nearby'), // 3
//        icon: Icon(Icons.place), // 4
//      ),
    );
  }
}



