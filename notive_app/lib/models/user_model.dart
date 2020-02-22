import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:notive_app/models/item_model.dart';
import 'package:notive_app/models/list_model.dart';
import 'package:notive_app/util/request.dart';

class UserModel extends ChangeNotifier {
  int id;
  String email;
  String name;
  String surname;
  int curListIndex;
  List<ListModel> _lists = [];
  bool isLoggedIn = false;

  UserModel({this.id, this.email, this.name, this.surname});

  Future<bool> login(Map<String,dynamic> data) async{
    var response = await loginUser(data);
    var status = response[0];

    if(status == 200){
      var user = response[2];
      this.id = user["user_id"];
      this.email = user["email"];
      this.name = user["name"];
      this.surname = user["surname"];
      isLoggedIn = true;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signUp(Map<String,dynamic> data) async{
    var response = await signupUser(data);
    var status = response[0];

    if(status == 200){
      var loginData = new Map<String,dynamic>();
      loginData["email"] = data["email"];
      loginData["password"] = data["password"];
      return login(loginData);
    }
    return false;
  }

  void logout() {
    logoutUser();
    isLoggedIn = true;
    notifyListeners();
  }



  int get listsCount {
    return _lists.length;
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

  void addItem(String itemName) {
    this._lists[curListIndex].addItem(itemName);
    notifyListeners();
  }

  void checkItem(ItemModel item) {
    this._lists[curListIndex].checkItem(item);
    notifyListeners();
  }

  void deleteItem(ItemModel item) {
    this._lists[curListIndex].deleteItem(item);
    notifyListeners();
  }
}
