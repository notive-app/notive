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
            );
          },
          itemCount: user.lists[user.curListIndex].itemsCount,
        );
      },
    );
  }
}
