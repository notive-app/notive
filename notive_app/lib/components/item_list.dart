import 'package:flutter/material.dart';
import 'package:notive_app/components/item_tile.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:provider/provider.dart';

class ItemsList extends StatelessWidget {
  Future<void> deleteAlert(BuildContext context, UserModel user, int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to permanently delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Keep item'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Delete item'),
              onPressed: () {
                user.deleteItem(user.lists[user.curListIndex].items[index]);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> changeItemName(BuildContext context, UserModel user, int index) async {
    TextEditingController customController = TextEditingController();
    // create a pop up screen upon clicking add button
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Update the item name:"),
            content: TextField(
              controller: customController,
            ),
            actions: <Widget>[
              MaterialButton(
                color: kLightBlueColor,
                onPressed: () {
                  // close the dialog box when submit is clicked, change the name
                  var newName = customController.text.toString();
                  user.changeItemName(user.lists[user.curListIndex].items[index], newName);
                  Navigator.of(context).pop();
                },
                elevation: 0.5,
                child: Text("Done"),
              )
            ],
          );
        });
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
                deleteAlert(context, user, index);
              },
              changeItemName: (){
                changeItemName(context, user, index);
              },
            );
          },
          itemCount: user.lists[user.curListIndex].itemsCount,
        );
      },
    );
  }
}
