import 'package:flutter/material.dart';
import 'package:notive_app/components/item_tile.dart';
import 'package:notive_app/models/user_model.dart';
import 'package:provider/provider.dart';

class ItemsList extends StatelessWidget {
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
                user.deleteItem(user.lists[user.curListIndex].items[index]);
              },
            );
          },
          itemCount: user.lists[user.curListIndex].itemsCount,
        );
      },
    );
  }
}
