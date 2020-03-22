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
      UserModel userModel = this;
      await helper.addUser(db, userModel);
      await helper.getUser(db, userModel);

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
    print('SQLITE: Initializing...');
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

  // User
  Future addUser(Database db, UserModel user) async {
    Map map = user.toMap();
    int userID = map['id'];
    String name = map['username'];
    String email = map['email'];

    await db.transaction((txn) async {
      if (getUser(db, user) == null) {
        await txn.execute(
            'INSERT INTO user(id, username, email) VALUES(?, ?, ?)',
            [userID, name, email]);
        print('SQLITE: User with ID $userID is added.');
      }
    });
  }

  Future editUser(Database db, UserModel user) async {
    Map map = user.toMap();
    int userID = map['id'];
    String name = map['username'];
    String email = map['email'];

    await db.transaction((txn) async {
      await txn.execute(
          'UPDATE user SET username = ?, email = ? WHERE id = ?',
          [name, email, userID]);
      print('SQLITE: User with ID $userID is edited.');
    });
  }

  Future removeUser(Database db, UserModel user) async {
    Map map = user.toMap();
    int userID = map['id'];

    await db.transaction((txn) async {
      await txn.execute('DELETE FROM user WHERE id = ? LIMIT 1', [userID]);
      print('SQLITE: User with ID $userID is deleted.');
    });
  }

  Future getUser(Database db, UserModel user) async {
    Map map = user.toMap();
    int userID = map['id'];

    List<Map> users = await db.query('user',
        columns: ['id', 'username', 'email'],
        where: 'id = ?',
        whereArgs: [userID]);
    if (users.length > 0) {
      Map userData = users.first;
      print('SQLITE: User with ID : $userData');
      return userData;
    } else {
      return null;
    }
  }

  // List
  Future addList(Database db, ListModel list) async {
    int listID = list.id;
    String name = list.name;
    int userId = list.userId;
    bool isDone = list.isDone;
    int createdAt = list.createdAt;
    int finishedAt = list.finishedAt;

    await db.transaction((txn) async {
      if (getList(db, list) == null) {
        await txn.execute(
            'INSERT INTO list(id, name, userId, isDone, createdAt, finishedAt) VALUES(?, ?, ?, ?, ?, ?)',
            [listID, name, userId, isDone, createdAt, finishedAt]);
        print('SQLITE: List with ID $listID is added.');
      }
    });
  }

  Future editList(Database db, ListModel list) async {
    int listID = list.id;
    String name = list.name;
    int userId = list.userId;
    bool isDone = list.isDone;
    int createdAt = list.createdAt;
    int finishedAt = list.finishedAt;

    await db.transaction((txn) async {
      await txn.execute(
          'UPDATE list SET name = ?, userId = ?, isDone = ?, createdAt = ?, finishedAt = ? WHERE id = ?',
          [name, userId, isDone, createdAt, finishedAt, listID]);
      print('SQLITE: List with ID $listID is edited.');
    });
  }

  Future removeList(Database db, ListModel list) async {
    int listID = list.id;
    await db.transaction((txn) async {
      await txn.execute('DELETE FROM list WHERE id = ? LIMIT 1', [listID]);
      print('SQLITE: List with ID $listID is deleted.');
    });
  }

  Future getList(Database db, ListModel list) async {
    int listID = list.id;
    List<Map> lists = await db.query('list',
        columns: ['id', 'name', 'userId', 'isDone', 'createdAt', 'finishedAt'],
        where: 'id = ?',
        whereArgs: [listID]);
    if (lists.length > 0) {
      Map listData = lists.first;
      print('SQLITE: List with ID : $listData');
      return listData;
    } else {
      return null;
    }
  }

  // Item
  Future addItem(Database db, ItemModel item) async {
    int itemID = item.id;
    String name = item.name;
    int listId = item.listId;
    bool isCompleted = item.isCompleted;
    int createdAt = item.createdAt;

    await db.transaction((txn) async {
      if (getItem(db, item) == null) {
        await txn.execute(
            'INSERT INTO item(id, name, userId, isCompleted, createdAt) VALUES(?, ?, ?, ?, ?)',
            [itemID, name, listId, isCompleted, createdAt]);
        print('SQLITE: Item with ID $itemID is added.');
      }
    });
  }

  Future editItem(Database db, ItemModel item) async {
    int itemID = item.id;
    String name = item.name;
    int listId = item.listId;
    bool isCompleted = item.isCompleted;
    int createdAt = item.createdAt;

    await db.transaction((txn) async {
      await txn.execute(
          'UPDATE item SET name = ?, listId = ?, isCompleted = ?, createdAt = ?, WHERE id = ?',
          [name, listId, isCompleted, createdAt, itemID]);
      print('SQLITE: Item with ID $itemID is edited.');
    });
  }

  Future removeItem(Database db, ItemModel item) async {
    int itemID = item.id;
    await db.transaction((txn) async {
      await txn.execute('DELETE FROM item WHERE id = ? LIMIT 1', [itemID]);
      print('SQLITE: Item with ID $itemID is deleted.');
    });
  }

  Future getItem(Database db, ItemModel item) async {
    int itemID = item.id;
    List<Map> items = await db.query('item',
        columns: ['id', 'name', 'listId', 'isCompleted', 'createdAt'],
        where: 'id = ?',
        whereArgs: [itemID]);
    if (items.length > 0) {
      Map itemData = items.first;
      print('SQLITE: Item with ID : $itemData');
      return itemData;
    } else {
      return null;
    }
  }

  // Venue
  Future addVenue(Database db, Venue venue) async {
    int venueID = venue.id;
    String name = venue.name;
    int itemId = venue.itemId;
    double lat = venue.lat;
    double lng = venue.lng;
    int distance = venue.distance;

    await db.transaction((txn) async {
      if (getVenue(db, venue) == null) {
        await txn.execute(
            'INSERT INTO venue(id, name, itemId, lat, lng, distance) VALUES(?, ?, ?, ?, ?, ?)',
            [venueID, name, itemId, lat, lng, distance]);
        print('SQLITE: Venue with ID $venueID is added.');
      }
    });
  }

  Future editVenue(Database db, Venue venue) async {
    int venueID = venue.id;
    String name = venue.name;
    int itemId = venue.itemId;
    double lat = venue.lat;
    double lng = venue.lng;
    int distance = venue.distance;

    await db.transaction((txn) async {
      await txn.execute(
          'UPDATE venue SET name = ?, itemId = ?, lat = ?, lng = ?, distance = ? WHERE id = ?',
          [name, itemId, lat, lng, distance, venueID]);
      print('SQLITE: Venue with ID $venueID is edited.');
    });
  }

  Future removeVenue(Database db, Venue venue) async {
    int venueID = venue.id;
    await db.transaction((txn) async {
      await txn.execute('DELETE FROM venue WHERE id = ? LIMIT 1', [venueID]);
      print('SQLITE: Venue with ID $venueID is deleted.');
    });
  }

  Future getVenue(Database db, Venue venue) async {
    int venueID = venue.id;
    List<Map> venues = await db.query('venue',
        columns: ['id', 'name', 'itemId', 'lat', 'lng', 'distance'],
        where: 'id = ?',
        whereArgs: [venueID]);
    if (venues.length > 0) {
      Map venueData = venues.first;
      print('SQLITE: Venue with ID : $venueData');
      return venueData;
    } else {
      return null;
    }
  }

  //  Indents
}
