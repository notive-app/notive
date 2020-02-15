import 'package:flutter/foundation.dart';
import 'package:notive_app/models/notive_list.dart';
import 'dart:collection';
import 'user.dart';

class NotiveModel extends ChangeNotifier {
  User user;
  List<NotiveList> _lists = [];

  int get listsCount {
    return _lists.length;
  }

  void updateDatabase() {
    //TODO set DB list to _lists
  }

  void updateLocal() {
    //TODO set _lists to DB list
  }

  //get lists from database
  //TODO check if async or await
  void initializeLists() async {
    //TODO API call if API returns 200 , update lists (dashboard)
  }

  UnmodifiableListView<NotiveList> get lists {
    return UnmodifiableListView(_lists);
  }

  int get itemsCount {
    return _lists.length;
  }

  void addList(String newListName) async {
    //TODO API call to get List Id, then create a list with this ID
    final int listId = 0;
    final list = NotiveList(listId: listId, listName: newListName);
    _lists.add(list);
    //TODO how to handle db operations inside the same fxn
    updateDatabase();
    notifyListeners();
  }

  void changeListName(NotiveList list, String newName) {
    //TODO DB(list.id, newName) this will change list's name in DB , then update local lists
//    list.setName(newName);
//
//    notifyListeners();
//    updateDatabase();
  }

  void deleteList(NotiveList list) {
    //TODO DB(list.id) this will delete the list in DB , then update local lists
    _lists.remove(list);
    notifyListeners();
  }
}
