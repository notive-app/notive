import 'dart:collection';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:notive_app/models/item_model.dart';
import 'package:notive_app/models/list_model.dart';
import 'package:notive_app/models/venue_model.dart';
import 'package:notive_app/util/request.dart';
import 'package:geolocator/geolocator.dart';

class UserModel extends ChangeNotifier {
  int id;
  String email;
  String name;
  String surname;
  int curListIndex;
  int userMapIndex = 0; // open first list in map by default 
  List<ListModel> _lists = [];
  bool isLoggedIn = false;
  String lat;
  String long;

  UserModel({this.id, this.email, this.name, this.surname});

  // fix this method--should we hold markers of users ?
  Set<Marker> getMarkers(){
    if(this.lists.length == 0){
      return null;
    }
    //print("Keeps calling me");
    List<ItemModel> items = this.lists[this.userMapIndex].items;
    Set<Marker> markers = new Set(); 
    if(items!=null){
        for(int i=0; i<items.length; i++){
          for(int j = 0; j<items[i].venues.length; j++){
            Venue currVenue = items[i].venues[j];
              LatLng venuePosition = new LatLng(currVenue.lat, currVenue.lng); //check item class
              markers.add(
              Marker(
                  markerId: MarkerId(venuePosition.toString()),
                  position: venuePosition,
                  infoWindow: InfoWindow(
                      title: currVenue.name,
                      snippet: items[i].name,
                      onTap: () {}),
                  onTap: () {},
                  icon: BitmapDescriptor.defaultMarker));
          }
        }
    }
    return markers;
 }

  void changeCurrMap(int newMapIndex){
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
      isLoggedIn = true;
      response = await fillUserLists();
      setLists(response);
      setAllItemVenues();
      notifyListeners();
      return true;
    }
    return false;
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
    Map<String, dynamic> data = {'name': listName};

    List<dynamic> result = await createUserList(data);
    if (result[0] == 200) {
      ListModel newList = new ListModel(
          id: result[1]['data']['list_id'],
          name: listName,
          userId: this.id,
          isDone: false,
          createdAt: result[1]['data']['created_at']);
      _lists.add(newList);
      this.changeCurrMap(0);
      notifyListeners();
    }
    //TODO add warning message in case of failure
  }

  void deleteList(ListModel list) async {
    int listId = list.id;
    this.userMapIndex = this.curListIndex;
    List<dynamic> result = await deleteUserList(listId);

    if (result[0] == 200) {
      this._lists.remove(list);
      this.changeCurrMap(0);
      notifyListeners();
    }
    //TODO add warning message in case of failure
  }
  
  void changeListName(ListModel list, String newName) {
    list.setName(newName);
    notifyListeners();
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
          createdAt: result[1]['data']['created_at']);
      this._lists[curListIndex].addItem(item);
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

  void changeItemName(ItemModel item, String newName) async{
   item.changeName(newName);
   notifyListeners();
  }

  //just being used after login, therefore there is no need for notifying listeners
  void setLists(List<ListModel> lists) {
    this._lists = lists;
  }

  void setItemVenues(ItemModel item) async {
    await item.setVenuesFromFSQ(this.lat, this.long);
  }

  void setAllItemVenues() async {
    for (var i = 0; i < lists.length; i++) {
      for (var j = 0; j < lists[i].items.length; j++) {
        await setItemVenues(lists[i].items[j]);
      }
    }
    //notifyListeners();
  }
}

