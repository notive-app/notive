import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:notive_app/screens/constants.dart';

class ItemTile extends StatelessWidget {
  final bool isChecked;
  final String itemString;
  final Function checkCallback;
  final Function deleteCallback;
  final Function insertCallback;
  final Function changeItemName;

  ItemTile(
      {this.isChecked,
      this.itemString,
      this.checkCallback,
      this.deleteCallback,
      this.insertCallback,
      this.changeItemName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          child: ListTile(
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
      ),
      onLongPress: deleteCallback,
      onDoubleTap: changeItemName,
    );
  }
}

