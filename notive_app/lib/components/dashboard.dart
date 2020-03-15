import 'package:flutter/material.dart';
import 'package:notive_app/components/reusable_list_card.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/listview_screen.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  Future<void> deleteAlert(BuildContext context, bool confirm) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Destructive action.'),
                Text('Do you want to permanently delete this list?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Keep list.'),
              onPressed: () {
                confirm = false;
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Delete.'),
              onPressed: () {
                confirm = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    void openListView(String name) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ListViewScreen(
                  listName: name,
                )),
      );
    }

    return Consumer<UserModel>(
      builder: (context, user, child) {
        return GridView.count(
          crossAxisCount: 3,
          children: List.generate(user.listsCount, (index) {
            return ReusableListCard(
              color: kPurpleColor,
              listName: user.lists[index].name,
              onPress: () {
                user.curListIndex = index;
                openListView(user.lists[index].name);
              },
//              deleteCallback: () {
//                user.deleteList(user.lists[index]);
//              },
              deleteAlert: () {
                bool confirm = false;
                deleteAlert(context, confirm);
              },
            );
          }),
        );
      },
    );
  }
}
