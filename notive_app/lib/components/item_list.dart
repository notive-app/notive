import 'package:flutter/material.dart';
import 'package:notive_app/components/item_tile.dart';
import 'package:provider/provider.dart';
import 'package:notive_app/models/user_model.dart';

class ItemsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(
      builder: (context, user, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return ItemTile(
              itemString: user.lists[UserModel.curListIndex].items[index].name,
              isChecked:
                  user.lists[UserModel.curListIndex].items[index].isCompleted,
              checkCallback: (bool checkBoxState) {
                user.checkItem(UserModel.curListIndex,
                    user.lists[UserModel.curListIndex].items[index]);
              },
              deleteCallback: () {
                user.deleteItem(UserModel.curListIndex,
                    user.lists[UserModel.curListIndex].items[index]);
              },
            );
          },
          itemCount: user.lists[UserModel.curListIndex].itemsCount,
        );
      },
    );
  }
}
