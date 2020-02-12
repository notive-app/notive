import 'package:flutter/material.dart';
import 'package:notive_app/components/item_tile.dart';
import 'package:provider/provider.dart';
import 'package:notive_app/models/item_data.dart';

class ItemsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ItemData>(
      builder: (context, itemData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            return ItemTile(
              itemString: itemData.items[index].itemString,
              isChecked: itemData.items[index].isCompleted,
              checkCallback: (bool checkBoxState) {
                itemData.updateItem(itemData.items[index]);
              },
              deleteCallback: () {
                itemData.deleteItem(itemData.items[index]);
              },
            );
          },
          itemCount: itemData.itemsCount,
        );
      },
    );
  }
}
