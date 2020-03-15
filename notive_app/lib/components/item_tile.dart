import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notive_app/screens/constants.dart';

class ItemTile extends StatelessWidget {
  final bool isChecked;
  final String itemString;
  final Function checkCallback;
  final Function deleteCallback;
  final Function deleteAlert;
  final Function insertCallback;

  ItemTile(
      {this.isChecked,
      this.itemString,
      this.checkCallback,
      this.deleteCallback,
      this.insertCallback,
      this.deleteAlert});

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
        activeColor: kLightBlueColor,
        value: isChecked,
        onChanged: checkCallback,
      ),
      onLongPress: deleteCallback,
      onTap: deleteAlert,
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
