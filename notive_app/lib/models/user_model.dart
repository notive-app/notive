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
      print('listeleri almaya geldim');
      response = await fillUserLists();
      setLists(response);

      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> signUp(Map<String,dynamic> data) async{
    var response = await signUpUser(data);
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
    isLoggedIn = false;
    notifyListeners();
  }

  int get listsCount {
    return _lists.length;
  }

  UnmodifiableListView<ListModel> get lists {
    return UnmodifiableListView(_lists);
  }

  int get itemsCount {
    return _lists.length;
  }

  void addList(String listName) async {
    Map<String,dynamic> data = {
      'name': listName
    };

    List<int> result= await createList(data);
    ListModel newList = new ListModel(
      id: result[0],
      name: listName,
      userId: this.id,
      isDone: false,
      createdAt: result[1]
    );

    _lists.add(newList);
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

  void addItem(String itemName) async {
    Map<String,dynamic> data = {
      'name': itemName,
      'list_id': this._lists[this.curListIndex].id
    };

    List<int> result= await createItem(data);
    ItemModel item = new ItemModel(
        id: result[0],
        name: itemName,
        isCompleted: false,
        listId: this.curListIndex,
        createdAt: result[1]
    );

    this._lists[curListIndex].addItem(item);
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

  //just being used after login, therefore there is no need for notifying listeners
  void setLists(List<ListModel> lists) {
    this._lists = lists;
  }

}
