import 'package:flutter/material.dart';
import 'package:notive_app/components/item_tile.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:provider/provider.dart';

class ItemsList extends StatelessWidget {
  
  Future<String> createDialogBox(BuildContext context) async {
    TextEditingController customController = TextEditingController();
    // create a pop up screen upon clicking add button
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure you want to delete item"),
            content: TextField(
              controller: customController,
            ),
            actions: <Widget>[
              MaterialButton(
                color: kLightBlueColor,
                onPressed: () {
                  // close the dialog box when submit is clicked.
                  Navigator.of(context).pop(customController.text
                      .toString()); //to return text back to homescreen
                },
                elevation: 0.5,
                child: Text("Yes"),
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
              isChecked:
                  user.lists[user.curListIndex].items[index].isCompleted,
              checkCallback: (bool checkBoxState) {
                user.checkItem(user.lists[user.curListIndex].items[index]);
              },
              deleteCallback: () {
                //show dialog box 
              
                user.deleteItem(user.lists[user.curListIndex].items[index]);
                user.setAllItemVenues();
              },
              insertCallback: () {
                user.setAllItemVenues();
              },
            
            );
          },
          itemCount: user.lists[user.curListIndex].itemsCount,
        );
      },
    );
  }
}
