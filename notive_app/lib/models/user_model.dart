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

    List<dynamic> result= await createUserList(data);
    if(result[0] == 200){
      ListModel newList = new ListModel(
          id: result[1]['data']['list_id'],
          name: listName,
          userId: this.id,
          isDone: false,
          createdAt: result[1]['data']['created_at']
      );
      _lists.add(newList);
      notifyListeners();
    }
    //TODO add warning message in case of failure

  }

  void changeListName(ListModel list, String newName) {
    //TODO DB(list.id, newName) this will change list's name in DB , then update local lists
//    list.setName(newName);
//
//    notifyListeners();
//    updateDatabase();
  }

  void deleteList(ListModel list) async{
    int listId = list.id;
    List<dynamic> result = await deleteUserList(listId);

    if(result[0] == 200){
      this._lists.remove(list);
      notifyListeners();
    }
    //TODO add warning message in case of failure
  }

  void addItem(String itemName) async {
    Map<String,dynamic> data = {
      'name': itemName,
      'list_id': this._lists[this.curListIndex].id
    };

    List<dynamic> result= await createUserItem(data);

    if(result[0] == 200){
      ItemModel item = new ItemModel(
          id: result[1]['data']['item_id'],
          name: itemName,
          isCompleted: false,
          listId: this._lists[this.curListIndex].id,
          createdAt: result[1]['data']['created_at']
      );
      this._lists[curListIndex].addItem(item);
      notifyListeners();
    }
    //TODO add warning message in case of failure

  }

  void checkItem(ItemModel item) async {
    List<dynamic> result= await checkUserItem(item);

    if(result[0] == 200){
      this._lists[curListIndex].checkItem(item);
      notifyListeners();
    }
    //TODO add warning message in case of failure
  }

  void deleteItem(ItemModel item) async{
    List<dynamic> result = await deleteUserItem(item.id);

    if(result[0] == 200){
      this._lists[curListIndex].deleteItem(item);
      notifyListeners();
    }
    //TODO add warning message in case of failure
  }

  //just being used after login, therefore there is no need for notifying listeners
  void setLists(List<ListModel> lists) {
    this._lists = lists;
  }

}
