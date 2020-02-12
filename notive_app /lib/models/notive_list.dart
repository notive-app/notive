import 'package:flutter/material.dart';

class NotiveList{
  String listName;
  bool isMuted;
  int numOfItems;

  NotiveList({@required this.listName, this.isMuted=false, this.numOfItems=0});
  
  void checkIfMuted(){
    // TO DO
  }

  void changeName(String newName){
    //change list name
    listName = newName;
  }
}