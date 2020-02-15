import 'package:flutter/material.dart';

class NotiveList {
  String listName;
  bool isMuted;
  int numOfItems;
  int listId;

  NotiveList(
      {@required this.listId,
      @required this.listName,
      this.isMuted = false,
      this.numOfItems = 0});

  void checkIfMuted() {
    // TO DO
  }

  void setName(String newName) {
    //change list name
    listName = newName;
  }
}
