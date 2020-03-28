import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:notive_app/screens/constants.dart';

class ReusableListCard extends StatelessWidget {
  final Color color;
  final String listName;
  final Function onPress;
  final Function deleteCallback;
  final Function changeListName;

  ReusableListCard(
      {@required this.color,
      this.listName,
      this.onPress,
      this.deleteCallback,
      this.changeListName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: Text("Archive List"),
                    value: 1,
                  ),
                  PopupMenuItem(
                    child: Text("Mute List"),
                    value: 2,
                  ),
                  PopupMenuItem(
                    child: Text("Delete List"),
                    value: 3,
                  ),
                  PopupMenuItem(
                    child: Text("Rename List"),
                    value: 4,
                  ),
                ],
                initialValue: 0,
                onSelected: (value) {
                  if(value == 1){
                    //Archive List
                  }
                  else if(value==2){
                    //Mute List
                  }
                  else if(value == 3){
                    //Delete List
                    deleteCallback();
                  }
                  else if(value == 4){
                    //Rename List
                    changeListName();
                  }
                },
                icon: Icon(
                  Icons.dehaze,
                  size: 20,
                  color: Colors.white,
                ),
                //color:, //can be changed
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  //side: BorderSide(color: Colors.black87),
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                //TODO change this part so that it will be relative in size
                child: Text(
                  '$listName',
                  style: TextStyle(
                      color: kOffWhiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        ),
        width: 150.0,
        height: 150.0,
        margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onLongPress: deleteCallback,
      onDoubleTap: changeListName,
    );
  }
}
