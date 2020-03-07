import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';
import 'package:notive_app/components/map_component.dart';
import 'constants.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/components/rounded_button.dart';
import 'package:geolocator/geolocator.dart';
//TODO add --> import 'package:map_controller/map_controller.dart';
//TODO check add map controls and map assets

class MapViewScreen extends StatefulWidget {
  static const String id = 'mapview_screen';
  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
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
              child: MapComponent(),
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



