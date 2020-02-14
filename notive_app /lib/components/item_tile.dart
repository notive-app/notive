import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemTile extends StatelessWidget {
  final bool isChecked;
  final String itemString;
  final Function checkCallback;
  final Function deleteCallback;

  ItemTile(
      {this.isChecked,
      this.itemString,
      this.checkCallback,
      this.deleteCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        itemString,
        style: isChecked
            ? TextStyle(decoration: TextDecoration.lineThrough)
            : null,
      ),
      trailing: Checkbox(
        activeColor: Colors.lightBlueAccent,
        value: isChecked,
        onChanged: checkCallback,
      ),
      onLongPress: deleteCallback,
    );
  }
}

//
//class WishCheckBox extends StatelessWidget {
//  final bool checkBState;
//  final Function toggleCheckState;
//
//  WishCheckBox({this.checkBState, this.toggleCheckState});
//
//  @override
//  Widget build(BuildContext context) {
//    return Checkbox(
//        activeColor: Colors.lightBlueAccent,
//        value: checkBState,
//        onChanged: toggleCheckState);
//  }
//}
