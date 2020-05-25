import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';
import 'package:notive_app/components/item_checkbox.dart';
import 'package:notive_app/components/map.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/models/venue_model.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'constants.dart';

class MapViewScreen extends StatelessWidget {
  static const String id = 'mapview_screen';

  @override
  Widget build(BuildContext context) {
    Future<List> filterByItem(BuildContext context, UserModel user) async {
      return await showGeneralDialog<List>(
          barrierColor: Colors.black.withOpacity(0.7),
          transitionBuilder: (context, a1, a2, widget) {
            final curvedValue = Curves.fastOutSlowIn.transform(a1.value) - 1.0;
            return Transform(
              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  title: Text(
                    'Filter items',
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                        user.lists[user.userMapIndex].itemsCount, (index) {
                      return ItemCheckBox(
                        item: user.lists[user.userMapIndex].items[index],
                      );
                    }),
                  ),
                ),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 200),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {});
    }

    Future<List> chooseList(BuildContext context, UserModel user) async {
      return await showGeneralDialog<List>(
          barrierColor: Colors.black.withOpacity(0.7),
          transitionBuilder: (context, a1, a2, widget) {
            final curvedValue = Curves.fastOutSlowIn.transform(a1.value) - 1.0;
            return Transform(
              transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
              child: Opacity(
                opacity: a1.value,
                child: AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0)),
                  title: Text(
                    'Choose a list',
                    textAlign: TextAlign.center,
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(user.listsCount, (index) {
                      return SimpleDialogOption(
                        onPressed: () {
                          user.changeCurrMap(index);
                          Navigator.pop(context);
                        },
                        child: Text(user.lists[index].name),
                      );
                    }),
                  ),
                ),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 200),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {});
    }

    Map map = new Map();
    return Consumer<UserModel>(
      builder: (context, user, child) {
        BorderRadiusGeometry radius = BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        );
        List<Venue> venues = user.getVenues();
        int numOfVenues = 0;
        if (venues != null) {
          numOfVenues = venues.length;
        }

        return Scaffold(
          bottomNavigationBar: CustomBottomNav(
            selectedIndex: 2,
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Map View'),
          ),
          body: SlidingUpPanel(
            header: Padding(
              padding: const EdgeInsets.all(10.0),
//              child: Icon(
//                Icons.linear_scale,
//                color: Colors.black,
//              ),
            ),
            collapsed: _floatingCollapsed(),
            maxHeight: MediaQuery.of(context).size.height * 0.50,
            backdropEnabled: true,
            backdropTapClosesPanel: true,
            borderRadius: radius,
            panelBuilder: (ScrollController sc) =>
                _scrollingList(sc, numOfVenues, venues, map),
            body: Center(
              child: map,
            ),
          ),
          floatingActionButton: SpeedDial(
            // both default to 16
            marginRight: 18,
            marginBottom: 20,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            // this is ignored if animatedIcon is non null
            // child: Icon(Icons.add),
            visible: true,
            // If true user is forced to close dial manually
            // by tapping main button and overlay is not rendered.
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () {},
            onClose: () {},
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 8.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                child: Icon(
                  Icons.filter_list,
                  color: Colors.white,
                ),
                backgroundColor: kRed,
                label: 'Filter items',
                labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
                onTap: () async {
                  filterByItem(context, user);
                },
              ),
              SpeedDialChild(
                child: Icon(
                  Icons.list,
                  color: Colors.white,
                ),
                backgroundColor: kDeepBlue,
                label: 'Choose a list',
                labelStyle: TextStyle(fontSize: 18.0, color: Colors.black),
                onTap: () async {
                  chooseList(context, user);
                },
              ),
            ],
          ),
//          floatingActionButton: FloatingActionButton(
//            backgroundColor: kLightBlueColor,
//            onPressed: () async {
//              chooseList(context, user);
//            },
//            child: Icon(Icons.list),
//            elevation: 5.0,
//          ),
        );
      },
    );
  }

  Widget _scrollingList(
      ScrollController sc, int numOfVenues, List<Venue> venues, Map map) {
    return ListView.builder(
      controller: sc,
      itemCount: numOfVenues,
      itemBuilder: (BuildContext context, int i) {
        return Column(
          children: <Widget>[
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: Icon(
                Icons.linear_scale,
                color: Colors.black,
              ),
            ),
            Column(
              children: List.generate(
                numOfVenues,
                (index) {
                  var placeName;
                  var address;
                  var distance;
                  var lat;
                  var lng;

                  placeName = venues[index].name;
                  address = venues[index].address;
                  distance = venues[index].distance;
                  lat = venues[index].lat;
                  lng = venues[index].lng;

                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: kLightOrange, width: 1),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    margin:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: ListTile(
                        leading:
                            Icon(Icons.place, color: kMediumOrange, size: 45.0),
                        title: Text('$placeName' + ' ($distance metres)'),
                        subtitle: Text('$address'),
                        onTap: () {
                          sc.animateTo(0.0,
                              curve: Curves.easeOut,
                              duration: const Duration(milliseconds: 300));
                          map.changeCameraPos(LatLng(lat, lng));
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _floatingCollapsed() {
  return Container(
    decoration: BoxDecoration(
      color: kDeepOrange,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(24.0),
        topRight: Radius.circular(24.0),
      ),
    ),
    child: Center(
      child: Text(
        "Slide to see in list view",
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
