import 'package:flutter/foundation.dart';
import 'package:notive_app/models/item_model.dart';
import 'dart:collection';

//TODO update DB first then local
class ListModel extends ChangeNotifier {
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
    print('name');
    print(this.name);
    _items.add(item);
    notifyListeners();
  }

  void updateItem(ItemModel item) {
    item.checkCompletion();
    notifyListeners();
  }

  void deleteItem(ItemModel item) {
    _items.remove(item);
    notifyListeners();
  }

  void setName(String newName) {
    name = newName;
    notifyListeners();
  }
}
