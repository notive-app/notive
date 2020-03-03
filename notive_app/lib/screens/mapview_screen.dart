import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'constants.dart';
import 'package:notive_app/screens/archived_lists_screen.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/profile_screen.dart';
import 'package:notive_app/screens/settings_screen.dart';
import 'package:notive_app/screens/dashboard_screen.dart';
import 'package:notive_app/components/rounded_button.dart';
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
  final LatLng _center = const LatLng(40.712776, -74.005974);
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

  // 1
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  //color: Colors.black,
                  ),
              child: Text(
                'MENU',
                style: TextStyle(
                  //color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.map,
                color: kOrangeColor,
              ),
              title: Text(
                'Map View',
                style: TextStyle(color: kOrangeColor),
              ),
              selected: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapViewScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.view_list,
                color: kOrangeColor,
              ),
              title: Text(
                'Dashboard',
                style: TextStyle(color: kOrangeColor),
              ),
              selected: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DashboardScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.playlist_add_check,
                color: kOrangeColor,
              ),
              title: Text(
                'Archived Lists',
                style: TextStyle(color: kOrangeColor),
              ),
              selected: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ArchivedListsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.account_circle,
                color: kOrangeColor,
              ),
              title: Text(
                'Account',
                style: TextStyle(color: kOrangeColor),
              ),
              selected: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.settings,
                color: kOrangeColor,
              ),
              title: Text(
                'Settings',
                style: TextStyle(color: kOrangeColor),
              ),
              selected: true,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: kOrangeColor,
              ),
              title: Text(
                'Log Out',
                style: TextStyle(color: kOrangeColor),
              ),
              selected: true,
            ),
          ],
        ),
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
                  target: _center,
                  zoom: 11.0,
                  bearing: 15.0, // 1
                  tilt: 75.0, // 2
                ),
                //TODO check how to get a list of variables ??
                markers: {
                  markerOne,
                  markerTwo,
                  markerThree,
                  markerFour,
                  markerFive,
                  markerSix,
                },
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

Marker markerOne = Marker(
  markerId: MarkerId('gramercy'),
  position: LatLng(40.738380, -73.988426),
  infoWindow: InfoWindow(title: 'Gramercy Tavern'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);

Marker markerTwo = Marker(
  markerId: MarkerId('bernardin'),
  position: LatLng(40.761421, -73.981667),
  infoWindow: InfoWindow(title: 'Le Bernardin'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);

Marker markerThree = Marker(
  markerId: MarkerId('bluehill'),
  position: LatLng(40.732128, -73.999619),
  infoWindow: InfoWindow(title: 'Blue Hill'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);

Marker markerFour = Marker(
  markerId: MarkerId('newyork1'),
  position: LatLng(40.742451, -74.005959),
  infoWindow: InfoWindow(title: 'Los Tacos'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);

Marker markerFive = Marker(
  markerId: MarkerId('newyork2'),
  position: LatLng(40.729640, -73.983510),
  infoWindow: InfoWindow(title: 'Tree Bistro'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);

Marker markerSix = Marker(
  markerId: MarkerId('newyork3'),
  position: LatLng(40.719109, -74.000183),
  infoWindow: InfoWindow(title: 'Le Coucou'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueRed,
  ),
);
