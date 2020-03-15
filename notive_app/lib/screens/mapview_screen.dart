import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notive_app/components/custom_bottom_nav.dart';
import 'package:notive_app/components/map.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'package:notive_app/models/user_model.dart';

class MapViewScreen extends StatelessWidget {
  static const String id = 'mapview_screen';

  @override
  Widget build(BuildContext context) {
    Future<List> chooseList(BuildContext context, UserModel userModel) async {
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
                  title: Text('Choose'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(userModel.listsCount, (index) {
                      return SimpleDialogOption(
                        onPressed: () {
                          userModel.changeCurrMap(index);
                          print(userModel.userMapIndex);
                          Navigator.pop(context);
                        },
                        child: Text(userModel.lists[index].name),
                      );
                    }),
                  ),
                  //actions: <Widget>[firstButton, secondButton],
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
        return Scaffold(
          bottomNavigationBar: CustomBottomNav(
            selectedIndex: 2,
          ),
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text('Map View'),
          ),
          body: Map(),
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
}
