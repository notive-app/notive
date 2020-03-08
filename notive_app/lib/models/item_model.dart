import 'package:notive_app/util/request.dart';
import 'dart:async';

class ItemModel {
  final int id;
  String name;
  bool isCompleted;
  int listId;
  int createdAt;
  ItemData itemData;

  ItemModel(
      {this.id,
      this.name,
      this.isCompleted,
      this.listId,
      this.createdAt,
      this.itemData});

  void checkCompletion() {
    isCompleted = !isCompleted;
  }

  //Future get init_done => this.itemData;

  ItemData setItemData(query) {
    Map<String, String> params = {"query": query.toString()};
    sendFRequest(params).then((var response) {
      this.itemData = ItemData.fromJson(response[1]['response']);
      return ItemData.fromJson(response[1]['response']);
    });
    //try {

    //} catch (e) {
    //print("error handled");
    //}
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    bool flag = false;

    if (json['is_done'] == 1) {
      flag = true;
    }

    ItemData myData;
    //myData.setItemData(json['name']);

    ItemModel newModel = ItemModel(
        id: json['id'],
        name: json['name'],
        isCompleted: flag,
        listId: json['list_id'],
        createdAt: json['created_at'],
        itemData: myData);
    //newModel.itemData = setItemData(json['name']);
    print(newModel.itemData.toString());
    return newModel;
  }
}

class Venue {
  final String id;
  String name;
  double lat;
  double lng;
  int distance;
  List<dynamic> address;
  String categoryName;
  String categoryNamePlural;
  String categoryShortName;

  Venue(this.id, this.name, this.lat, this.lng, this.distance, this.address,
      this.categoryName, this.categoryNamePlural, this.categoryShortName);

  @override
  String toString() {
    return this.id +
        ", " +
        this.name +
        ", " +
        this.lat.toString() +
        ", " +
        this.lng.toString() +
        ", " +
        this.distance.toString() +
        ", " +
        this.address.toString() +
        ", " +
        this.categoryName +
        ", " +
        this.categoryNamePlural +
        ", " +
        this.categoryShortName;
  }
}

class ItemData {
  List<Venue> venues;

  ItemData(this.venues);

  factory ItemData.fromJson(Map<String, dynamic> json) {
    List<dynamic> venues = json['venues'];
    List<Venue> result = new List();
    for (var i = 0; i < venues.length; i++) {
      Map<String, dynamic> venue = venues[i];
      Venue obj = new Venue(
          venue["id"],
          venue["name"],
          venue["location"]["lat"],
          venue["location"]["lng"],
          venue["location"]["distance"],
          venue["location"]["formattedAddress"],
          venue["categories"][0]["name"],
          venue["categories"][0]["pluralName"],
          venue["categories"][0]["shortName"]);
      result.add(obj);
    }
    return ItemData(result);
  }

  @override
  String toString() {
    String res = "";
    for (var i = 0; i < this.venues.length; i++) {
      res += venues[i].toString() + " ";
    }
    return res;
  }
}
