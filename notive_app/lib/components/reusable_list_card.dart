import 'package:flutter/material.dart';

class ReusableListCard extends StatelessWidget {
  final Color color;
  final String listName;
  final Function onPress;
  final Function deleteCallback;

  ReusableListCard({@required this.color, this.listName, this.onPress, this.deleteCallback});


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text('$listName'),
        )),
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
