import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notive_app/components/reusable_list_card.dart';
import 'package:notive_app/models/list_model.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/listview_screen.dart';
import 'package:provider/provider.dart';

class Dashboard extends StatelessWidget {
  final String type;
  Dashboard({this.type = 'regular'});

  Future<void> deleteAlert(
      BuildContext context, UserModel user, ListModel list) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Do you want to permanently delete this list?'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Keep list'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () {
                user.deleteList(list);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> changeListName(
      BuildContext context, UserModel user, ListModel list) async {
    TextEditingController customController = TextEditingController();
    // create a pop up screen upon clicking add button
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Please Enter the List Name:"),
            content: TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(35),
              ],
              controller: customController,
            ),
            actions: <Widget>[
              MaterialButton(
                color: kLightBlueColor,
                onPressed: () {
                  // close the dialog box when submit is clicked, change the name
                  var newName = customController.text.toString();
                  user.changeListName(list, newName);
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
        List<ListModel> list = [];
        if (type == 'regular') {
          list = user.lists;
        } else if (type == 'archived') {
          list = user.archivedLists;
        }
        return GridView.count(
          crossAxisCount: 2,
          children: List.generate(list.length, (index) {
            return ReusableListCard(
              color: kPurpleColor,
              list: list[index],
              onPress: () {
                if (list[index].isArchived == false) {
                  user.curListIndex = index;
                  openListView(list[index].name);
                } else {}
              },
              deleteCallback: () {
                deleteAlert(context, user, list[index]);
              },
              changeListName: () {
                changeListName(context, user, list[index]);
              },
              archiveList: () {
                user.archiveList(list[index]);
              },
              unarchiveList: () {
                user.unarchiveList(list[index]);
              },
            );
          }),
        );
      },
    );
  }
}
