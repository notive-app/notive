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
      return await showDialog<List>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select List'),
            children: List.generate(userModel.listsCount, (index){
                return SimpleDialogOption(
                onPressed: () {
                  userModel.changeCurrMap(index);
                  print(userModel.userMapIndex);
                  Navigator.pop(context);
                },
                child: Text(userModel.lists[index].name),
              );
            }),
          );
        });
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
