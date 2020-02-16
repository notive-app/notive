import 'package:flutter/foundation.dart';
import 'package:notive_app/models/item_model.dart';
import 'dart:collection';

//TODO update DB first then local
class ListModel {
  final int id;
  String name;
  int numOfItems;
  int userId;
  List<ItemModel> _items = [];

  ListModel({@required this.id, @required this.name, this.numOfItems = 0});

  UnmodifiableListView<ItemModel> get items {
    return UnmodifiableListView(_items);
  }

  int get itemsCount {
    return _items.length;
  }

  void addItem(String newItemString) {
    final item = ItemModel(name: newItemString);
    _items.add(item);
  }

  void checkItem(ItemModel item) {
    item.checkCompletion();
  }

  void deleteItem(ItemModel item) {
    _items.remove(item);
  }

  void setName(String newName) {
    name = newName;
  }
}
