import 'package:flutter/foundation.dart';
import 'dart:collection';
import 'package:notive_app/models/list_model.dart';
import 'package:notive_app/models/item_model.dart';

class UserModel extends ChangeNotifier {
  final int id;
  final String email;
  final String password;
  final String name;
  final String surname;
  static int curListIndex;
  List<ListModel> _lists = [];

  UserModel({this.id, this.email, this.password, this.name, this.surname});

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

  UnmodifiableListView<ListModel> get lists {
    return UnmodifiableListView(_lists);
  }

  void setLists(List<ListModel> lists) {
    this._lists = lists;
  }

  int get itemsCount {
    return _lists.length;
  }

  void addList(String newListName) async {
    //TODO API call to get List Id, then create a list with this ID
    final int listId = 0;
    final list = ListModel(id: listId, name: newListName);
    this._lists.add(list);
    //TODO how to handle db operations inside the same fxn
//    updateDatabase();
    notifyListeners();
  }

  void changeListName(ListModel list, String newName) {
    //TODO DB(list.id, newName) this will change list's name in DB , then update local lists
//    list.setName(newName);
//
//    notifyListeners();
//    updateDatabase();
  }

  void deleteList(ListModel list) {
    //TODO DB(list.id) this will delete the list in DB , then update local lists
    _lists.remove(list);
    notifyListeners();
  }

  void addItem(int listIndex, String itemName) {
    this._lists[listIndex].addItem(itemName);
    notifyListeners();
  }

  void checkItem(int listIndex, ItemModel item) {
    this._lists[listIndex].checkItem(item);
    notifyListeners();
  }

  void deleteItem(int listIndex, ItemModel item) {
    this._lists[listIndex].deleteItem(item);
    notifyListeners();
  }
}
