import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:notive_app/models/item_model.dart';
import 'package:notive_app/models/list_model.dart';
import 'package:notive_app/models/venue_model.dart';
import 'package:notive_app/util/request.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  int id;
  String email;
  String name;
  String surname;
  int curListIndex;
  String password;
  String chosenTheme;

  int userMapIndex = 0; // open first list in map by default
  List<ListModel> _lists = []; //stands for unarchived lists
  List<ListModel> _archivedLists = [];
  String lat;
  String long;

  UserModel({this.id, this.email, this.name, this.surname});

  void setPassword(newPass) {
    password = newPass;
  }

  // fix this method--should we hold markers of users ?
  Set<Marker> getMarkers() {
    if (this.lists.length == 0) {
      return null;
    }
    List<ItemModel> items = this.lists[this.userMapIndex].items;
    Set<Marker> markers = new Set();
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].isFiltered == true && items[i].isCompleted == false){
          for (int j = 0; j < items[i].venues.length; j++) {
            Venue currVenue = items[i].venues[j];
            LatLng venuePosition =
            new LatLng(currVenue.lat, currVenue.lng); //check item class
            markers.add(Marker(
                markerId: MarkerId(venuePosition.toString()),
                position: venuePosition,
                infoWindow: InfoWindow(
                  title: currVenue.name,
                  snippet: items[i].name,
                  //onTap: () {},
                ),
                onTap: () {},
                icon: BitmapDescriptor.defaultMarker));
          }
        }

      }
    }
    return markers;
  }

  List<Venue> getVenues() {
    if (this.lists.length == 0) {
      return null;
    }
    List<Venue> venues = new List();
    List<ItemModel> items = this.lists[this.userMapIndex].items;
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        if (items[i].isFiltered == true && items[i].isCompleted == false){
          for (int j = 0; j < items[i].venues.length; j++) {
            venues.add(items[i].venues[j]);
          }
        }
      }
    }
    return venues;
  }

  void changeCurrMap(int newMapIndex) {
    this.userMapIndex = newMapIndex;
    notifyListeners();
  }

  Future<bool> login(Map<String, dynamic> data) async {
    var response = await loginUser(data);
    var status = response[0];
    if (status == 200) {
      var user = response[2];
      this.id = user["user_id"];
      this.email = user["email"];
      this.name = user["name"];
      this.surname = user["surname"];
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      this.lat = position.latitude.toString();
      this.long = position.longitude.toString();

      SharedPreferences prefs = await SharedPreferences.getInstance();
      var prevEmail = prefs.getString('email');

      if (prevEmail == null){
        await prefs.setString('email', email);
        await prefs.setString('password', data["password"]);
      }

      response = await fillUserLists();
      setLists(response);
      setAllItemVenues();
      notifyListeners();
      return Future<bool>.value(true);
    }
    return Future<bool>.value(false);
  }

  Future<bool> signUp(Map<String, dynamic> data) async {
    var response = await signUpUser(data);
    var status = response[0];

    if (status == 200) {
      var loginData = new Map<String, dynamic>();
      loginData["email"] = data["email"];
      loginData["password"] = data["password"];
      return login(loginData);
    }
    return false;
  }

  void logout() async{
    logoutUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("email");
    await prefs.remove("password");
    notifyListeners();
  }

  int get listsCount {
    return _lists.length;
  }

  UnmodifiableListView<ListModel> get lists {
    return UnmodifiableListView(_lists);
  }

  UnmodifiableListView<ListModel> get archivedLists {
    return UnmodifiableListView(_archivedLists);
  }

  int get itemsCount {
    return _lists.length;
  }

  void addList(String listName) async {
    Map<String, dynamic> data = {'name': listName};
    List<dynamic> result = await createUserList(data);
    if (result[0] == 200) {
      ListModel newList = new ListModel(
          id: result[1]['data']['list_id'],
          name: listName,
          userId: this.id,
          isDone: false,
          createdAt: result[1]['data']['created_at'],
          isArchived: false,
          isMuted: false);
      _lists.add(newList);
      this.changeCurrMap(0);
      notifyListeners();
    }
    //TODO add warning message in case of failure
  }

  void deleteList(ListModel list) async {
    int listId = list.id;
    //this.userMapIndex = this.curListIndex;
    List<dynamic> result = await deleteUserList(listId);

    if (result[0] == 200) {
      if (list.isArchived == true) {
        this._archivedLists.remove(list);
      } else {
        this._lists.remove(list);
      }
      this.changeCurrMap(0);
      notifyListeners();
    }
    //TODO add warning message in case of failure
  }

  void changeListName(ListModel list, String newName) async {
    Map<String, dynamic> data = {"name": newName};
    List<dynamic> result = await updateUserList(data, list.id);
    if (result[0] == 200) {
      list.setName(newName);
      notifyListeners();
    }
  }

  void changeListIsMuted(ListModel list) async {
    List<dynamic> result = await toggleMuteList(list.id);
    print(result);
    if (result[0] == 200) {

      list.toggleMuted();
      notifyListeners();
    }
  }

  void changePassword(UserModel user, String newPass) async {
    Map<String, dynamic> data = {"email": user.email, "password": newPass};
    List<dynamic> result = await updateUserPassword(data, user);
    if (result[0] == 200) {
      user.setPassword(newPass);
      notifyListeners();
    }
  }

  Future<void> archiveList(ListModel list) async {
    List<dynamic> result = await toggleArchiveList(list.id);
    if (result[0] == 200) {
      list.setArchived(true);
      print(result[1]);
      this._archivedLists.add(list);
      this._lists.remove(list);
      notifyListeners();
    } else {
      print(result[1]);
    }
  }

  Future<void> unarchiveList(ListModel list) async {
    List<dynamic> result = await toggleArchiveList(list.id);
    if (result[0] == 200) {
      list.setArchived(false);
      print(result[1]);
      this._lists.add(list);
      this._archivedLists.remove(list);
      notifyListeners();
    } else {
      print(result[1]);
    }
  }

  void addItem(String itemName) async {
    Map<String, dynamic> data = {
      'name': itemName,
      'list_id': this._lists[this.curListIndex].id
    };

    List<dynamic> result = await createUserItem(data);

    if (result[0] == 200) {
      ItemModel item = new ItemModel(
          id: result[1]['data']['item_id'],
          name: itemName,
          isCompleted: false,
          listId: this._lists[this.curListIndex].id,
          createdAt: result[1]['data']['created_at'],
          selectedDist: 5000,
          selectedFreq: 60,
      );
      this._lists[curListIndex].addItem(item);
      setItemVenues(item);
      notifyListeners();
    }
    //TODO add warning message in case of failure
  }

  void checkItem(ItemModel item) async {
    List<dynamic> result = await checkUserItem(item);

    if (result[0] == 200) {
      this._lists[curListIndex].checkItem(item);
      notifyListeners();
    }
    //TODO add warning message in case of failure
  }

  void deleteItem(ItemModel item) async {
    List<dynamic> result = await deleteUserItem(item.listId, item.id);

    if (result[0] == 200) {
      this._lists[curListIndex].deleteItem(item);
      notifyListeners();
    }
    //TODO add warning message in case of failure
  }

  void changeItemName(ItemModel item, String newName) async {
    Map<String, dynamic> data = {"name": newName};
    List<dynamic> result = await updateUserItem(data, item);
    if (result[0] == 200) {
      item.setName(newName);
      setItemVenues(item);
      notifyListeners();
    }
  }

  void changeItemDesiredDist(ItemModel item, double newDist) async {
    Map<String, dynamic> data = {"distance": newDist.round().toString()};
    List<dynamic> result = await updateUserItem(data, item);
    if (result[0] == 200) {
      setItemVenues(item);
    }
    notifyListeners();
  }

  void changeItemDesiredFreq(ItemModel item, double newFreq) async {
    Map<String, dynamic> data = {"frequency": newFreq.round().toString()};
    List<dynamic> result = await updateUserItem(data, item);
    if (result[0] == 200) {
      item.setSelectedFreq(newFreq.toDouble());
//      notifyListeners();
    }
  }

  void changeItemIsFiltered(ItemModel item, bool newValue){
    item.setFiltered(newValue);
    notifyListeners();
  }

  //just being used after login, therefore there is no need for notifying listeners
  void setLists(List<ListModel> lists) {
    this._lists = [];
    this._archivedLists = [];
    for (int i = 0; i < lists.length; i++) {
      if (lists[i].isArchived == false) {
        _lists.add(lists[i]);
      } else {
        _archivedLists.add(lists[i]);
      }
    }
  }

  void setItemVenues(ItemModel item, {bool isLogin=false}) async {
    await item.setVenuesFromFSQ(this.lat, this.long, isLogin);
  }

  void setAllItemVenues() async {
    for (var i = 0; i < lists.length; i++) {
      for (var j = 0; j < lists[i].items.length; j++) {
        await setItemVenues(lists[i].items[j], isLogin: true);
      }
    }
  }
}
