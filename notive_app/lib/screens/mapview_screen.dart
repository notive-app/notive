import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'constants.dart';
import 'package:notive_app/screens/archived_lists_screen.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/profile_screen.dart';
import 'package:notive_app/screens/settings_screen.dart';
import 'package:notive_app/screens/dashboard_screen.dart';
import 'package:notive_app/components/rounded_button.dart';

class MapViewScreen extends StatefulWidget {
  static const String id = 'mapview_screen';
  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(39.8674631968, 32.7425503631);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

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
                //why is this giving an error?
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
                //why is this giving an error?
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
                //why is this giving an error?
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
                //why is this giving an error?
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
                //why is this giving an error?
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
                ),
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
    );
  }
}
