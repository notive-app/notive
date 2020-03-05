import 'package:flutter/material.dart';
import 'package:notive_app/screens/constants.dart';

class ReusableListCard extends StatelessWidget {
  final Color color;
  final String listName;
  final Function onPress;
  final Function deleteCallback;

  ReusableListCard(
      {@required this.color, this.listName, this.onPress, this.deleteCallback});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            //TODO change this part so that it will be relative in size 
            child: Text('$listName', style: TextStyle(color: kOffWhiteColor, fontWeight: FontWeight.bold, fontSize: 15),),
          ),
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
    );
  }
}

//ListTile(
//title: Text(
//listName,
//style: null,
//),
////onLongPress: deleteCallback,
//);
