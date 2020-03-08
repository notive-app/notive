import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';
import 'package:notive_app/util/request.dart';

class MapViewScreen extends StatefulWidget {
  static const String id = 'mapview_screen';
  @override
  _MapViewScreenState createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  Completer<GoogleMapController> controller1 = Completer();

  //static LatLng _center = LatLng(-15.4630239974464, 28.363397732282127);
  static LatLng _initialPosition;
  final Set<Marker> _markers = {};
  static LatLng _lastMapPosition = _initialPosition;

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
  
  Future<String> getCurrentLocation() async {
    String res = "";
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    return res + position.latitude.toString() + ", " + position.longitude.toString();
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      controller1.complete(controller);
      getCurrentLocation().then((String ll){
          Map<String,String> params = {
         "query": "Pizza",
         "ll":  ll
          };
          sendFRequest(params).then((List<dynamic> response){
            if(response != null){
              Map<String, dynamic> mapped;
              List<dynamic> venues = response[1]["response"]["venues"];
              mapped = {"name": "Pizza", "itemData": venues};
              print(venues);
              setPinsOnMap(mapped);
            } 
          });
      });
    });
  }

  MapType _currentMapType = MapType.normal;

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void setPinsOnMap(Map<String, dynamic> itemModel){
    if(itemModel!=null){
      String itemName = itemModel["name"];
      List<dynamic> itemData = itemModel["itemData"];
      setState(() {
          for(int i=0; i<itemData.length; i++){
            //get latlang 
            String dataName = itemData[i]["name"].toString();
            Map<String, dynamic> dataLoc = itemData[i]["location"];
            LatLng venuePosition = new LatLng(dataLoc["lat"], dataLoc["lng"]); //check item class
            _markers.add(  
            Marker(
            markerId: MarkerId(venuePosition.toString()),
            position: venuePosition,
            infoWindow: InfoWindow(
                title: dataName,
                snippet: itemName,
                onTap: () {}),
            onTap: () {},
            icon: BitmapDescriptor.defaultMarker));
          }
      });
    }
  }

  _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(
              title: "Pizza Parlour",
              snippet: "This is a snippet",
              onTap: () {}),
          onTap: () {},
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  Widget mapButton(Function function, Icon icon, Color color) {
    return RawMaterialButton(
      onPressed: function,
      child: icon,
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: color,
      padding: const EdgeInsets.all(7.0),
    );
  }

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
      body: _initialPosition == null
          ? Container(
              child: Center(
                child: Text(
                  'loading map..',
                  style: TextStyle(
                      fontFamily: 'Avenir-Medium', color: Colors.grey[400]),
                ),
              ),
            )
          : Container(
              child: Stack(children: <Widget>[
                GoogleMap(
                  markers: _markers,
                  mapType: _currentMapType,
                  initialCameraPosition: CameraPosition(
                    target: _initialPosition,
                    zoom: 14.4746,
                  ),
                  onMapCreated: _onMapCreated,
                  zoomGesturesEnabled: true,
                  onCameraMove: _onCameraMove,
                  myLocationEnabled: true,
                  compassEnabled: true,
                  myLocationButtonEnabled: false,
                ),
              ]),
            ),
    );
  }
}
