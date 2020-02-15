import 'package:flutter/foundation.dart';
import 'package:notive_app/models/item.dart';
import 'dart:collection';

//TODO update DB first then local
class ListModel extends ChangeNotifier {
  List<Item> _items = [];

  UnmodifiableListView<Item> get items {
    return UnmodifiableListView(_items);
  }

  int get itemsCount {
    return _items.length;
  }

  void addItem(String newItemString) {
    final item = Item(itemString: newItemString);
    _items.add(item);
    notifyListeners();
  }

  void updateItem(Item item) {
    item.checkCompletion();
    notifyListeners();
  }

  void deleteItem(Item item) {
    _items.remove(item);
    notifyListeners();
  }
}
