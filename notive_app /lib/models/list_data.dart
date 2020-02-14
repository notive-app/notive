import 'package:flutter/foundation.dart';
import 'package:notive_app/models/notive_list.dart';
import 'dart:collection';

class ListData extends ChangeNotifier {
  List<NotiveList> _lists = [];

  UnmodifiableListView<NotiveList> get lists {
    return UnmodifiableListView(_lists);
  }

  int get itemsCount {
    return _lists.length;
  }

  void addList(String newListString) {
    final list = NotiveList(listName: newListString);
    _lists.add(list);
    notifyListeners();
  }

  void changeListName(NotiveList list) {
    // TO DO
    // list.changeName(new);
    // notifyListeners();
  }

  void deleteList(NotiveList list) {
    _lists.remove(list);
    notifyListeners();
  }
}
