import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';
import 'package:notive_app/screens/constants.dart';
import 'package:notive_app/screens/range_settings_screen.dart';

class ItemTile extends StatelessWidget {
  final bool isChecked;
  final String itemString;
  final Function checkCallback;
  final Function deleteCallback;
  final Function insertCallback;
  final Function changeItemName;
  final Function configCallBack;

  ItemTile(
      {this.isChecked,
      this.itemString,
      this.checkCallback,
      this.deleteCallback,
      this.insertCallback,
      this.changeItemName,
      this.configCallBack});

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
        trailing: Wrap(
          spacing: 1,
          children: [
            Checkbox(
              activeColor: kLightBlueColor,
              value: isChecked,
              onChanged: checkCallback,
            ),
            PopupMenuButton(
              itemBuilder: (context) {
                var menu = List<PopupMenuEntry<Object>>();
                menu.add(PopupMenuItem(
                  child: Text("Edit Item"),
                  value: 1,
                ));

                menu.add(PopupMenuItem(
                  child: Text("Delete Item"),
                  value: 2,
                ));

                menu.add(PopupMenuItem(
                  child: Text("Item Configuration"),
                  value: 3,
                ));
                return menu;
              },
              initialValue: 0,
              onSelected: (value) {
                if (value == 1) {
                  //Edit item
                  changeItemName();
                } else if (value == 2) {
                  //Delete item
                  deleteCallback();
                } else if (value == 3) {
                  //Item configuration page
                  configCallBack();
                }
              },
              icon: Icon(
                Icons.dehaze,
                size: 25,
                //color: Colors.white,
              ),
              //color:, //can be changed
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                //side: BorderSide(color: Colors.black87),
              ),
            ),
          ],
        ),
      ),
      onLongPress: deleteCallback,
      onDoubleTap: changeItemName,
    );
  }
}
