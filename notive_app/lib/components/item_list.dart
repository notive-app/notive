import 'package:flutter/material.dart';
import 'package:notive_app/components/item_tile.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:provider/provider.dart';

class ItemsList extends StatelessWidget {
//  Future<String> createDialogBox(BuildContext context) async {
//    TextEditingController customController = TextEditingController();
//    // create a pop up screen upon clicking add button
//    return showDialog(
//        context: context,
//        builder: (context) {
//          return AlertDialog(
//            title: Text("Are you sure you want to delete item"),
//            content: TextField(
//              controller: customController,
//            ),
//            actions: <Widget>[
//              MaterialButton(
//                color: kLightBlueColor,
//                onPressed: () {
//                  // close the dialog box when submit is clicked.
//                  Navigator.of(context).pop(customController.text
//                      .toString()); //to return text back to homescreen
//                },
//                elevation: 0.5,
//                child: Text("Yes"),
//              )
//            ],
//          );
//        });
//  }

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
                Text('Do you want to permanently delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Keep item.'),
              onPressed: () {
                confirm = false;
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Delete item.'),
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
    return Consumer<UserModel>(
      builder: (context, user, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return ItemTile(
              itemString: user.lists[user.curListIndex].items[index].name,
              isChecked: user.lists[user.curListIndex].items[index].isCompleted,
              checkCallback: (bool checkBoxState) {
                user.checkItem(user.lists[user.curListIndex].items[index]);
              },
              deleteCallback: () {
                //show dialog box
                bool confirm = false;
                deleteAlert(context, confirm);
                if (confirm) {
                  user.deleteItem(user.lists[user.curListIndex].items[index]);
                }
              },
            );
          },
          itemCount: user.lists[user.curListIndex].itemsCount,
        );
      },
    );
  }
}
