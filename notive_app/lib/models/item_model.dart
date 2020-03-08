import 'dart:collection';

import 'package:notive_app/models/venue_model.dart';
import 'package:notive_app/util/request.dart';

class ItemModel {
  final int id;
  String name;
  bool isCompleted;
  int listId;
  int createdAt;
  List<Venue> _venues = [];

  ItemModel(
      {this.id,
      this.name,
      this.isCompleted,
      this.listId,
      this.createdAt,
      });

  UnmodifiableListView<Venue> get venues{
    return UnmodifiableListView(_venues);
  }

  int get venuesCount {
    return _venues.length;
  }

  void checkCompletion() {
    isCompleted = !isCompleted;
  }

  void setVenues(List<Venue> venues) {
    this._venues = venues;
  }

  void setVenuesFromFSQ(String lat, String long) async{
    String query = this.name;
    String ll = lat + ", " + long;
    Map<String, String> params = {
      "query": query,
      "ll": ll
    };
    List<dynamic> response = await sendFRequest(params);
    List<dynamic> venueList = response[1]["response"]["venues"];
    for(var i=0; i<venueList.length; i++){
      addVenue(Venue.fromJson(venueList[i]));
    }
  }

  void addVenue(Venue venue) {
    _venues.add(venue);
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    bool flag = false;

    if (json['is_done'] == 1) {
      flag = true;
    }

    ItemModel newModel = ItemModel(
        id: json['id'],
        name: json['name'],
        isCompleted: flag,
        listId: json['list_id'],
        createdAt: json['created_at'],
        );
    return newModel;
  }
}
