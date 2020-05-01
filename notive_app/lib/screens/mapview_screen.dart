import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';
import 'package:notive_app/components/map.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/models/venue_model.dart';

class MapViewScreen extends StatelessWidget {
  static const String id = 'mapview_screen';

  @override
  Widget build(BuildContext context) {
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
                    'Choose',
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

    return Consumer<UserModel>(
      builder: (context, user, child) {
        BorderRadiusGeometry radius = BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        );
        int tempDistance = 5000; //JUST FOR DEMO PURPOSES
        int numOfVenues = user.getVenues(tempDistance).length;
        List<Venue> venues = user.getVenues(tempDistance);
        return Scaffold(
          bottomNavigationBar: CustomBottomNav(
            selectedIndex: 2,
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Map View'),
          ),
          body: SlidingUpPanel(
            panelBuilder: (ScrollController sc) =>
                _scrollingList(sc, numOfVenues, venues, tempDistance), //PREF DISTANCE VERILECEK TEMP YERINE
            body: Center(
              child: Map(),
            ),
            borderRadius: radius,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: kLightBlueColor,
            onPressed: () async {
              chooseList(context, user);
            },
            child: Icon(Icons.list),
            elevation: 5.0,
          ),
        );
      },
    );
  }

  Widget _scrollingList(
      ScrollController sc, int numOfVenues, List<Venue> venues, int prefDist) {
    return ListView.builder(
      controller: sc,
      itemCount: numOfVenues,
      itemBuilder: (BuildContext context, int i) {
        return Column(
            //padding: const EdgeInsets.all(12.0),
            children: List.generate(
          numOfVenues,
          (index) {
            var placeName;
            var address;
            var distance;
            if(venues[index].distance < prefDist){
              placeName = venues[index].name;
              address = venues[index].address;
              distance = venues[index].distance;
            }
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: ListTile(
                leading: Icon(Icons.place, color: kPurpleColor, size: 45.0),
                title: Text('$placeName' + ' ($distance metres)'),
                subtitle: Text('$address'),
              ),
            );
          },
        ));
      },
    );
  }
}
