import 'dart:collection';

import 'package:notive_app/models/venue_model.dart';
import 'package:notive_app/util/notification.dart' as notif;
import 'package:notive_app/util/request.dart';


class ItemModel {
  final int id;
  String name;
  bool isCompleted;
  int listId;
  int createdAt;
  List<Venue> _venues = [];
  int selectedDist;
  int selectedFreq;
  bool isFiltered = true;

  ItemModel({
    this.id,
    this.name,
    this.isCompleted,
    this.listId,
    this.createdAt,
    this.selectedDist,
    this.selectedFreq
      });

  UnmodifiableListView<Venue> get venues{
    return UnmodifiableListView(_venues);
  }

  int get venuesCount {
    return _venues.length;
  }

  void setName(String newName){
    this.name = newName;
  }

  void setFiltered(bool newFiltered){
    this.isFiltered = newFiltered;
  }

  void checkCompletion() {
    isCompleted = !isCompleted;
  }

  void setVenues(List<Venue> venues) {
    this._venues = venues;
  }

  void removeVenueAtIndex(int i){
    this._venues.removeAt(i);
  }

  void setVenuesFromFSQ(String lat, String long, bool isLogin) async{
    String query = this.name;
    String ll = lat + ", " + long;
    Map<String, String> params = {
      "query": query,
      "ll": ll,
      "radius": this.selectedDist.toString()
    };
    List<dynamic> response = await sendFRequest(params);
    if(response[0]==200){
      _venues = [];
      List<dynamic> venueList = response[1]["response"]["venues"];
      if(isLogin == false){
        notif.Notification notification = new notif.Notification();
        notification.showNotificationWithoutSound(this.name);
      }
      for(var i=0; i<venueList.length; i++){
        addVenue(Venue.fromJson(venueList[i]));
      }

    }
    else{
      // problem is due to foursquare servers/requests 
      print(response[1]);
    }
  }

  void addVenue(Venue venue) {
    _venues.add(venue);
  }

  void setSelectedDist(double distance)
  {
    this.selectedDist = distance.round();
  }

  void setSelectedFreq(double freq)
  {
    this.selectedFreq = freq.round();
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
        selectedDist: json['distance'],
        selectedFreq: json['frequency'],
        );
    return newModel;
  }
}
