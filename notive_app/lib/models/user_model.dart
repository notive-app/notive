import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:notive_app/models/item_model.dart';
import 'package:notive_app/models/list_model.dart';
import 'package:notive_app/models/venue_model.dart';
import 'package:notive_app/util/request.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserModel extends ChangeNotifier {
  int id;
  String email;
  String username;
  int curListIndex;
  int userMapIndex = 0; // open first list in map by default
  List<ListModel> _lists = [];
  bool isLoggedIn = false;
  String lat;
  String long;

  UserModel({this.id, this.email, this.username});

  // fix this method--should we hold markers of users ?
  Set<Marker> getMarkers() {
    if (this.lists.length == 0) {
      return null;
    }
    //print("Keeps calling me");
    List<ItemModel> items = this.lists[this.userMapIndex].items;
    Set<Marker> markers = new Set();
    if (items != null) {
      for (int i = 0; i < items.length; i++) {
        for (int j = 0; j < items[i].venues.length; j++) {
          Venue currVenue = items[i].venues[j];
          LatLng venuePosition =
              new LatLng(currVenue.lat, currVenue.lng); //check item class
          markers.add(Marker(
              markerId: MarkerId(venuePosition.toString()),
              position: venuePosition,
              infoWindow: InfoWindow(
                  title: currVenue.name, snippet: items[i].name, onTap: () {}),
              onTap: () {},
              icon: BitmapDescriptor.defaultMarker));
        }
      }
    }
    return markers;
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
      this.username = user["name"];
      Position position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      this.lat = position.latitude.toString();
      this.long = position.longitude.toString();
      isLoggedIn = true;
      response = await fillUserLists();
      setLists(response);
      setAllItemVenues();

      //create local database
      DatabaseHelper helper = DatabaseHelper.instance;
      Database db = await helper.database;

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

  void changeListName(ListModel list, String newName) async {
    Map<String, dynamic> data = {"name": newName};
    List<dynamic> result = await updateUserList(data, list.id);
    if (result[0] == 200) {
      list.setName(newName);
      notifyListeners();
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

  void changeItemName(ItemModel item, String newName) async {
    Map<String, dynamic> data = {"name": newName};
    List<dynamic> result = await updateUserItem(data, item);
    if (result[0] == 200) {
      item.setName(newName);
      notifyListeners();
    }
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

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': this.id,
      'email': this.email,
      'username': this.username
    };

    return map;
  }

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    email = map['email'];
    username = map['username'];
  }
}

class DatabaseHelper {
  Database db;

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "MyDatabase.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE `user` (
	      `id` INTEGER PRIMARY KEY autoincrement,
	      `email` varchar(100) NOT NULL UNIQUE,
	      `username` varchar(100) NOT NULL UNIQUE)
        ''');
    print('DATABASE YARATILIYOR');
    await db.execute('''
        CREATE TABLE `list` (
	      `id` INTEGER PRIMARY KEY autoincrement,
	      `name` varchar(100) NOT NULL,
	      `userId` INTEGER NOT NULL,
        `isDone` INTEGER DEFAULT 0,
        `createdAt` INTEGER,
        `finishedAt` INTEGER,
        FOREIGN KEY (userId) REFERENCES user(id) on delete cascade on update cascade)
        ''');
    await db.execute('''
        CREATE TABLE `item` (
	      `id` INTEGER PRIMARY KEY autoincrement,
	      `name` varchar(100) NOT NULL,
	      `listId` INTEGER NOT NULL,
        `isCompleted` INTEGER DEFAULT 0,
        `createdAt` INTEGER,
        FOREIGN KEY (listId) REFERENCES list(id) on delete cascade on update cascade)
      ''');
    await db.execute('''
        CREATE TABLE `venue` (
	      `id` INTEGER PRIMARY KEY autoincrement,
        `itemId` INTEGER NOT NULL,
	      `name` varchar(200) NOT NULL,
	      `lat` real NOT NULL,
        `lng` real NOT NULL,
        `distance` integer NOT NULL,
        FOREIGN KEY (itemId) REFERENCES item(id) on delete cascade on update cascade)
       ''');
  }

//  Indents
}
