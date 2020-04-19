import 'package:flutter/material.dart';
import 'package:notive_app/models/list_model.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ReusableListCard extends StatelessWidget {
  final Color color;
  final ListModel list;
  final Function onPress;
  final Function deleteCallback;
  final Function changeListName;
  final Function archiveList;
  final Function unarchiveList;

  ReusableListCard(
      {@required this.color,
      this.list,
      this.onPress,
      this.deleteCallback,
      this.changeListName,
      this.archiveList,
      this.unarchiveList});

  @override
  Widget build(BuildContext context) {
    var listName = this.list.name;
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton(
                itemBuilder: (context) {
                  var menu = List<PopupMenuEntry<Object>>();
                  if (list.isArchived == false) {
                    menu.add(PopupMenuItem(
                      child: Text("Archive List"),
                      value: 1,
                    ));
                    menu.add(PopupMenuItem(
                      child: Text("Mute List"),
                      value: 2,
                    ));
                  } else {
                    menu.add(PopupMenuItem(
                      child: Text("Unarchive List"),
                      value: 5,
                    ));
                  }
                  menu.add(PopupMenuItem(
                    child: Text("Delete List"),
                    value: 3,
                  ));
                  menu.add(PopupMenuItem(
                    child: Text("Rename List"),
                    value: 4,
                  ));
                  return menu;
                },
                initialValue: 0,
                onSelected: (value) {
                  if (value == 1) {
                    //Archive List
                    archiveList();
                  } else if (value == 2) {
                    //Mute List
                  } else if (value == 3) {
                    //Delete List
                    deleteCallback();
                  } else if (value == 4) {
                    //Rename List
                    changeListName();
                  } else if (value == 5) {
                    unarchiveList();
                  }
                },
                icon: Icon(
                  Icons.dehaze,
                  size: 25,
                  color: Colors.white,
                ),
                //color:, //can be changed
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  //side: BorderSide(color: Colors.black87),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                //TODO change this part so that it will be relative in size
                child: AutoSizeText(
                  '$listName',
                  style: TextStyle(
                    color: kOffWhiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 3,
                ),
              ),
            ),
          ],
        ),
//        width: 150.0,
//        height: 150.0,
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      onLongPress: deleteCallback,
      onDoubleTap: changeListName,
    );
  }
}
