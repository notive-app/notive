import 'dart:collection';

import 'package:notive_app/models/item_model.dart';

//TODO update DB first then local
class ListModel {
  final int id;
  String name;
  int userId;
  bool isDone;
  int createdAt;
  int finishedAt;
  List<ItemModel> _items = [];

  ListModel({this.id, this.name, this.userId, this.isDone, this.createdAt});

  UnmodifiableListView<ItemModel> get items {
    return UnmodifiableListView(_items);
  }

  int get itemsCount {
    return _items.length;
  }

  //just being used after login, therefore there is no need for notifying listeners
  void setItems(List<ItemModel> items) {
    this._items = items;
  }

  void addItem(ItemModel item) {
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

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      id: json['id'],
      name: json['name'],
      userId: json['user_id'],
      isDone: false,
      createdAt: json['created_at']
    );
  }
}
